#ifndef __KEYBOARD_H__
#define __KEYBOARD_H__

#include "fifo.h"

#define PORT_KEYDAT             0x0060
#define PORT_KEYSTA             0x0064
#define PORT_KEYCMD             0x0064
#define KEYSTA_SEND_NOTREADY    0x02
#define KEYCMD_WRITE_MODE       0x60
#define KBC_MODE                0x47

#define KEYCMD_SENDTO_MOUSE     0xd4
#define MOUSECMD_ENABLE         0xf4

void inthandler21(int *esp);
void init_keyboard(struct FIFO32 *fifo, int data0);
void wait_KBC_sendready(void);

#endif
