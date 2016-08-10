%macro escribe 2;----------------macro para proseso de escritura
mov rax, 4; sys_write
mov rbx, 1; consala_predeterminda
mov rcx, %1; parametro 1
mov rdx, %2; parametro 2
int 0x80; syscall
%endmacro

%macro salir 0
 mov rax, 1
 xor rbx, rbx
 int 0x80
%endmacro

segment .data
;----------------------------------------------------Constantes del programa------------------------------------------------
borrar: db 27,"[2J", 27,"[u";Mensaje para borrar la consola
borrarl: equ 4; Tamanao

lineaHorizontalSup: db 0x1b,"[1;1f "," =";primer caratcter de la linea Horizontal superior
L_H_S: equ $-lineaHorizontalSup

lineaHorizontalinf: db 0x1b,"[49;1f "," ="; primer caracter de la linea horizontal superior
L_H_I: equ $-lineaHorizontalinf

lineaHorizontal: db "="; caracter de las lineas horizontal
L_H: equ $-lineaHorizontal
 
lineaVI: db 0x1b,"[0;0f ",27,"[2D","||",0xa; primer caracter de la linea vertical izquierda
largoVI: equ $-lineaVI

lineaVD: db 27,"[2;135f ","||"; primer carcter de la linea vertical Pinta_derecha
largoVD: equ $-lineaVD

lineaV: db 27,"[2D","||",0xa; caracteres de la linea vertical derecha
largoV: equ $-lineaV

lineaV_D: db 27,"[1B",27,"[2D","||"; caracteres de la linea vertical izquierda
largoV_D: equ $-lineaV_D
;--------------------------------------------Contenido del marco------------------------------------------------------------------

msg2 db   27,"[10;40f","EL 4313 Lab. Estructuras de microprosesadores. 2 semestre 2016",0xa; Mensaje del titulo
len2 equ $-msg2

msg1 db   0x1b,"[12;40f","MICRONOID",0xa; mensaje de titulo
len1 equ $-msg1

msg3 db   0x1b,"[14;40f",0x1b,"[5M","Bienvenido",0xa; mensaje de titulo
len3 equ $-msg3

msg4 db   0x1b,"[16;40f","Cual es su nombre: ";mensaje del titulo
len4 equ $-msg4


msg5: db   27,"[7;55f","Gracias por jugar Micronoid",0xa; Mensaje RBN-480
len5: equ $-msg5

msg6: db   27,"[12;55f",'Daniel Leon Gamboa 2013036468',27,"[13;55f",'Enrique Hernandez 2013000000',27,"[14;55f",'Gabriel Madrigal Bozer 2013012324',27,"[15;55f",'Amit Ferencz Appel 2013385898',0xa; Mensaje RBN-490
len6: equ $-msg6


;msg3 db   27,"[20;55f","Info de la compu (id, modelo y familia)",0xa; info de RBN-500-510
;len3 equ $-msg3
	
cursorPos: db 27, "[20;55f"	; Posicion de la bola en el inicio = fila ; columna, Esc "[r9,r10 ; r12,r13H"
cursorPosT: equ 8 
	
msg7: db   27,"[22;55f","porcentaje del micro",0xa; Mensaje RBN-520
len7: equ $-msg7


msg8: db   27,"[30;55f","*****Presine Enter para terminar****",27,"[?25l",0xa;mensaje RBN-530
len8: equ $-msg8
	
men_Warn: db 'El cpu no puede obtener la info',0xa
mw: equ $-men_Warn

esconde: db 27,"[u"
largo_esconde: equ $-esconde


segment .bss; seccion de varaibles
res resb 255; variable donde se aloja el nombre de la personas tiene un Tamanao de 255 bits
nom1 resb 32
ent resb 1

segment .text

leetecla:; rutnia de lectrua de teclado
	mov rax, 3; sys_read
	mov rbx, 0; teclado
	mov rdx, 255; tamano
	int 0x80; syscall
ret; se usa para volver a la rutina
marco:
;----------------------------------------Ciclo para pintar le borde superior-------------------------
mov rsi, 133;parametro limite del loop
mov rdi, 0;parametro icnial del loop

escribe lineaHorizontalSup,L_H_S; escribe el primer caracter de la linea horizontal superiror
Pinta_a:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pinar
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_a; salta a pint_arriba si rdi es menos a
;--------------------------------------------------------------------------------
;-----------------------------------------ciclo para pintar el borde inferior----------------------------------
mov rsi, 134;parametro limite del loop
mov rdi, 0;parametro icnial del loop

escribe lineaHorizontalinf,L_H_I; pinta el primer caracter de la linea horizontal inferior
Pinta_ab:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pintar la linea
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_ab; salta a pinta_abajo si rdi es menos a
;--------------------------------------------------------------------------------
;---------------------------------ciclo pra borde izquierdo------------------------------------------
mov rsi, 47;parametro limite del loop
mov rdi, 0;parametro icnial del loop
escribe lineaVI,largoVI ; pinta el primer caracter de la linea vertical izquierda
Pinta_izq:;etiqueta
	escribe lineaV,largoV; escribe el resto de la linea
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_izq; salta a pinta si rdi es menos a
;--------------------------------------------------------------------------------
;---------------------------------ciclo pra borde Drecho------------------------------------------
mov rsi, 47;parametro limite del loop
mov rdi, 0;parametro icnial del loop
escribe lineaVD,largoVD ; pinta el primer caracter de la linea vertical derecha
Pinta_d:;etiqueta
	escribe lineaV_D,largoV_D; escribe los caracteres en la linea vertical derecha
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_d; salta a pinta si rdi es menos a
ret
;--------------------------------------------------------------------------------
global _start; inicio
global _salida;



_start:
escribe borrar, borrarl;-----------------borra la consola--------------------
call marco
;------------------------------------mensajes de bienvenida---------------------------------------------
escribe msg2, len2; 
escribe msg1, len1
escribe msg3, len3
escribe msg4, len4
;-------------------------------------------------------------------------------------------------------
mov rcx,res;guarda en el registro RCX lo leido del teclado
call leetecla; llama al procedimiento de leet la tecla
escribe borrar, borrarl;-----------------borra la consola--------------------

call marco

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
	
	;mov rax,1
	;mov rdi,1
	;mov rsi,nom1
	;mov rdx,48
	
	;syscall

;------------------------------------mensajes de bienvenida---------------------------------------------

escribe msg5, len5
 
escribe msg6, len6

escribe cursorPos, cursorPosT

escribe nom1, 48

escribe msg7, len7

escribe msg8, len8

escribe esconde,largo_esconde

mov rsi, ent
call leetecla;
escribe borrar, borrarl;-----------------borra la consola--------------------

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
	
;---------------------------------procedimieto de salida-------------
