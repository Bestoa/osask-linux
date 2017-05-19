src = $(shell ls *.c)
obj = $(src:%.c=%.o)
dep = $(shell ls *.h)

.PHONY: clib
clib: $(obj)

%.o: %.c $(dep)
	gcc -c -m32 $< -o $@

clean:
	rm -f *.o
