[BITS 32]
GLOBAL	main

[SECTION .text]

main:
        DB      "EXEC"
        DW      0x20
        TIMES   0x20-($-$$) DB 0
        MOV     AX,1005*8
        MOV     DS,AX
        CMP     DWORD [DS:0x0000],'EXEC'
        JNE     fin

        MOV     ECX, 0x20
        MOV     AX,2005*8
        MOV     DS,AX

crackloop:
        MOV     BYTE [DS:ECX],123
        ADD     ECX, 1
        JNE     crackloop

fin:
        MOV     EDX,4
        INT     0x40
