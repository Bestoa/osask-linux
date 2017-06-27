asm-src = $(shell ls *.S)
asm-bin = $(asm-src:%.S=%.bin)

sub-dir = $(shell find -not -path "." -type d)

default: all

AS = nasm
MAKE = make

%.bin: %.S
	@echo " 	[AS]  	$<"
	@nasm $< -o $@

subdirs: $(sub-dir)
	for d in $(sub-dir); \
	do $(MAKE) -C $$d || exit 1; \
	done

cleansub:
	for d in $(sub-dir); \
	do $(MAKE) -C $$d clean; \
	done

all: $(asm-bin) subdirs

clean: cleansub
	rm -rf *.bin
