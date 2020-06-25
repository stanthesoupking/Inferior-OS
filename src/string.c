#include "string.h"

int strlen(const char *str)
{
    int count = 0;
    char c = *str;

    while (c != '\0')
    {
        count++;
        c = *str++;
    }

    return count;
}