kernel-target = kernel/kernel.bin

target-image = os.img
empty-image = empty.img

AS = nasm
MAKE = make

default: kernel
	@echo " 	[MAKE] 		$(target-image)"
	@$(MAKE) $(target-image)
	@echo done

ml.bin: miniloader.S
	@echo " 	[AS] 		$@"
	@$(AS) $< -o $@

.PHONY: kernel
kernel:
	@echo " 	[MAKE] 		$@"
	@$(MAKE) -C kernel

.PHONY: app
app:
	@echo " 	[MAKE] 		$@"
	@$(MAKE) -C app

$(kernel-target):
	@echo " 	[MAKE] 		$@"
	@$(MAKE) -C kernel

$(empty-image):
	@echo " 	[GENIMAGE] 	$@"
	@dd if=/dev/zero of=$@ bs=1K count=1440
	@echo " 	[MKFS.FAT]  $@"
	@sudo mkfs.fat $@ > /dev/null

$(target-image): $(empty-image) ml.bin $(kernel-target) app
	@echo " 	[GENIMAGE] 	$@"
	@cp $(empty-image) $(target-image)
	@dd if=ml.bin of=$(target-image) conv=notrunc
	@mkdir -p mnt
	@-sudo mount $(target-image) mnt
	@-echo " 	[COPY]  $(kernel-target)"
	@-sudo cp $(kernel-target) mnt
	@-sudo cp kernel/head.S mnt
	@-sudo cp kernel/init.c mnt
	@-echo " 	[COPY]  APP"
	@-sudo cp app/*.bin mnt
	@-sudo umount mnt
	@rm -r mnt

clean:
	@$(MAKE) -C kernel clean
	@$(MAKE) -C app clean
	rm -f *.img *.bin

run:
	@bochs -f bxrc
