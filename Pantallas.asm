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
;----------------------------------------------------Constantes del programa------------------------------------------------
termios:        times 36 db 0
stdin:          equ 0
ICANON:         equ 1<<1
ECHO:           equ 1<<3

borrar: db 27,"[2J", 27,"[u";Mensaje para borrar la consola
borrarl: equ 4; Tamanao

jugador: db 0x1b,"[52;1f ","Jugardor: "
Ljugador: equ $-jugador

vidas: db 0x1b,"[52;30f ","Vidas: "
lvidas: equ $-vidas

lineaHorizontalSup: db 0x1b,"[0;0f "," =";primer caratcter de la linea Horizontal superior
L_H_S: equ $-lineaHorizontalSup

lineaHorizontalinf: db 0x1b,"[51;1f "," ="; primer caracter de la linea horizontal superior
L_H_I: equ $-lineaHorizontalinf

lineaHorizontal: db "="; caracter de las lineas horizontal
L_H: equ $-lineaHorizontal
 
lineaVI: db 0x1b,"[0;0f ",27,"[2D","||",0xa; primer caracter de la linea vertical izquierda
largoVI: equ $-lineaVI

lineaVD: db 27,"[0;71H ","||"; primer carcter de la linea vertical Pinta_derecha
largoVD: equ $-lineaVD

lineaV: db 27,"[2D","||",0xa; caracteres de la linea vertical derecha
largoV: equ $-lineaV

lineaV_D: db 27,"[1B",27,"[2D","||"; caracteres de la linea vertical izquierda
largoV_D: equ $-lineaV_D

Bienvenida: db   0x1b,"[20;5f","---------------------Presione X para continuar---------------------"
L_Bienvenida: equ $-Bienvenida
;--------------------------------------------Contenido del marco------------------------------------------------------------------

msg1 db   27,"[10;5f","EL 4313 Lab. Estructuras de microprosesadores. 2 semestre 2016", 0x1b,"[12;5f","MICRONOID",0x1b,"[14;5f",0x1b,"[5M","Bienvenido", 0x1b,"[14;5f",0x1b,"[5M","Bienvenido",  0x1b,"[16;5f","Cual es su nombre: "
len1 equ $-msg1

;-------------------------------------------------mensajes de pantalla de Bienvenida-----------------------------------------------------------------


cursorPos0: db 27,'[2;3H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost0: equ $-cursorPos0

cursorPos1: db 27,'[2;26H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost1: equ $-cursorPos1

cursorPos2: db 27,'[2;49H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost2: equ $-cursorPos2

cursorPos3: db 27,'[5;3H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost3: equ $-cursorPos3

cursorPos4: db 27,'[5;26H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost4: equ $-cursorPos4

cursorPos5: db 27,'[5;49H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost5: equ $-cursorPos5

cursorPos6: db 27,'[8;3H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost6: equ $-cursorPos6

cursorPos7: db 27,'[8;26H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost7: equ $-cursorPos7

cursorPos8: db 27,'[8;49H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost8: equ $-cursorPos8


borraBloque: db "                       ", 27,'[23D', 27,'[1B'," ",27,'[1B',27,'[1D',"                       ", 27,'[1A',27,'[1D'," "
LborraBloque: equ $-borraBloque

