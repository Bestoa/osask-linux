#include "asmlib/lib.h"
#include "keyboard.h"
#include "fifo.h"
#include "int.h"

struct FIFO8 keyfifo;

void inthandler21(int *esp)
{
    unsigned char data, s[4];
    io_out8(PIC0_OCW2, 0x61);
    data = io_in8(PORT_KEYDAT);
    fifo8_put(&keyfifo, data);
    return;
}

void wait_KBC_sendready(void)
{
    for (;;) {
        if ((io_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) {
            break;
        }
    }
    return;
}

void init_keyboard(void)
{
    wait_KBC_sendready();
    io_out8(PORT_KEYCMD, KEYCMD_WRITE_MODE);
    wait_KBC_sendready();
    io_out8(PORT_KEYDAT, KBC_MODE);
    return;
}
