c-src = $(shell find . -not -path "*test*" -name "*.c")
c-obj = $(c-src:%.c=%.o)

target = libccommon.o

default: all

CFLAGS = -c -m32 -fno-builtin

%.o: %.c
	@echo " 	[CC] 	$<"
	@gcc $(CFLAGS) $< -o $@

all: $(c-obj)
	@echo " 	[LD] 	$(target)"
	@ld -r $(c-obj) -o $(target) -m elf_i386

clean:
	rm -rf *.o
