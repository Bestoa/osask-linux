[BITS 32]

EXTERN main

[SECTION .text]

_start:
    PUSHAD
    CALL main
    POPAD
    MOV EDX, 4 ; use system call install of retf
    INT 0x40
