c-src = hello3.c
c-obj = $(c-src:%.c=%.o)
asm-src = _entry.S a.S
asm-obj = $(asm-src:%.S=%.s.o)

target = hello3
target-elf = $(target).elf
target-bin = $(target).bin

default: all

%.o: %.c
	gcc -c -m32 -fno-builtin $< -o $@

%.s.o: %.S
	nasm -f elf32 $< -o $@


all: $(asm-obj) $(c-obj)
	ld $(asm-obj) $(c-obj) -T linker.ld -o $(target-elf)
	objcopy -S -O binary $(target-elf) $(target-bin)
	cp $(target-bin) ../

clean:
	rm -rf *.o *.bin *.elf
