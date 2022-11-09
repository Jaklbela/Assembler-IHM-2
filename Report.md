# Отчет по ИДЗ №2

## 6 баллов

### Код на C
```c
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
```

### Компиляция программы с оптимизацией
```sh
gcc -masm=intel \
    -fno-asynchronous-unwind-tables \
    -fno-jump-tables \
    -fno-stack-protector \
    -fno-exceptions \
    ./mainprog.c \
    -S -o ./optimized.s
```


### Оптимизированный код на ассемблере с комментариями и максимальным использованием регистров
``` assembly

```

### Тестовые прогоны


| Входные данные  | mainprog.c      | mainprog.s      |
|-----------------|:---------------:|:---------------:|
| [4 5 8 0]       | [4 4 4 0]     | [4 4 4 0]     |
| [13 1768 56 97 36 27 85 56 876]    | [13 334 56 97 36 27 85 56 334] | [13 334 56 97 36 27 85 56 334] |
| [-1 17 0 -567 65 -43 15]| [-73 -73 -73 -567 -73 -73 -73]|[-73 -73 -73 -567 -73 -73 -73]|

Подтверждающие тесты скриншоты находятся в репозитории в файле Tests.jpg: 
