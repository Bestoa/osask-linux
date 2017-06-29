[BITS 32]

EXTERN main

[SECTION .text]

    DB "EXEC"
    TIMES 0x20-($-$$) DB 0

_start:
    PUSHAD
    CALL main
    POPAD
    MOV EDX, 4 ; use system call install of retf
    INT 0x40
