asm-src = $(shell find . -name "*.S")
asm-bin = $(asm-src:%.S=%.bin)

AS = nasm

%.bin: %.S
	@echo " 	[AS]  	$<"
	nasm $< -o $@

$(asm-bin):

clean:
	rm -rf *.bin
