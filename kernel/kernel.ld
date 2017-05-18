OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)

SECTIONS
{
	/* Link the kernel at this address: "." means the current address */
	/* C code start at 0xfe00(base 0x280000) data(include rodata) at 0x7e00(base 0x0) size 32K */
	. = 0xfe00;
	.text :  {
		*(.text)
	}
	. = 0x7e00;
	.data : {
		*(.data)
        *(.rodata)
	}
}
