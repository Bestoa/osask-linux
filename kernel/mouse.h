#ifndef __MOUSE_H__
#define __MOUSE_H__
extern struct FIFO8 mousefifo;

struct MOUSE_DEC {
    unsigned char buf[3], phase;
    int x, y, btn;
};

void inthandler27(int *esp);
void enable_mouse(struct MOUSE_DEC *mdec);
int mouse_decode(struct MOUSE_DEC *mdec, unsigned char dat);
#endif
