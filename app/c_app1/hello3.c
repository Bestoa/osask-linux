void api_putchar(int c);

char *test = "3";

void main(void)
{
    api_putchar('H');
    api_putchar('e');
    api_putchar('l');
    api_putchar('l');
    api_putchar('o');
    api_putchar(*test);
    return;
}
