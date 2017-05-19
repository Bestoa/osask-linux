c-src = init.c
c-obj = $(c-src:%.c=%.o)

.PHONY: all
all: kernel-head.bin kernel-init.bin
	cp kernel-head.bin kernel.bin
	cat kernel-init.bin >> kernel.bin

kernel-head.bin: head.S
	nasm head.S -o kernel-head.bin

%.o: %.c
	gcc -c -m32 $< -o $@

kernel-init.bin: asmlib clib font $(c-obj)
	ld -T kernel.ld $(c-obj) asmlib/*.o clib/*.o -o kernel-init.elf
	objcopy -S -O binary kernel-init.elf kernel-init.bin

.PHONY: font
font:
	cd font;make

.PHONY: asmlib
asmlib:
	cd asmlib;make

.PHONY: clib
clib:
	cd clib;make

.PHONY: clean
clean:
	rm -f *.bin *.o *.elf
	cd font;make clean;cd ..
	cd asmlib;make clean;cd ..
	cd clib;make clean;cd ..
