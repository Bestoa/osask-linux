#include "asmlib/lib.h"
#include "memory.h"

unsigned int memtest(unsigned int start, unsigned int end)
{
    char flg486 = 0;
    unsigned int eflg, cr0, i;

    eflg = io_load_eflags();
    eflg |= EFLAGS_AC_BIT; /* AC-bit = 1 */
    io_store_eflags(eflg);
    eflg = io_load_eflags();
    /* 386 will reset this bit */
    if ((eflg & EFLAGS_AC_BIT) != 0) {
        flg486 = 1;
    }
    eflg &= ~EFLAGS_AC_BIT; /* AC-bit = 0 */
    io_store_eflags(eflg);

    /* for 486 and later CPU we need disable CACHE */
    if (flg486 != 0) {
        cr0 = load_cr0();
        cr0 |= CR0_CACHE_DISABLE;
        store_cr0(cr0);
    }

    i = memtest_sub(start, end);

    if (flg486 != 0) {
        cr0 = load_cr0();
        cr0 &= ~CR0_CACHE_DISABLE;
        store_cr0(cr0);
    }

    return i;
}
void memman_init(struct MEMMAN *man)
{
    man->frees = 0;
    man->maxfrees = 0;
    man->lostsize = 0;
    man->losts = 0;
    return;
}

unsigned int memman_total(struct MEMMAN *man)
{
    unsigned int i, t = 0;
    for (i = 0; i < man->frees; i++) {
        t += man->free[i].size;
    }
    return t;
}

unsigned int memman_alloc(struct MEMMAN *man, unsigned int size)
{
    unsigned int i, a;
    for (i = 0; i < man->frees; i++) {
        if (man->free[i].size >= size) {
            a = man->free[i].addr;
            man->free[i].addr += size;
            man->free[i].size -= size;
            /* Remove this free record */
            if (man->free[i].size == 0) {
                man->frees--;
                for (; i < man->frees; i++) {
                    man->free[i] = man->free[i + 1];
                }
            }
            return a;
        }
    }
    /* alloc failed */
    return 0;
}

int memman_free(struct MEMMAN *man, unsigned int addr, unsigned int size)
{
    int i, j;
    for (i = 0; i < man->frees; i++) {
        if (man->free[i].addr > addr) {
            break;
        }
    }
    /* free[i - 1].addr < addr */
    if (i > 0) {
        /* Merge to the previous record */
        if (man->free[i - 1].addr + man->free[i - 1].size == addr) {
            man->free[i - 1].size += size;
            if (i < man->frees) {
                /* Merge with the next record */
                if (addr + size == man->free[i].addr) {
                    man->free[i - 1].size += man->free[i].size;
                    man->frees--;
                    for (; i < man->frees; i++) {
                        man->free[i] = man->free[i + 1];
                    }
                }
            }
            return 0;
        }
    }
    /* Merge with the next record */
    if (i < man->frees) {
        if (addr + size == man->free[i].addr) {
            man->free[i].addr = addr;
            man->free[i].size += size;
            return 0;
        }
    }
    /* Add one free memory record */
    if (man->frees < MEMMAN_FREES) {
        for (j = man->frees; j > i; j--) {
            man->free[j] = man->free[j - 1];
        }
        man->frees++;
        if (man->maxfrees < man->frees) {
            man->maxfrees = man->frees;
        }
        man->free[i].addr = addr;
        man->free[i].size = size;
        return 0;
    }
    /* Can't free, discard it temp */
    /* FIXME SEEM THESE MEMORY CAN'T BE FOUND ANY MORE */
    man->losts++;
    man->lostsize += size;
    return -1;
}

unsigned int memman_alloc_4k(struct MEMMAN *man, unsigned int size)
{
    unsigned int a;
    size = (size + 0xfff) & 0xfffff000;
    a = memman_alloc(man, size);
    return a;
}

int memman_free_4k(struct MEMMAN *man, unsigned int addr, unsigned int size)
{
    int i;
    size = (size + 0xfff) & 0xfffff000;
    i = memman_free(man, addr, size);
    return i;
}
