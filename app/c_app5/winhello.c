int api_openwin(char *buf, int xsiz, int ysiz, int col_inv, char *title);

char buf[150*50];

void main(void)
{
    int win;
    win = api_openwin(buf, 150, 50, -1, "hello");
}
