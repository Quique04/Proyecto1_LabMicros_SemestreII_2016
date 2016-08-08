%macro escribe 2;----------------macro para proseso de escritura
mov rax, 1; sys_write
mov rdi, 1; consala_predeterminda
mov rsi, %1; parametro 1
mov rdx, %2; parametro 2
syscall; syscall
%endmacro

%macro salir 0
 mov rax, 60
 xor rdi, 0
 syscall
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

msg2 db   27,"[15;40f","EL 4313 Lab. Estructuras de microprosesadores. 2 semestre 2016",0xa; Mensaje del titulo
len2 equ $-msg2

msg1 db   27,"[17;40f","MICRONOID",0xa; mensaje de titulo
len1 equ $-msg1

msg3 db   0x1b,"[19;40f",0x1b,"[5M","Bienvenido",0xa; mensaje de titulo
len3 equ $-msg3

msg4 db   0x1b,"[21;40f","Cual es su nombre: ";mensaje del titulo
len4 equ $-msg4


segment .bss; seccion de varaibles
res resb 255; variable donde se aloja el nombre de la personas tiene un Tamanao de 255 bits




;----------------------------------------------------------------------------------------------------------------------------------------------------------------
segment .text

leetecla:; rutnia de lectrua de teclado
	mov rax, 0; sys_read
	mov rdi, 0; teclado
	mov rdx, 255; tamano
	syscall; syscall
ret; se usa para volver a la rutina

global _start; inicio
global _parada;

_start:
escribe borrar, borrarl;-----------------borra la consola--------------------
;----------------------------------------Ciclo para pintar le borde superior-------------------------
mov r8, 133;parametro limite del loop
mov r9, 0;parametro icnial del loop

escribe lineaHorizontalSup,L_H_S; escribe el primer caracter de l a linea horizontal superiror
Pinta_arriba:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pinar
	add r9, 1; suma 1 a rdi
	cmp r8,r9; compara rdi con rsi
	jg Pinta_arriba; salta a pint_arriba si rdi es menos a
;--------------------------------------------------------------------------------

_parada:
;-----------------------------------------ciclo para pintar el borde inferior----------------------------------
mov r8, 134;parametro limite del loop
mov r9, 0;parametro icnial del loop

escribe lineaHorizontalinf,L_H_I; pinta el primer caracter de la linea horizontal inferior
Pinta_abajo:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pintar la linea
	add r9, 1; suma 1 a rdi
	cmp r9,r8; compara rdi con rsi
	jne Pinta_abajo; salta a pinta_abajo si rdi es menos a
;--------------------------------------------------------------------------------


;---------------------------------ciclo pra borde izquierdo------------------------------------------
mov r8, 47;parametro limite del loop
mov r9, 0;parametro icnial del loop
escribe lineaVI,largoVI ; pinta el primer caracter de la linea vertical izquierda
Pinta_izquierda:;etiqueta
	escribe lineaV,largoV; escribe el resto de la linea
	add r9, 1; suma 1 a rdi
	cmp r8,r9; compara rdi con rsi
	jne Pinta_izquierda; salta a pinta si rdi es menos a
;--------------------------------------------------------------------------------

;---------------------------------ciclo pra borde Drecho------------------------------------------
mov r8, 47;parametro limite del loop
mov r9, 0;parametro icnial del loop
escribe lineaVD,largoVD ; pinta el primer caracter de la linea vertical derecha
Pinta_derecha:;etiqueta
	escribe lineaV_D,largoV_D; escribe los caracteres en la linea vertical derecha
	add r9, 1; suma 1 a rdi
	cmp r9,r8; compara rdi con rsi
	jne Pinta_derecha; salta a pinta si rdi es menos a
;--------------------------------------------------------------------------------


;------------------------------------mensajes de bienvenida---------------------------------------------
escribe msg2, len2; 
escribe msg1, len1
escribe msg3, len3
escribe msg4, len4

;-------------------------------------------------------------------------------------------------------
mov rsi,res;guarda en el registro rsi lo leido del teclado
call leetecla; llama al procedimiento de leet la tecla

escribe borrar, borrarl;-----------------borra la consola--------------------

salir;-----------------------------------procedimieto de salida-------------