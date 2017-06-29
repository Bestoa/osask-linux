bootloader-target = bootloader/ml.bin
kernel-target = kernel/kernel.bin

target-image = os.img
empty-image = empty.img

tmp-mount-point = mnt

MAKE = make
ECHO = echo
DD = dd
CP = cp
RM = rm
MAKEFAT = mkfs.fat
MAKEDIR = mkdir
MOUNT = mount
UMOUNT = umount
RUNASROOT = sudo

default: $(target-image)

.PHONY: bootloader
bootloader:
	@$(ECHO) " 	[MAKE] 		$@"
	@$(MAKE) -C $@

.PHONY: kernel
kernel:
	@$(ECHO) " 	[MAKE] 		$@"
	@$(MAKE) -C $@

.PHONY: app
app:
	@$(ECHO) " 	[MAKE] 		$@"
	@$(MAKE) -C $@

$(empty-image):
	@$(ECHO) " 	[GENIMAGE] 	$@"
	@$(DD) if=/dev/zero of=$@ bs=1K count=1440
	@$(ECHO) " 	[MKFS.FAT]  $@"
	@$(RUNASROOT) $(MAKEFAT) $@ > /dev/null

$(target-image): $(empty-image) bootloader kernel app
	@$(ECHO) " 	[GENIMAGE] 	$@"
	@$(CP) $(empty-image) $(target-image)
	@$(DD) if=$(bootloader-target) of=$(target-image) conv=notrunc
	@$(MAKEDIR) -p $(tmp-mount-point)
	@-$(RUNASROOT) $(MOUNT) $(target-image) $(tmp-mount-point)
	@-$(ECHO) " 	[COPY]  $(kernel-target)"
	@-$(RUNASROOT) $(CP) $(kernel-target) $(tmp-mount-point)
	@-$(RUNASROOT) $(CP) kernel/head.S $(tmp-mount-point)
	@-$(ECHO) " 	[COPY]  APP"
	@-$(RUNASROOT) $(CP) -v app/out/*.bin $(tmp-mount-point)
	@-$(RUNASROOT) $(UMOUNT) $(tmp-mount-point)
	@$(RM) -r $(tmp-mount-point)

clean:
	@$(MAKE) -C bootloader clean
	@$(MAKE) -C kernel clean
	@$(MAKE) -C app clean
	$(RM) -f *.img

run:
	@bochs -f bxrc
