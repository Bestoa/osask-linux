#ifndef __COMMON_H__
#define __COMMON_H__

#ifdef __TEST__
#define ENTER do{ \
    printf("Call %s, %d\n", __func__, __LINE__);\
}while(0)
#endif

#endif