bloqueU: db "+---------------------+", 27,'[23D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------------------+", 27,'[1A',27,'[1D',"|"
Lbloque: equ $-bloqueU
;----------------------------------------------------constantes de los bloques-------------------------------------------------------------


msg2: db    27,"[7;5f","Gracias por jugar Micronoid",27,"[12;5f",'Daniel Leon Gamboa 2013036468',27,"[13;5f",'Enrique Hernandez 2013000000',27,"[14;5f",'Gabriel Madrigal Bozer 2013012324',27,"[15;5f",'Amit Ferencz Appel 2013385898',0xa; Mensaje RBN-490
len2: equ $-msg2


	
cursorPos: db 27, "[20;15f"	; Posicion de la bola en el inicio = fila ; columna, Esc "[r9,r10 ; r12,r13H"
cursorPosT: equ 8 

msg3: db    27,"[22;15f","porcentaje del micro",27,"[30;15f","*****Presione Enter para terminar****",27,"[?25l",0xa;mensaje RBN-530
len3: equ $-msg3
	
men_Warn: db 'El cpu no puede obtener la info',0xa
mw: equ $-men_Warn

esconde: db 27,"[u"
largo_esconde: equ $-esconde




segment .bss; seccion de varaibles
res resb 255; variable donde se aloja el nombre de la personas tiene un Tamanao de 255 bits
nom1 resb 32
ent resb 1
nombre resb 20
ingreso resb 1
Numero_vidas resb 3
segment .text

bloques:
	escribe borrar,borrarl
	escribe cursorPos0,cursorPost0
	escribe bloqueU,Lbloque
	escribe cursorPos1,cursorPost1
	escribe bloqueU,Lbloque
	escribe cursorPos2,cursorPost2
	escribe bloqueU,Lbloque
	escribe cursorPos3,cursorPost3
	escribe bloqueU,Lbloque
	escribe cursorPos4,cursorPost4
	escribe bloqueU,Lbloque
	escribe cursorPos5,cursorPost5
	escribe bloqueU,Lbloque
	escribe cursorPos6,cursorPost6
	escribe bloqueU,Lbloque
	escribe cursorPos7,cursorPost7
	escribe bloqueU,Lbloque
	escribe cursorPos8,cursorPost8
	escribe bloqueU,Lbloque
	ret
canonical_off:
        call read_stdin_termios

        ; clear canonical bit in local mode flags
        push rax
        mov eax, ICANON
        not eax
        and [termios+12], eax
        pop rax

        call write_stdin_termios
        ret
echo_off:
        call read_stdin_termios

        ; clear echo bit in local mode flags
        push rax
        mov eax, ECHO
        not eax
        and [termios+12], eax
        pop rax

        call write_stdin_termios
        ret
canonical_on:
        call read_stdin_termios

        ; set canonical bit in local mode flags
        or dword [termios+12], ICANON

        call write_stdin_termios
        ret
echo_on:
        call read_stdin_termios

        ; set echo bit in local mode flags
        or dword [termios+12], ECHO

        call write_stdin_termios
        ret
read_stdin_termios:
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, stdin
        mov ecx, 5401h
        mov edx, termios
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
write_stdin_termios:
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, stdin
        mov ecx, 5402h
        mov edx, termios
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret
leetecla:; rutnia de lectrua de teclado
	mov rax, 0; sys_read
	mov rdi, 0; teclado
	mov rdx, 30; tamano
	syscall
	ret; se usa para volver a la rutina
marco:
	;----------------------------------------Ciclo para pintar le borde superior-------------------------
	mov r8, 70;parametro limite del loop
	mov r9, 0;parametro icnial del loop

	escribe lineaHorizontalSup,L_H_S; escriturazbe el primer caracter de la linea horizontal superiror
	Pinta_a:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pinar
	add r9, 1; suma 1 a rdi
	cmp r9,r8; compara rdi con rsi
	jne Pinta_a; salta a pint_arriba si rdi es menos a
	;--------------------------------------------------------------------------------
	;-----------------------------------------ciclo para pintar el borde inferior----	------------------------------
	mov r8, 70;parametro limite del loop
	mov r9, 0;parametro icnial del loop

	escribe lineaHorizontalinf,L_H_I; pinta el primer caracter de la linea horizontal inferior
	Pinta_ab:;etiqueta
	escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pintar la linea
	add r9, 1; suma 1 a rdi
	cmp r9,r8; compara rdi con rsi
	jne Pinta_ab; salta a pinta_abajo si rdi es menos a
	;--------------------------------------------------------------------------------
	;---------------------------------ciclo pra borde izquierdo------------------------------------------
	mov r8, 50;parametro limite del loop
	mov r9, 0;parametro icnial del loop
	escribe lineaVI,largoVI ; pinta el primer caracter de la linea vertical izquierda
	Pinta_izq:;etiqueta
	escribe lineaV,largoV; escribe el resto de la linea
	add r9, 1; suma 1 a rdi
	cmp r9,r8; compara rdi con rsi
	jne Pinta_izq; salta a pinta si rdi es menos a
	;--------------------------------------------------------------------------------
	;---------------------------------ciclo pra borde Drecho------------------------------------------
	mov r8, 50;parametro limite del loop
	mov r9, 0;parametro icnial del loop
	escribe lineaVD,largoVD ; pinta el primer caracter de la linea vertical derecha
	Pinta_d:;etiqueta
		escribe lineaV_D,largoV_D; escribe los caracteres en la linea vertical derecha
		add r9, 1; suma 1 a rdi
		cmp r9,r8; compara rdi con rsi
		jne Pinta_d; salta a pinta si rdi es menos a
	ret
;--------------------------------------------------------------------------------



global _start; inicio
global _salida;


_start:

	escribe borrar, borrarl;-----------------borra la consola--------------------
	call marco
;------------------------------------mensajes de bienvenida---------------------------------------------
	escribe msg1, len1; 

	
;-------------------------------------------------------------------------------------------------------
	mov rsi, nombre;guarda en el registro RCX lo leido del teclado
	call leetecla; llama al procedimiento de leet la tecla
	escribe borrar, borrarl;-----------------borra la consola--------------------

	call canonical_off
	call echo_on

;deteccion de teclass----------------------------------------
call bloques
call marco

escribe jugador,Ljugador
escribe nombre, 10
escribe vidas,lvidas

escribe Bienvenida,L_Bienvenida
escribe esconde,largo_esconde



inicio:
	mov rsi, ingreso
	call leetecla
	cmp dword[ingreso],0x78
	jnz inicio

call canonical_on
call echo_on

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
	

;------------------------------------mensajes de bienvenida---------------------------------------------

escribe msg2, len2

escribe cursorPos, cursorPosT

escribe nom1, 48

escribe msg3, len3

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