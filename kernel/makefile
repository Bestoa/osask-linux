default:
	nasm head.S -o kernel.bin
	nasm func.S -f elf
	gcc -c -m32 *.c
	ld -T kernel.ld head.o func.o -o head.elf
	objcopy -S -O binary head.elf head.bin
	cat head.bin >> kernel.bin
clean:
	rm -f *.bin *.o *.elf
