#ifndef __FIFO_H__
#define __FIFO_H__

#define FLAGS_OVERRUN       0x0001

struct FIFO32 {
    int *buf;
    int p, q, size, free, flags;
    struct TASK *task;
};

#include "mtask.h"

void fifo32_init(struct FIFO32 *fifo, int size, int *buf, struct TASK *task);
int fifo32_put(struct FIFO32 *fifo, int data);
int fifo32_get(struct FIFO32 *fifo);
int fifo32_status(struct FIFO32 *fifo);

#endif
