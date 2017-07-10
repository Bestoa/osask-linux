bootloader-target = ml.bin

AS = nasm

$(bootloader-target): miniloader.S
	@echo " 	[AS] 	$@"
	@$(AS) $< -o $@

clean:
	rm -f $(bootloader-target)
