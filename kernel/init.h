#ifndef __INIT_H__
#define __INIT_H__

struct BOOTINFO {
    char cyls, leds, vmode, reserve;
    short scrnx, scrny;
    char *vram;
};
#define ADR_BOOTINFO    (0xff0)
#define ADR_DISKIMG     0x00100000
#endif
