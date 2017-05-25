c-src = init.c
c-src += $(shell find -not -path "*font*" -not -path "./init.c" -not -path "*test.c" -name "*.c")

c-obj = $(c-src:%.c=%.o)

kernel-head-target = kernel-head.bin
kernel-tail-elf-target = kernel-tail.elf
kernel-tail-target = kernel-tail.bin
kernel-target = kernel.bin

CFLAGS= -c -m32 -fno-builtin

.PHONY: all
all: $(kernel-head-target) $(kernel-tail-target)
	cp $(kernel-head-target) $(kernel-target)
	cat $(kernel-tail-target) >> $(kernel-target)

$(kernel-head-target): head.S
	nasm head.S -o $(kernel-head-target)

%.o: %.c
	gcc $(CFLAGS) $< -o $@

$(kernel-tail-target): asmlib font $(c-obj)
	ld -T kernel.ld $(c-obj) asmlib/*.o -o $(kernel-tail-elf-target)
	objcopy -S -O binary $(kernel-tail-elf-target) $(kernel-tail-target)

.PHONY: font
font:
	cd font;make

.PHONY: asmlib
asmlib:
	cd asmlib;make

.PHONY: clean
clean:
	rm -f *.bin *.elf $(c-obj)
	cd font;make clean;cd ..
	cd asmlib;make clean;cd ..
