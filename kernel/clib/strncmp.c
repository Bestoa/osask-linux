int strncmp(char *s1, char *s2, int n) {
    while( *s1 != 0 && *s2 != 0 && n-- > 0) {
        if (*s1 != *s2)
            return *s1 - *s2;
        s1++;
        s2++;
    }
    if (n == 0)
        return 0;
    else
        return *s1 - *s2;
}
