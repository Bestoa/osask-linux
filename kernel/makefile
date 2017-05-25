c-src = init.c
c-src += $(shell ls *.c|grep -v init.c|xargs)

c-obj = $(c-src:%.c=%.o)
header-file = $(shell ls *.h)

kernel-head-target = kernel-head.bin
kernel-tail-elf-target = kernel-tail.elf
kernel-tail-target = kernel-tail.bin
kernel-target = kernel.bin

.PHONY: all
all: $(kernel-head-target) $(kernel-tail-target)
	cp $(kernel-head-target) $(kernel-target)
	cat $(kernel-tail-target) >> $(kernel-target)

$(kernel-head-target): head.S
	nasm head.S -o $(kernel-head-target)

%.o: %.c $(header-file)
	gcc -c -m32 $< -o $@

$(kernel-tail-target): asmlib clib font $(c-obj)
	ld -T kernel.ld $(c-obj) asmlib/*.o clib/*.o -o $(kernel-tail-elf-target)
	objcopy -S -O binary $(kernel-tail-elf-target) $(kernel-tail-target)

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
