OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)

SECTIONS
{
    .text 0x0 : {
        *(.text)
    }
    .rodata : {
        *(.rodata)
    }
    .data : {
        *(.data)
    }
    .bss : {
        *(.bss)
    }
}
