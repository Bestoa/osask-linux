[BITS 32]
GLOBAL	main

[SECTION .text]
main:
        DB      "EXEC"
        DW      0x20
        TIMES   0x20-($-$$) DB 0
		MOV		EDX,2
		MOV		EBX,msg
		INT		0x40
		MOV		EDX,4
		INT		0x40

[SECTION .data]
msg:
		DB	"hello, world5", 0x0a, 0
