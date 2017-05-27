c-src = init.c
c-src += $(shell find -not -path "*font*" -not -path "./init.c" -not -path "*test.c" -name "*.c")

c-obj = $(c-src:%.c=%.o)

asm-src = $(shell find asmlib -name "*.S")
asm-obj = $(asm-src:%.S=%.s.o)

kernel-head-target = kernel-head.bin
kernel-tail-elf-target = kernel-tail.elf
kernel-tail-target = kernel-tail.bin
kernel-target = kernel.bin

CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
MAKE = make

CFLAGS = -c -m32 -fno-builtin

$(kernel-target): $(kernel-head-target) $(kernel-tail-target)
	@echo " 	[GENKERNEL]    $(kernel-target)"
	@cp $(kernel-head-target) $(kernel-target)
	@cat $(kernel-tail-target) >> $(kernel-target)

$(kernel-head-target): head.S
	@echo " 	[AS]  	$<"
	@$(AS) head.S -o $(kernel-head-target)

%.o: %.c
	@echo " 	[CC]  	$<"
	@$(CC) $(CFLAGS) $< -o $@

%.s.o: %.S
	@echo " 	[AS]  	$<"
	@$(AS) -f elf32 $< -o $@

$(kernel-tail-target): $(c-obj) $(asm-obj)
	@echo " 	[LD]    $(c-obj) $(asm-obj)"
	@$(LD) -T kernel.ld $(c-obj) $(asm-obj) -o $(kernel-tail-elf-target)
	@echo " 	[OBJCOPY] $(kernel-tail-elf-target) -> $(kernel-tail-target)"
	@$(OBJCOPY) -S -O binary $(kernel-tail-elf-target) $(kernel-tail-target)

font-list = font/font8x16.h

$(font-list):
	@$(MAKE) -C font

$(c-obj): $(font-list)

.PHONY: clean
clean:
	rm -f *.bin *.elf $(c-obj) $(asm-obj)
	$(MAKE) -C font clean
