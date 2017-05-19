src = $(shell find ./ -name "*.S")
obj = $(src:%.S=%.o)

.PHONY: asmlib
asmlib: $(obj)

%.o: %.S
	nasm -f elf $< -o $@

clean:
	rm -f *.o
