[BITS 32]

EXTERN main

[SECTION .text]

_start:
    PUSHAD
    CALL main
    POPAD
    MOV EDX, 4
    INT 0x40
