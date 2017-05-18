; TAB=4
CODE_BASE_ADDR      EQU     0x00280000
CODE_START_ADDR     EQU     0x0000fe00
DATA_BASE_ADDR      EQU     0x00000000
DATA_START_ADDR     EQU     0x00007e00

; BOOT_INFO
CYLS    EQU     0x0ff0          ; Read CYLS numbers from miniloader
LEDS    EQU     0x0ff1
VMODE   EQU     0x0ff2
SCRNX   EQU     0x0ff4
SCRNY   EQU     0x0ff6
VRAM    EQU     0x0ff8

        ORG     0xfe00

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
        INT     0x16            ; Keyboard BIOS
        MOV     [LEDS],AL


;PIC init
        MOV     AL,0xff
        OUT     0x21,AL
        NOP                     ; Wait for a while
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

;Enter protective mode
        LGDT    [GDTR0]         ; Load GDT
        MOV     EAX,CR0
        AND     EAX,0x7fffffff  ; Disable page
        OR      EAX,0x00000001  ; Enter projective mode
        MOV     CR0,EAX
        JMP     pipelineflush   ; Just flush pipeline

pipelineflush:
        MOV     AX,1*8          ; Use GDT1
        MOV     DS,AX
        MOV     ES,AX
        MOV     FS,AX
        MOV     GS,AX
        MOV     SS,AX


; .text(0xfe00) after .data(0x7e00)
        MOV     ESI,main+(CODE_START_ADDR-DATA_START_ADDR)
        MOV     EDI,CODE_BASE_ADDR+CODE_START_ADDR
; .text seg limit is 512k(0x7ffff)
        MOV     ECX,(512*1024-CODE_START_ADDR)
        SHR     ECX,2
        CALL    memcpy
; .data seg start from begin
        MOV     ESI,main
        MOV     EDI,DATA_BASE_ADDR+DATA_START_ADDR
; .data size should less then 32k (0xfe00-0x7e00)
        MOV     ECX,start - (DATA_BASE_ADDR + DATA_START_ADDR)
        SHR     ECX,2
        CALL    memcpy

        MOV     ESP, CODE_BASE_ADDR
        JMP     DWORD 2*8:CODE_START_ADDR
; Should never go here
dead:
        HLT
        JMP dead

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
        ; seg_base = 0 seg_limit = 0XFFFFF for data
        DW      0xffff,0x0000,0x9200,0x00cf
        ; seg_base = 0X280000 seg_limit = 0X7FFFF for code
        DW      0xffff,0x0000,0x9a28,0x0047

        DW      0
GDTR0:
        DW      8*3-1
        DD      GDT0

        ALIGNB  16
main:
