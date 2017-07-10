asm-src = $(shell ls *.S)
asm-bin = $(asm-src:%.S=%.bin)

sub-dir = $(shell find -not -path "." -not -path "./libc" -not -path "./out" -type d)

default: all

AS = nasm
MAKE = make

%.bin: %.S
	@echo " 	[AS]  	$<"
	@nasm $< -o out/$@

out:
	mkdir -p out

.PHONY: libc
libc:
	@echo " 	[MAKE] 	$@"
	@$(MAKE) -C $@

subdirs: out libc $(sub-dir)
	@for d in $(sub-dir); \
	do $(MAKE) -C $$d || exit 1; \
	done

cleansub:
	@for d in $(sub-dir); \
	do $(MAKE) -C $$d clean; \
	done

all: out $(asm-bin) subdirs

clean: cleansub
	make -C libc clean
	rm -rf out
