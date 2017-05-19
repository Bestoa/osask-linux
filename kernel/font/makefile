font-src = $(shell find . -name "*.txt")
font-target = $(font-src:%.txt=%.h)

default: makefont $(font-target)
	
makefont: makefont.c
	gcc makefont.c -o makefont

%.h: %.txt makefont
	./makefont $< $@

clean:
	rm -f makefont *.h
