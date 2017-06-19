#include <stdarg.h>
#include "common.h"
#include "lib.h"
static void write_int(char **buffer, int value, int base)
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
        stack[i] = number[(value%base)];
        value /= base;
        i++;
    }while(value);

    while(--i >= 0)
    {
        *(temp++) = stack[i];
    }
    *buffer = temp;
}

int sprintf(char* buffer,char* format,...)
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
            case 'x':
                temp = va_arg(arg_ptr, int);
                write_int(&buffer, temp, 16);
                break;
            case 'd':
                temp = va_arg(arg_ptr, int);
                write_int(&buffer, temp, 10);
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
