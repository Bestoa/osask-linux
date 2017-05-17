default:
	nasm head.S -o kernel.bin
	gcc -c -m32 *.c
	ld -m elf_i386 -Ttext 0x0  *.o -o head.elf
	objcopy -j .text -O binary head.elf head.bin
	cat head.bin >> kernel.bin
clean:
	rm -f *.bin *.o *.elf
