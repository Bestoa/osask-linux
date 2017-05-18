default: os
	@echo done

miniloader: miniloader.S
	nasm miniloader.S -o ml.bin

core:
	cd kernel;make clean;make

os: miniloader core 
	# Just support 1.44MB floppy
	dd if=/dev/zero of=os.img bs=1K count=1440
	# FAT12
	sudo mkfs.fat os.img
	dd if=ml.bin of=os.img conv=notrunc
	sudo mount os.img tmp
	sudo cp kernel/kernel.bin tmp
	sudo umount tmp

clean:
	cd kernel;make clean
	rm -f os.img ml.bin

run: os
	bochs -f bxrc
