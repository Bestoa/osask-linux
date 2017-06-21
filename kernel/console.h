#ifndef __CONSOLE_H__
#define __CONSOLE_H__
#include "sheet.h"
void console_task(struct SHEET *sheet, unsigned int memtotal);
int cons_newline(int cursor_y, struct SHEET *sheet);
#endif
