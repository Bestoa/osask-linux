int api_openwin(char *buf, int xsiz, int ysiz, int col_inv, char *title);
void api_boxfilwin(int win, int x0, int y0, int x1, int y1, int col);
void api_point(int win, int x, int y, int col);
void api_refreshwin(int win, int x0, int y0, int x1, int y1);

int rand(void);

void main(void)
{
    char buf[150*100];
    int win, i, x, y;
    win = api_openwin(buf, 150, 100, -1, "stars2");
    api_boxfilwin(win + 1,  6, 26, 143, 93, 0);
    for (i = 0; i < 50; i++) {
        x = (rand() % 137) +  6;
        y = (rand() %  67) + 26;
        api_point(win + 1, x, y, 3);
    }
    api_refreshwin(win,  6, 26, 144, 94);
}
