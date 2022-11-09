#include <stdio.h>
#include <stdbool.h>

bool is_palindrom(char *str, int size) {
    int border = size / 2;
    int i;
    for (i = 0; i != border; ++i) {
        int ind = size - 2 - i;
        if (str[i] != str[ind]) {
            return false;
        }
    }
    return true;
}

int main() {
    char str[500000];
    char el;
    int length = 0;

    printf("Input the string no longer than 500000 symbols\n");
    do {
        el = fgetc(stdin);
        str[length] = el;
        length++;
    } while (el != -1 && length < 500000);
    if (length >= 500000) {
        printf("The string is too big!\n");
        return 0;
    }

    if (is_palindrom(str, length)) {
        printf("\nIt's palindrom!\n");
    } else {
        printf("\nIt's not palindrom!\n");
    }
    return 0;
}
