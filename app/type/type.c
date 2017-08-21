#include "c_api.h"

void main(void)
{
	int fh;
	char c, cmdline[30], *p;
	api_cmdline(cmdline, 30);
	for (p = cmdline; *p > ' '; p++) { }
	for (; *p == ' '; p++) { }
	fh = api_fopen(p);
	if (fh != 0) {
		for (;;) {
			if (api_fread(&c, 1, fh) == 0) {
				break;
			}
			api_putchar(c);
		}
	} else {
		api_putstr0("File not found.\n");
	}
}
