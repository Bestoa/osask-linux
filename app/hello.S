[BITS 32]
    DB      "EXEC"
    DW      0x20
    TIMES   0x20-($-$$) DB 0
    MOV     ECX, msg
    MOV     EDX, 1
putloop:
    MOV     AL, [CS:ECX]
    CMP     AL, 0
    JE      fin
    INT     0x40
    ADD     ECX, 1
    JMP     putloop
fin:
    MOV     EDX, 4
    INT     0x40
msg:
    DB "Hello", 0
