; TAB=4
BOTPAK  EQU     0x00280000      ; C entry
DSKCAC  EQU     0x00100000
DSKCAC0 EQU     0x00008000

; BOOT_INFO
CYLS    EQU     0x0ff0          ; Read CYLS numbers from miniloader
LEDS    EQU     0x0ff1
VMODE   EQU     0x0ff2
SCRNX   EQU     0x0ff4
SCRNY   EQU     0x0ff6
VRAM    EQU     0x0ff8

        ORG     0xc200

start:

        MOV     AL,0x13         ; VGA 320*200*8 bit
        MOV     AH,0x00
        INT     0x10
        MOV     BYTE [VMODE],8
        MOV     WORD [SCRNX],320
        MOV     WORD [SCRNY],200
        MOV     DWORD [VRAM],0x000a0000

;Save LEDS status

        MOV     AH,0x02
        INT     0x16            ; keyboard BIOS
        MOV     [LEDS],AL


        MOV     AL,0xff
        OUT     0x21,AL
        NOP
        OUT     0xa1,AL

        CLI

;Enable A20 gate

        CALL    waitkbdout
        MOV     AL,0xd1
        OUT     0x64,AL
        CALL    waitkbdout
        MOV     AL,0xdf
        OUT     0x60,AL
        CALL    waitkbdout


[CPU 486]

        LGDT    [GDTR0]         ; Load GDT
        MOV     EAX,CR0
        AND     EAX,0x7fffffff  ; Disable page
        OR      EAX,0x00000001  ; Enter projective mode
        MOV     CR0,EAX
        JMP     pipelineflush

pipelineflush:
        MOV     AX,1*8          ;
        MOV     DS,AX
        MOV     ES,AX
        MOV     FS,AX
        MOV     GS,AX
        MOV     SS,AX


        MOV     ESI,main
        MOV     EDI,BOTPAK
        MOV     ECX,512*1024/4
        CALL    memcpy

        MOV     ESP, BOTPAK
        JMP     DWORD 2*8:0x0
        HLT

waitkbdout:
        IN      AL,0x64
        AND     AL,0x02
        JNZ     waitkbdout
        RET

memcpy:
        MOV     EAX,[ESI]
        ADD     ESI,4
        MOV     [EDI],EAX
        ADD     EDI,4
        SUB     ECX,1
        JNZ     memcpy
        RET

        ALIGNB  16
GDT0:
        DW      0x0000,0x0000,0x0000,0x0000
        DW      0xffff,0x0000,0x9200,0x00cf
        DW      0xffff,0x0000,0x9a28,0x0047

        DW      0
GDTR0:
        DW      8*3-1
        DD      GDT0

        ALIGNB  16
main:
