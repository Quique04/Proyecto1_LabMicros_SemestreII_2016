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

msg2 db   27,"[10;40f","EL 4313 Lab. Estructuras de microprosesadores. 2 semestre 2016",0xa; Mensaje del titulo
len2 equ $-msg2

msg1 db   0x1b,"[12;40f","MICRONOID",0xa; mensaje de titulo
len1 equ $-msg1

msg3 db   0x1b,"[14;40f",0x1b,"[5M","Bienvenido",0xa; mensaje de titulo
len3 equ $-msg3

msg4 db   0x1b,"[16;40f","Cual es su nombre: ";mensaje del titulo
len4 equ $-msg4


segment .bss; seccion de varaibles
res resb 255; variable donde se aloja el nombre de la personas tiene un Tamanao de 255 bits


;----------------------------------------------------------------------------------------------------------------------------------------------------------------
segment .text

leetecla:; rutnia de lectrua de teclado
	mov rax, 3; sys_read
	mov rbx, 0; teclado
	mov rdx, 255; tamano
	int 0x80; syscall
ret; se usa para volver a la rutina

global _start; inicio

_start:
escribe borrar, borrarl;-----------------borra la consola--------------------
;----------------------------------------Ciclo para pintar le borde superior-------------------------
mov rsi, 133;parametro limite del loop
mov rdi, 0;parametro icnial del loop

escribe lineaHorizontalSup,L_H_S; escribe el primer caracter de la linea horizontal superiror
Pinta_arriba:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pinar
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_arriba; salta a pint_arriba si rdi es menos a
;--------------------------------------------------------------------------------


;-----------------------------------------ciclo para pintar el borde inferior----------------------------------
mov rsi, 134;parametro limite del loop
mov rdi, 0;parametro icnial del loop

escribe lineaHorizontalinf,L_H_I; pinta el primer caracter de la linea horizontal inferior
Pinta_abajo:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pintar la linea
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_abajo; salta a pinta_abajo si rdi es menos a
;--------------------------------------------------------------------------------


;---------------------------------ciclo pra borde izquierdo------------------------------------------
mov rsi, 47;parametro limite del loop
mov rdi, 0;parametro icnial del loop
escribe lineaVI,largoVI ; pinta el primer caracter de la linea vertical izquierda
Pinta_izquierda:;etiqueta
	escribe lineaV,largoV; escribe el resto de la linea
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_izquierda; salta a pinta si rdi es menos a
;--------------------------------------------------------------------------------

;---------------------------------ciclo pra borde Drecho------------------------------------------
mov rsi, 47;parametro limite del loop
mov rdi, 0;parametro icnial del loop
escribe lineaVD,largoVD ; pinta el primer caracter de la linea vertical derecha
Pinta_derecha:;etiqueta
	escribe lineaV_D,largoV_D; escribe los caracteres en la linea vertical derecha
	add rdi, 1; suma 1 a rdi
	cmp rdi,rsi; compara rdi con rsi
	jb Pinta_derecha; salta a pinta si rdi es menos a
;--------------------------------------------------------------------------------


;------------------------------------mensajes de bienvenida---------------------------------------------

escribe msg2, len2; 
escribe msg1, len1
escribe msg3, len3
escribe msg4, len4
;-------------------------------------------------------------------------------------------------------
mov rcx,res;guarda en el registro RCX lo leido del teclado
call leetecla; llama al procedimiento de leet la tecla

escribe borrar, borrarl;-----------------borra la consola--------------------

salir;-----------------------------------procedimieto de salida-------------