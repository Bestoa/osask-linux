#include "asmlib/lib.h"
#include "timer.h"
#include "int.h"
#include "fifo.h"
#include "mtask.h"

#define PIT_CTRL    0x0043
#define PIT_CNT0    0x0040

struct TIMERCTL timerctl;

#define TIMER_FLAGS_ALLOC   1
#define TIMER_FLAGS_USING   2

void init_pit(void)
{
    int i;
    struct TIMER *t;
    io_out8(PIT_CTRL, 0x34);
    io_out8(PIT_CNT0, 0x9c);
    io_out8(PIT_CNT0, 0x2e);
    timerctl.count = 0;
    for (i = 0; i < MAX_TIMER; i++) {
        timerctl.timers0[i].flags = 0;
    }
    /* the guard timer */
    t = timer_alloc();
    t->timeout = 0xffffffff;
    t->flags = TIMER_FLAGS_USING;
    t->next = 0;
    timerctl.t0 = t;
    timerctl.next = 0xffffffff;
    return;
}

struct TIMER *timer_alloc(void)
{
    int i;
    for (i = 0; i < MAX_TIMER; i++) {
        if (timerctl.timers0[i].flags == 0) {
            timerctl.timers0[i].flags = TIMER_FLAGS_ALLOC;
            timerctl.timers0[i].flags2 = 0;
            return &timerctl.timers0[i];
        }
    }
    return 0;
}

void timer_free(struct TIMER *timer)
{
    timer->flags = 0;
    return;
}

void timer_init(struct TIMER *timer, struct FIFO32 *fifo, int data)
{
    timer->fifo = fifo;
    timer->data = data;
    return;
}

void timer_settime(struct TIMER *timer, unsigned int timeout)
{
    int e, i, j;
    struct TIMER *t, *s;
    timer->timeout = timeout + timerctl.count;
    timer->flags = TIMER_FLAGS_USING;
    e = io_load_eflags();
    io_cli(); /* Disable CLI, we need to change the timer list */
    t = timerctl.t0;
    /* New timer is the first timeout one */
    if (timer->timeout <= t->timeout) {
        timerctl.t0 = timer;
        timer->next = t;
        timerctl.next = timer->timeout;
        io_store_eflags(e);
        return;
    }
    /* Insert new timer */
    for (;;) {
        s = t;
        t = t->next;
        if (timer->timeout <= t->timeout) {
            s->next = timer;
            timer->next = t;
            io_store_eflags(e);
            return;
        }
    }
}

void inthandler20(int *esp)
{
    struct TIMER *timer;
    char ts = 0;
#ifdef SLOWDOWN
    static int count = 0;
#endif
    io_out8(PIC0_OCW2, 0x60);
#ifdef SLOWDOWN
    if (count++ < SLOWDOWN)
        return;
    count = 0;
#endif
    timerctl.count++;
    if (timerctl.next > timerctl.count) {
        return;
    }
    timer = timerctl.t0;
    for (;;) {
        /* Found the first no timeout timer */
        if (timer->timeout > timerctl.count) {
            break;
        }
        /* Rest timeout timer */
        timer->flags = TIMER_FLAGS_ALLOC;
        if (timer != task_timer) {
            fifo32_put(timer->fifo, timer->data);
        } else {
            ts = 1;
        }
        timer = timer->next;
    }
    timerctl.t0 = timer;
    timerctl.next = timer->timeout;
    if (ts != 0) {
        task_switch();
    }
    return;
}

int timer_cancel(struct TIMER *timer)
{
    int e;
    struct TIMER *t;
    e = io_load_eflags();
    io_cli();
    if (timer->flags == TIMER_FLAGS_USING) {
        if (timer == timerctl.t0) {
            t = timer->next;
            timerctl.t0 = t;
            timerctl.next = t->timeout;
        } else {
            t = timerctl.t0;
            for (;;) {
                if (t->next == timer) {
                    break;
                }
                t = t->next;
            }
            t->next = timer->next;
        }
        timer->flags = TIMER_FLAGS_ALLOC;
        io_store_eflags(e);
        return 1;
    }
    io_store_eflags(e);
    return 0;
}

void timer_cancelall(struct FIFO32 *fifo)
{
    int e, i;
    struct TIMER *t;
    e = io_load_eflags();
    io_cli();
    for (i = 0; i < MAX_TIMER; i++) {
        t = &timerctl.timers0[i];
        if (t->flags != 0 && t->flags2 != 0 && t->fifo == fifo) {
            timer_cancel(t);
            timer_free(t);
        }
    }
    io_store_eflags(e);
    return;
}
