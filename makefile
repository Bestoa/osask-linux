default: os
	@echo done

ml.bin: miniloader.S
	nasm miniloader.S -o ml.bin

.PHONY: kernel
kernel:
	cd kernel;make

image-org.img:
	# Just support 1.44MB floppy
	dd if=/dev/zero of=image-org.img bs=1K count=1440
	# FAT12
	sudo mkfs.fat image-org.img

.PHONY: os
os: image-org.img ml.bin kernel
	cp image-org.img os.img
	dd if=ml.bin of=os.img conv=notrunc
	sudo mount os.img tmp
	-sudo cp kernel/kernel.bin tmp
	# Do umount
	sudo umount tmp

clean:
	cd kernel;make clean
	rm -f *.img *.bin

run: os
	bochs -f bxrc
