OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)

SECTIONS
{
    /* .text start at 0x0 (Code base address is 0x280000), it will be loaded at 0x280000 */
    .text : {
        *(.text)
    }
    /* .data will be store after .text, but will be loaded with .text toghter to 0x280000 + .data's offset.
     * The VMA of .data should be 0x280000 + .data's offset, the LMA of .data should be 0 + data's offset.
     * The offset of .data should be .text's base + .text's size, but there will be some other small sections
     * between .data and .text, so we add 3K to put them */
    .data 0x280000+ADDR(.text)+SIZEOF(.text)+3*1024 : AT(LOADADDR(.text)+SIZEOF(.text)+3*1024) {
        *(.data)
        /* We just put .data and .rodata together */
        *(.rodata)
    }
}
