asm-src = $(shell find . -name "*.S")
asm-bin = $(asm-src:%.S=%.bin)

AS = nasm

%.bin: %.S
	@echo " 	[AS]  	$<"
	@nasm $< -o $@

all: $(asm-bin)

clean:
	rm -rf *.bin
