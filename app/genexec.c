#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../kernel/include/exec.h"
int main(int argc, char ** argv) {
    FILE * fp1, * fp2;
    char name[100];
    struct exec_header header;
    int ret, p, q;
    memset(&header, 0, sizeof(header));
    if (argc != 2) {
        printf("Usage: %s filenamebase\n", argv[0]);
        return -1;
    }
    sprintf(name , "%s.elfinfo", argv[1]);
    fp1 = fopen(name, "rb"); 
    if (fp1 != NULL) {
        while((ret = fscanf(fp1, "%s%x%x", name, &p, &q)) == 3) {
            if (strncmp(name, ".bss", 4) == 0) {
                header.bss_start = p;
                header.bss_len = q;
            }
        }
        fclose(fp1);
    }
    header.magic[0] = 'E';
    header.magic[1] = 'X';
    header.magic[2] = 'E';
    header.magic[3] = 'C';
    header.entry = sizeof(header);
    sprintf(name , "%s.bin", argv[1]);
    fp2 = fopen(name, "rb+");
    if (fp2 != NULL) {
        printf("Gen exec %s\n", name);
        fwrite(&header, sizeof(header), 1, fp2);
        fclose(fp2);
    }
    return 0;
}
