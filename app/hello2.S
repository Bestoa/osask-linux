[BITS 32]
        DB      "EXEC"
        DW      0x20
        TIMES   0x20-($-$$) DB 0
        MOV     EDX,2
        MOV     EBX,msg
        INT     0x40
        MOV     EDX,4
        INT     0x40
msg:
        DB  "Hello2",0
