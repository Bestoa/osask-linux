#ifndef __EXEC_H__
#define __EXEC_H__

const char *HEAD_STRING = "EXEC";

struct exec_header {
    char magic[4];
    unsigned int entry;
    unsigned int bss_start;
    unsigned int bss_len;
    unsigned int reserved[4];
};
#endif
