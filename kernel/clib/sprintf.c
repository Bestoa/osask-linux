#include <stdarg.h>
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
void strcpy(char *s1, char *s2)
{
#ifdef __TEST__
    ENTER;
#endif
    while(*s1++ = *s2++);
}
void write_int(char **buffer, int value)
{
    char stack[20] = {0};
    char i = 0;
    char *temp = *buffer;
    char number[] = "0123456789ABCDEF";

#ifdef __TEST__
    ENTER;
#endif

    if(value < 0){
        *(temp++)='-';
        value *= -1;
    }
    do
    {
        stack[i] = number[(value%10)];
        value /= 10;
        i++;
    }while(value);

    while(--i >= 0)
    {
        *(temp++) = stack[i];
    }
    *buffer = temp;
}

int sprintf(char* buffer,const char* format,...)
{
    va_list arg_ptr;
    int i = 0;

    int temp;
    char *stemp, *head = buffer;
#ifdef __TEST__
    ENTER;
#endif

    va_start(arg_ptr,format);
    for(i = 0; format[i]; i++)
    {
        if(format[i]!='%') {
            (*buffer++) = format[i];
            continue;
        }
        i++;
        switch(format[i])
        {
            case 'd':
                temp = va_arg(arg_ptr, int);
                write_int(&buffer, temp);
                break;
            case 's':
                stemp = (char *)va_arg(arg_ptr, char *);
                strcpy(buffer, stemp);
                buffer += strlen(stemp);
                break;
            case 'c':
                temp = va_arg(arg_ptr, int);
                *(buffer++) = temp;
                break;
        }
    }
    *buffer=0;
    va_end(arg_ptr);
    return buffer - head;
}
