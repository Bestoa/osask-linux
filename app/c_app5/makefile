c-src = winhello.c
c-obj = $(c-src:%.c=%.o)

target = winhello
target-elf = $(target).elf
target-bin = $(target).bin

default: all

%.o: %.c
	gcc -c -m32 -fno-builtin $< -o $@


all: $(c-obj)
	ld ../out/libc.o $(c-obj) -T linker.ld -o $(target-elf)
	objcopy -S -O binary $(target-elf) $(target-bin)
	readelf -S $(target-elf) | awk '{ print $$3,$$5,$$7 }' |grep "^\." > $(target).elfinfo
	../genexec $(target)
	cp $(target-bin) ../out/

clean:
	rm -rf *.o *.bin *.elf*
