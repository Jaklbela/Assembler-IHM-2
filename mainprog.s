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
	jmp	.L2					# Перемещаемся к метке /L2
.L5:
	mov	eax, DWORD PTR -28[rbp]
	sub	eax, 2
	mov	edx, r12d
	sub	eax, edx
	mov	r13d, eax
	mov	eax, r12d
	movsx	rdx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rdx
	movzx	edx, BYTE PTR [rax]
	mov	eax, r13d
	movsx	rcx, eax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, rcx
	movzx	eax, BYTE PTR [rax]
	cmp	dl, al
	je	.L3
	mov	eax, 0
	jmp	.L4
.L3:
	mov	eax, r12d
	add	eax, 1
	mov	r12d, eax
.L2:						# метка .L2
	mov	edx, r12d				# Переносим счетчик в регистр edx
	mov	eax, r11d
	cmp	edx, eax
	jne	.L5
	mov	eax, 1
.L4:
	pop	r12
	pop	r13
	pop	rbp
	ret
	.size	is_palindrom, .-is_palindrom
	.section	.rodata
	.align 8
.LC0:
	.string	"Input the string no longer than 500000 symbols"
.LC1:
	.string	"The string is too big!"
.LC2:
	.string	"\nIt's palindrom!"
.LC3:
	.string	"\nIt's not palindrom!"
	.text
	.globl	main
	.type	main, @function
main:
	endbr64
	push	rbp
	mov	rbp, rsp
	push	r15
	push	r14
	lea	r11, -499712[rsp]
.LPSRL0:
	sub	rsp, 4096
	or	DWORD PTR [rsp], 0
	cmp	rsp, r11
	jne	.LPSRL0
	sub	rsp, 288
	mov	r15d, 0
	lea	rax, .LC0[rip]
	mov	rdi, rax
	call	puts@PLT
.L8:
	mov	rax, QWORD PTR stdin[rip]
	mov	rdi, rax
	call	fgetc@PLT
	mov	r14d, eax
	mov	eax, r15d
	mov	edx, r14d
	cdqe
	mov	BYTE PTR -500016[rbp+rax], dl
	mov	eax, r15d
	add	eax, 1
	mov	r15d, eax
	mov	eax, r14d
	cmp	al, -1
	je	.L7
	mov	eax, r15d
	cmp	eax, 499999
	jle	.L8
.L7:
	mov	eax, r15d
	cmp	eax, 499999
	jle	.L9
	lea	rax, .LC1[rip]
	mov	rdi, rax
	call	puts@PLT
	mov	eax, 0
	jmp	.L13
.L9:
	mov	edx, r15d
	lea	rax, -500016[rbp]
	mov	esi, edx
	mov	rdi, rax
	call	is_palindrom
	test	al, al
	je	.L11
	lea	rax, .LC2[rip]
	mov	rdi, rax
	call	puts@PLT
	jmp	.L12
.L11:
	lea	rax, .LC3[rip]
	mov	rdi, rax
	call	puts@PLT
.L12:
	mov	eax, 0
.L13:
	add	rsp, 500000
	pop	r14
	pop	r15
	pop	rbp
	ret
