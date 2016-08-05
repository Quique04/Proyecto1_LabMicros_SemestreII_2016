section .data

	men_Warn: db 'El cpu no puede obtener la info',0xa
	mw: equ $-men_Warn

section .bss

	nom1 resb 32

section .text

	global _start
	global _salida

_start:

	mov rax,80000000h
	cpuid
	mov rsi,80000004h
	cmp rax,rsi ; compara por si el cpu no tiene la capacidad obtener la info
	
	jb cpu_malo
	
	mov rax,80000002h
	cpuid
	mov [nom1],rax
	mov [nom1 + 0x4],rbx
	mov [nom1 + 0x8],rcx
	mov [nom1 + 0xC],rdx
	
	mov rax,80000003h
	cpuid
	mov [nom1 + 0x10],rax
	mov [nom1 + 0x14],rbx
	mov [nom1 + 0x18],rcx
	mov [nom1 + 0x1C],rdx
	
	
	mov rax,80000004h
	cpuid
	mov [nom1 + 0x20],rax
	mov [nom1 + 0x24],rbx
	mov [nom1 + 0x28],rcx
	mov [nom1 + 0x2C],rdx
	
	mov rax,1
	mov rdi,1
	mov rsi,nom1
	mov rdx,48
	
	syscall
	
	;liberar los recursos
	
_salida:

	mov rax,60    ;rax = sys_exit (60)
	mov rdi,0     ;rdi = 0


	syscall 

cpu_malo: 
	
	mov rax,1
	mov rdi,1
	mov rsi,men_Warn
	mov rdx,mw
	
	syscall
	
	jmp _salida
	
	
	
	
	
	
	
	
	
	
	
	
	
	
