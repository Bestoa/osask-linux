#ifndef __MTASK_H__
#define __MTASK_H__
#include "memory.h"
#include "fifo.h"
#include "dsctbl.h"

#define MAX_TASKS       1000
#define MAX_TASKS_LV    100
#define MAX_TASKLEVELS  10
#define TASK_GDT0		3

struct TSS32 {
    int backlink, esp0, ss0, esp1, ss1, esp2, ss2, cr3;
    int eip, eflags, eax, ecx, edx, ebx, esp, ebp, esi, edi;
    int es, cs, ss, ds, fs, gs;
    int ldtr, iomap;
};
struct TASK {
    int sel, flags;
    int level, priority; /* Priority equals the interval of switch */
    struct FIFO32 fifo;
    struct TSS32 tss;
    struct SEGMENT_DESCRIPTOR ldt[2];
    struct CONSOLE *cons;
    int ds_base, cons_stack;
    struct FILEHANDLE *fhandle;
    int *fat;
    char *cmdline;
};
struct TASKLEVEL {
    int running;        /* Running task number */
    int now;            /* Current task index */
    struct TASK *tasks[MAX_TASKS_LV];
};
struct TASKCTL {
    int now_lv;         /* Current level */
    char lv_change;
    struct TASKLEVEL level[MAX_TASKLEVELS];
    struct TASK tasks0[MAX_TASKS];
};
extern struct TASKCTL *taskctl;
extern struct TIMER *task_timer;
struct TASK *task_now(void);
struct TASK *task_init(struct MEMMAN *memman);
struct TASK *task_alloc(void);
void task_run(struct TASK *task, int level, int priority);
void task_switch(void);
void task_sleep(struct TASK *task);
#endif
