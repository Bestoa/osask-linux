#include "../lib.h"
void test_sprintf()
{
    char test[100] = {0};
    int r = sprintf(test, " %s %d %d %c ", "TesT", 123, -456, 'a');
    printf("%d:%s\n", r, test);
}
int main() {
    test_sprintf();
    return 0;
}
