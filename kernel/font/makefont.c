#include <stdio.h>
int main(int argc, char **argv){
    FILE *fp1 = NULL;
    FILE *fp2 = NULL;
    char line[9];
    int i, value;
    if (argc != 3) {
        printf("Usage: makefont source target\n");
        return 0;
    }

    fp1 = fopen(argv[1], "r");
    if (fp1 == NULL) {
        printf("Open input file failed\n");
        return 0;
    }
    fp2 = fopen(argv[2], "w");
    if (fp2 == NULL) {
        printf("Open output file failed\n");
        fclose(fp1);
        return 0;
    }
    fputs("#ifndef __FONT_H__\n"
            "#define __FONT_H__\n"
            "char font[] = { \n",
            fp2);
    while (fgets(line, 9, fp1) != NULL) {
        if (line[0] != '.' && line[0] != '*')
            continue;
        value = 0;
        for (i = 0; i < 8; i++) {
            if (line[i] == '*') {
                value |= 1 << (7-i);
            }
        }
        fprintf(fp2, "\t0x%x, \n", value); 
    }
    fputs("};\n"
            "#endif",
            fp2);
    fclose(fp1);
    fclose(fp2);
    return 0;
}
