font-src = $(shell find . -name "*.txt")
font-target = $(font-src:%.txt=%.h)

CC = gcc

default: makefont $(font-target)
	
makefont: makefont.c
	@echo " 	[CC] 	$<"
	@gcc makefont.c -o makefont

%.h: %.txt makefont
	@echo " 	[MAKEFONT] 	$@"
	@./makefont $< $@

clean:
	rm -f makefont *.h
