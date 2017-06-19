; TAB=4

CYLS    EQU     10              ; 10 cyls

        ORG     0x7c00

; FAT12 head

        JMP     entry
        DB      0x90
        DB      "HARIBOTE"      ; 8 bytes
        DW      512             ; sector size
        DB      1
        DW      1
        DB      2               ; FAT number
        DW      224
        DW      2880            ; sector number
        DB      0xf0
        DW      9
        DW      18              ; 1 cyls has 18 secotrs
        DW      2
        DD      0
        DD      2880
        DB      0,0,0x29
        DD      0xffffffff
        DB      "HARIBOTEOS "   ; 11 bytes
        DB      "FAT12   "      ; 8 bytes
        TIMES   18 DB 0

entry:
        MOV     AX,0
        MOV     SS,AX
        MOV     SP,0x7c00
        MOV     DS,AX


; Read form disk
        MOV     AX,0x0BA0
        MOV     ES,AX
        MOV     CH,0
        MOV     DH,0
        MOV     CL,1            ; Read form sector 1
readloop:
        MOV     SI,0
retry:
        MOV     AH,0x02         ; AH=0x02: read
        MOV     AL,1
        MOV     BX,0
        MOV     DL,0x00
        INT     0x13
        JNC     next            ; Read 1 sector successfully
        ADD     SI,1
        CMP     SI,5
        JAE     errormsg        ; Retry 5 times
        MOV     AH,0x00         ; Reset
        MOV     DL,0x00
        INT     0x13
        JMP     retry
next:
        MOV     AX,ES           ; Add 0x200
        ADD     AX,0x0020
        MOV     ES,AX
        ADD     CL,1
        CMP     CL,18           ; 1 clys has 18 sectors
        JBE     readloop
        MOV     CL,1
        ADD     DH,1
        CMP     DH,2
        JB      readloop        ; dh < 2
        MOV     DH,0
        ADD     CH,1
        CMP     CH,CYLS
        JB      readloop

        MOV     [0x0ff0],CH
        JMP     0xFE00          ; File locates on 0x4400, so 0xBA00+0x4400 = 0xFE00

errormsg:
        MOV     SI,msg
putloop:
        MOV     AL,[SI]
        ADD     SI,1
        CMP     AL,0
        JE      fin
        MOV     AH,0x0e
        MOV     BX,15
        INT     0x10
        JMP     putloop
fin:
        HLT
        JMP     fin
msg:
        DB      0x0a, 0x0d
        DB      "load error"
        DB      0x0a, 0x0d
        DB      0

        TIMES   0x1fe-($-$$) DB 0   ; 510

        DB      0x55, 0xaa          ; bootable flag
