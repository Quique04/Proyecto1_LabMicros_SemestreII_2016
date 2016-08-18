%macro escribe 2;----------------macro para proseso de escritura
mov rax, 1; sys_write
mov rdi, 1; consala_predeterminda
mov rsi, %1; parametro 1
mov rdx, %2; parametro 2
syscall; syscall
%endmacro

%macro salir 0
 mov rax, 60
 mov rdi,0
 syscall
%endmacro

segment .data

borraPan: db 27,'[2J'                ; borramos la pantalla y
borraPanT: equ 4                    ; tamanno de la variable anterior

SinCursor: db 27,'[?25l'             ; me elimina el parpadeo del cursos en la consola
SinCursorT: equ 6                    ; tamanno de la variable anterior

lineaHorizontalSup: db 0x1b,"[0;0f ","===================================";primer caratcter de la linea Horizontal superior
L_H_S: equ $-lineaHorizontalSup

lineaHorizontalInf: db 0x1b,"[30;0f ","===================================";primer caratcter de la linea Horizontal superior
L_H_I: equ $-lineaHorizontalInf

LIzq: db 0x1b, "[2;0f","|",27,"[3;0f","|",27,"[4;0f","|",27,"[5;0f","|",27,"[6;0f","|",27,"[7;0f","|",27,"[8;0f","|",27,"[9;0f","|",27,"[10;0f","|",27,"[11;0f","|",27,"[12;0f","|",27,"[13;0f","|",27,"[14;0f","|",27,"[15;0f","|",27,"[16;0f","|",27,"[17;0f","|",27,"[18;0f","|",27,"[19;0f","|",27,"[20;0f","|",27,"[21;0f","|",27,"[22;0f","|",27,"[23;0f","|",27,"[24;0f","|",27,"[25;0f","|",27,"[26;0f","|",27,"[27;0f","|",27,"[28;0f","|",27,"[29;0f","|"
LIzql: equ $-LIzq

LDer: db 0x1b, "[2;37f","|",27,"[3;37f","|",27,"[4;37f","|",27,"[5;37f","|",27,"[6;37f","|",27,"[7;37f","|",27,"[8;37f","|",27,"[9;37f","|",27,"[10;37f","|",27,"[11;37f","|",27,"[12;37f","|",27,"[13;37f","|",27,"[14;37f","|",27,"[15;37f","|",27,"[16;37f","|",27,"[17;37f","|",27,"[18;37f","|",27,"[19;37f","|",27,"[20;37f","|",27,"[21;37f","|",27,"[22;37f","|",27,"[23;37f","|",27,"[24;37f","|",27,"[25;37f","|",27,"[26;37f","|",27,"[27;37f","|",27,"[28;37f","|",27,"[29;37f","|"
LDerl: equ $-LDer

segment .text

	global _start

_start:

escribe SinCursor,SinCursorT
escribe borraPan,borraPanT
escribe lineaHorizontalSup, L_H_S
escribe lineaHorizontalInf, L_H_I
escribe LIzq,LIzql
escribe LDer,LDerl
salir
