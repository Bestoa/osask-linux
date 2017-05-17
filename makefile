default: os
	@echo done

miniloader: miniloader.S
	nasm miniloader.S -o ml.bin

.PHONY:
core:
	cd kernel;make;

os: miniloader core 
	dd if=/dev/zero of=os.img bs=1K count=1440
	sudo mkfs.fat os.img
	dd if=ml.bin of=os.img conv=notrunc
	sudo mount os.img tmp
	sudo cp kernel/kernel.bin tmp
	sudo umount tmp

clean:
	rm -f os.img ml.bin

run:
	bochs -f bxrc
