; TAB=4
[CPU 486]

CODE_BASE_ADDR      EQU     0x00280000
STACK_TOP           EQU     0x00400000

VBEMODE             EQU     0x101
;0x101 640*480*8
;0x103 800*600*8
;0x105 1024*768*8
;0x107 1280*1024*8

; BOOT_INFO
CYLS    EQU     0x0ff0          ; Read CYLS numbers from miniloader
LEDS    EQU     0x0ff1
VMODE   EQU     0x0ff2
SCRNX   EQU     0x0ff4
SCRNY   EQU     0x0ff6
VRAM    EQU     0x0ff8

        ORG     0xfe00

; Check VBE
        MOV     AX,0x9000
        MOV     ES,AX
        MOV     DI,0
        MOV     AX,0x4f00
        INT     0x10
        CMP     AX,0x004f
        JNE     scrn320

; Check VBE version
        MOV     AX,[ES:DI+4]
        CMP     AX,0x0200
        JB      scrn320         ; if (AX < 0x0200) goto scrn320

; Check whether support VBEMODE
        MOV     CX,VBEMODE
        MOV     AX,0x4f01
        INT     0x10
        CMP     AX,0x004f
        JNE     scrn320

        CMP     BYTE [ES:DI+0x19],8 ; Color bit
        JNE     scrn320
        CMP     BYTE [ES:DI+0x1b],4
        JNE     scrn320
        MOV     AX,[ES:DI+0x00]     ; Whether support direct mode
        AND     AX,0x0080
        JZ      scrn320

        MOV     BX,VBEMODE+0x4000   ; This mode allows us to change buffer directly, otherwise we need call 05H to flip
        MOV     AX,0x4f02
        INT     0x10
        MOV     BYTE [VMODE],8
        MOV     AX,[ES:DI+0x12]     ; X
        MOV     [SCRNX],AX
        MOV     AX,[ES:DI+0x14]     ; Y
        MOV     [SCRNY],AX
        MOV     EAX,[ES:DI+0x28]    ; VRAM address
        MOV     [VRAM],EAX
        JMP     keystatus

scrn320:

        MOV     AL, 0x13
        MOV     AH, 0x00
        INT     0x10

        MOV     BYTE [VMODE],8
        MOV     WORD [SCRNX],320
        MOV     WORD [SCRNY],200
        MOV     DWORD [VRAM],0x000a0000

;Save LEDS status
keystatus:
        MOV     AH,0x02
        INT     0x16            ; Keyboard BIOS
        MOV     [LEDS],AL


;PIC init
        MOV     AL,0xff
        OUT     0x21,AL         ; Disable PIC master interrupt
        NOP                     ; Wait for a while
        OUT     0xa1,AL         ; Disable PIC slave interrupt

        CLI                     ; Disable cpu interrupt

;Enable A20 gate

        CALL    waitkbdout
        MOV     AL,0xd1
        OUT     0x64,AL
        CALL    waitkbdout
        MOV     AL,0xdf         ; Enable A20
        OUT     0x60,AL
        CALL    waitkbdout      ; Useless


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

; Move floppy A data to 1M
        MOV     ESI, 0xBA00
        MOV     EDI, 0x100000
        MOV     ECX, (10*18*2*512)
        SHR     ECX,2
        CALL    memcpy

; Move .text and .data .rodata to CODE_BASE_ADDR
        MOV     ESI,main
        MOV     EDI,CODE_BASE_ADDR
        MOV     ECX,(512*1024)
        SHR     ECX,2
        CALL    memcpy

        MOV     ESP, STACK_TOP
        JMP     DWORD 2*8:CODE_BASE_ADDR
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
        ; seg_base = 0 seg_limit = 0XFFFFF for data G bit = 1
        DW      0xffff,0x0000,0x9200,0x00cf
        ; seg_base = 0 seg_limit = 0XFFFFF for code G bit = 1
        DW      0xffff,0x0000,0x9a00,0x00cf

        DW      0
GDTR0:
        DW      8*3-1
        DD      GDT0

        ALIGNB  16
main:
