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
.intel_syntax noprefix				# Указание на синтаксис intel
	.text						# Начало новой секции
	.globl	is_palindrom				# Объявление имени is_palindrom
	.type	is_palindrom, @function			# Указание, что это функция
is_palindrom:					# Метка функции is_palindrom:
	endbr64						# -
	push	rbp					# Сохранили предыдущий rbp на стек
	mov	rbp, rsp				# Вместо rbp записали rsp
	push	r13					# Записали регистр r13 (индекс для сравнения элементов с конца массива)
	push	r12					# Записали регистр r12 (счетчик i)
	mov	QWORD PTR -24[rbp], rdi			# Передача в функцию массива char (нашей строки)
	mov	DWORD PTR -28[rbp], esi			# Передача в функцию длины строки
	mov	eax, DWORD PTR -28[rbp]			# eax = rbp[28] (Переносим размер в другой регистр)
	mov	edx, eax				# edx = eax (Снова переносим размер в другой регистр)
	shr	edx, 31					# Побитовый сдвиг размера вправо на 31
	add	eax, edx				# Складываем eax и edx
	sar	eax					# Побитовый сдвиг eax с сохранением знака (деление)
	mov	r11d, eax				# Кладем в r11d eax (То есть кладем в регистр-переменную значение размера, деленного на два)
	mov	r12d, 0					# Обнуляем счетчик
	mov	r12d, 0					# Обнуляем индекс (ind)
	jmp	.L2					# Перемещаемся к метке .L2
.L5:						# Метка .L5
	mov	eax, DWORD PTR -28[rbp]			# Переносим длину строки в eax
	sub	eax, 2					# Вычитаем 2 из eax
	mov	edx, r12d				# Переносим счетчик в edx
	sub	eax, edx				# Вычитаем из eax счетчик (Теперь мы выполнили строку ind = size - 2 - i)
	mov	r13d, eax				# Переносим полученное значение в индекс
	mov	eax, r12d				# Переносим в eax значение счетчика
	movsx	rdx, eax				# Перемещает eax в rdx, дополняя знаком (больший регистр)
	mov	rax, QWORD PTR -24[rbp]			# Переносим массив символов (строку) в rax
	add	rax, rdx				# Складываем rax и rdx
	movzx	edx, BYTE PTR [rax]			# Переносим rax в edx 
	mov	eax, r13d				# Переносим индекс в eax
	movsx	rcx, eax				# Переносим eax в rcx
	mov	rax, QWORD PTR -24[rbp]			# Переносим строку в rax
	add	rax, rcx				# Складываем rax и rcx
	movzx	eax, BYTE PTR [rax]			# Переносим rax в eax
	cmp	dl, al					# Сравниваем dl и al
	je	.L3					# Если равны, переход к метке .L3
	mov	eax, 0					# Кладем 0 в eax
	jmp	.L4					# Переход к .L4
.L3:						# Метка .L3
	mov	eax, r12d				# Переносим счетчик в eax
	add	eax, 1					# Увеличиваем счетчик на 1
	mov	r12d, eax				# Переносим счетчик обратно в r12d
.L2:						# метка .L2
	mov	edx, r12d				# Переносим счетчик в регистр edx
	mov	eax, r11d				# Переносим границу середины (переменная border в eax)
	cmp	edx, eax				# Сравниваем счетчик и границу
	jne	.L5					# Если не равны, переход к метке .L5
	mov	eax, 1					# Увеличение счетчика на единицу
.L4:						# Метка .L4
	pop	r12					# Удаляем r12
	pop	r13					# Удаляем r13
	pop	rbp					# Удаляем rbp
	ret						# Выход из функции
	.size	is_palindrom, .-is_palindrom		# -
	.section	.rodata				# -
	.align 8					# -
.LC0:						# Метка .LC0
	.string	"Input the string no longer than 500000 symbols"	# Строка перед вводом
.LC1:						# Метка .LC1
	.string	"The string is too big!"				# Строка при слишком длинном вводе
.LC2:						# Метка .LC2
	.string	"\nIt's palindrom!"					# Указание, что введенная строка палиндром
.LC3:						# Метка .LC3
	.string	"\nIt's not palindrom!"					# Указание, что введенная строка не палиндром
	.text						# Новая секция
	.globl	main					# Объявляем имя main
	.type	main, @function				# Указываем, что это функция
main:						# Метка main
	endbr64						# -
	push	rbp					# Записываем rbp
	mov	rbp, rsp				# Вместо rbp кладем rsp
	push	r15					# Записываем r15 (длинна ввденной строки)
	push	r14					# Записываем r14 (char элемент массива (строки))
	lea	r11, -499712[rsp]			# r11 = rsp[-499712]
.LPSRL0:					# Метка .LPSRL0
	sub	rsp, 4096				# Вычитаем из rsp 4096
	or	DWORD PTR [rsp], 0			# Побитовое ИЛИ между rsp и 0
	cmp	rsp, r11				# Сравниваем rsp и r11
	jne	.LPSRL0					# Если не равны, начинаем снова с метки
	sub	rsp, 288				# Вычитаем из rsp 228
	mov	r15d, 0					# Обнуляем длину строки
	lea	rax, .LC0[rip]				# начинаем печать первой строки
	mov	rdi, rax				# rdi = rax
	call	puts@PLT				# Вызываем функцию puts (Теперь точно напечаталм)
.L8:						# Метка .L8
	mov	rax, QWORD PTR stdin[rip]		# rax = stdin (Выбираем поток для считывания)
	mov	rdi, rax				# Кладем информацию о потоке в rdi
	call	fgetc@PLT				# Вызываем функцию fgetc
	mov	r14d, eax				# Кладем eax в r14d (будущий элемент массива)
	mov	eax, r15d				# eax = r15d (длина массива)
	mov	edx, r14d				# edx = r14d (элемент массива)
	cdqe						# Расширяем двойное слово до четверного
	mov	BYTE PTR -500016[rbp+rax], dl		# rbp+rax = dl
	mov	eax, r15d				# eax = r15d
	add	eax, 1					# Увеличиваем длину на 1
	mov	r15d, eax				# Кладем длину обратно в r15d
	mov	eax, r14d				# Кладем элемент в eax
	cmp	al, -1					# Сравниваем al и -1
	je	.L7					# Если не равны, перемещаемся к .L7
	mov	eax, r15d				# Кладем длину в eax
	cmp	eax, 499999				# Сравниваем длину и 499999
	jle	.L8					# Если меньше, перемещаемся к .L8
.L7:						# Метка .L7
	mov	eax, r15d				# Кладем длину в eax
	cmp	eax, 499999				# Сравниваем длину и 499999
	jle	.L9					# Если меньше, перемещаемся к .L9
	lea	rax, .LC1[rip]				# Начинаем печать строки об ошибке
	mov	rdi, rax				# rdi = rax
	call	puts@PLT				# Вызываем функцию puts и заканчиваем печать
	mov	eax, 0					# eax = 0
	jmp	.L13					# Переходим к .L13
.L9:						# Метка .L9
	mov	edx, r15d				# Переносим длину в edx
	lea	rax, -500016[rbp]			# rax = rbp[-500016]
	mov	esi, edx				# esi = edx (Передаем в функцию is_palindrom длину строки)
	mov	rdi, rax				# rdi = rax (Передаем в функцию массив char)
	call	is_palindrom				# Вызываем функцию
	test	al, al					# Логическое И между al и al (Смотрим, вернула ли функция true)
	je	.L11					# Если не вернула, то переходим к .L11
	lea	rax, .LC2[rip]				# Начинаем печатать строку, о том, что ввели палиндром
	mov	rdi, rax				# rdi = rax
	call	puts@PLT				# Вызываем функцию, заканчиваем печать
	jmp	.L12					# Переходим к .L12
.L11:						# Метка .L11
	lea	rax, .LC3[rip]				# Начинаем печатать строку, о том, что ввели не палиндром
	mov	rdi, rax				# rdi = rax
	call	puts@PLT				# Вызыаем функцию, заканчиваем печать
.L12:						# Метка .L12
	mov	eax, 0					# Обнуляем eax
.L13:						# Метка .L13
	add	rsp, 500000				# Складываем rsp и 500000
	pop	r14					# Удаляем r14
	pop	r15					# Удаляем r15
	pop	rbp					# Удаляем rbp
	ret						# Заканчиваем функцию
```
### Заметим, что изначально полученный с помощью компиляции код на ассемблере сильно отличается по размеру от моего кода с оптимизацией и измененными регистрами.

### Тестовые прогоны


| Входные данные  | mainprog.c      | mainprog.s      |
|-----------------|:---------------:|:---------------:|
| assemblerrelbmessa       | It's palindrom!     | It's palindrom!     |
| linuxunil    | It's palindrom!  | It's palindrom! |
| dihsfsdhfksdfhksdah| It's not palindrom!|It's not palindrom!|

Подтверждающие тесты скриншоты находятся в репозитории в файле Tests.jpg: https://github.com/Jaklbela/Assembler-IHM-2/blob/main/Tests.jpg
