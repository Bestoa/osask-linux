asm-src = c_entry.S c_api.S
asm-obj = $(asm-src:%.S=%.S.o)

target = libc.o

default: all

%.S.o: %.S
	@echo " 	[AS] 	$<"
	@nasm -f elf32 $< -o $@


all: $(asm-obj)
	@echo " 	[LD] 	$(target)"
	@ld -r $(asm-obj) -o $(target) -m elf_i386
	@cp $(target) ../out

clean:
	rm -rf *.o *.bin *.elf
