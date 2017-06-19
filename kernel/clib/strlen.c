#include "common.h"
int strlen(char *s)
{
    int i = 0;
#ifdef __TEST__
    ENTER;
#endif
    while(s[i++]);
    return i - 1;
}
