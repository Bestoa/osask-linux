#include "common.h"
void strcpy(char *s1, char *s2)
{
#ifdef __TEST__
    ENTER;
#endif
    while(*s1++ = *s2++);
}
