;###############################################################################

;El-5413 Lab. de Estructuras de Microprocesadores
;Proyecto 1 - Arkanoid - Barra horizontal

;-------------------------------Descripcion General-----------------------------
;El siguiente codigo imprime en pantalla una barra horizontal como fue
;especificada en el instructivo del primer proyecto. Haciendo uso de una
;interrupcion,la barra se mueve dependiendo de la tecla presionada.

;###############################################################################


;-------------------------------------Macros-----------------------------------

%macro Escribir 2
        mov rax, 1
        mov rdi, 1
        mov rsi, %1
        mov rdx, %2
        syscall
%endmacro


%macro Sumar_Barra 2
        cmp %2, 52      ;54 => ascii decimal para '6'; compara unidades(posicion vs limite);%2 = pos_barra_uni
        jz comp_dec_lim
        jnz comp_uni_tope       ;tope => 9

comp_dec_lim:
        cmp %1, 54              ;50 => ascii decimal para '2'; compara decenas(posicion vs limite);%1 = pos_barra_dec
        jz final_macro_suma	;llego al tope, no hace nada
        jnz suma_1_uni

comp_uni_tope:
        cmp %2, 57              ;57 =>ascii decimal para '9'; compara unidades(posiciones vs tope)
        jz suma_1_dec           ;suma 1 en las decenas(%1) y mueve un '0' (48) a las unidades (%2)
        jnz suma_1_uni

suma_1_uni:
        inc %2
        jmp final_macro_suma

suma_1_dec:
        mov %2, 48
        inc %1
        jmp final_macro_suma

final_macro_suma:
%endmacro


%macro Restar_Barra 2
        cmp %1, 48      	;48 => ascii decimal para '0'; compara decenas(posicion vs tope);%1 = pos_barra_dec
        jz comp_uni_tope_resta       ;pregunta si %1 es igual a '0'
        jnz resta_1_uni         ;resta 1 a %2;%2 = pos_barra_dec

comp_uni_tope_resta:
        cmp %2, 52      ;52 => ascii decimal para '4'; compara decenas(posicion vs tope);%2 = pos_barra_uni
        jz final_macro_resta
        jnz resta_1_uni

resta_1_uni:
        cmp %2, 48
	jz resta_1_dec
	dec %2
        jmp final_macro_resta

resta_1_dec:
        mov %2, 57
        dec %1
        jmp final_macro_resta

final_macro_resta:
%endmacro


%macro Carac2Num 4
        push rax
                                        ;Toma 4 entradas, las primeras 2 son variables donde se guardan
                                        ;los caracteres de unidades y decenas
                                        ;la tercera es la variable donde se guarda el numero, y la 4 es una variable auxiliar
        mov al, %1
        mov %3, al                      ;mueve decenas(%1) a la variable donde se almacena el resultado(%3)
        sub %3, 0x30

        mov al, %2
        mov %4, al                      ;mueve unidades(%2) a la variable auxiliar(%4)
        sub %4, 0x30

        mov al, 0xa
        mul %3
        mov %3, al
        mov al, %4
        add %3, al                      ;en %3 queda el numero final

        pop rax
%endmacro

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


jugador: db 0x1b,"[52;1f ","Jugardor: "
Ljugador: equ $-jugador

vidas: db 0x1b,"[52;30f ","Vidas: "
lvidas: equ $-vidas

lineaHorizontalSup: db 0x1b,"[0;0f "," =";primer caratcter de la linea Horizontal superior
L_H_S: equ $-lineaHorizontalSup

lineaHorizontalinf: db 0x1b,"[51;0f "," ="; primer caracter de la linea horizontal superior
L_H_I: equ $-lineaHorizontalinf

lineaHorizontal: db "="; caracter de las lineas horizontal
L_H: equ $-lineaHorizontal
 
lineaVI: db 0x1b,"[0;0f ",27,"[2D","|",0xa; primer caracter de la linea vertical izquierda
largoVI: equ $-lineaVI

lineaVD: db 27,"[0;71H ","|"; primer carcter de la linea vertical Pinta_derecha
largoVD: equ $-lineaVD

lineaV: db 27,"[2D","|",0xa; caracteres de la linea vertical derecha
largoV: equ $-lineaV

lineaV_D: db 27,"[1B",27,"[1D","|"; caracteres de la linea vertical izquierda
largoV_D: equ $-lineaV_D

Bienvenida: db   0x1b,"[20;5f","---------------------Presione X para continuar---------------------"
L_Bienvenida: equ $-Bienvenida
;--------------------------------------------Contenido del marco------------------------------------------------------------------

msg1 db   27,"[10;5f","EL 4313 Lab. Estructuras de microprosesadores. 2 semestre 2016", 0x1b,"[12;5f","MICRONOID",0x1b,"[14;5f",0x1b,"[5M","Bienvenido", 0x1b,"[14;5f",0x1b,"[5M","Bienvenido",  0x1b,"[16;5f","Cual es su nombre: "
len1 equ $-msg1

;-------------------------------------------------mensajes de pantalla de Bienvenida-----------------------------------------------------------------
borrar: db 27,"[2J", 27,"[u";Mensaje para borrar la consola
borrarl: equ 4; Tamanao

cursorPos7: db 27,'[1;2H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost7: equ $-cursorPos7

cursorPos8: db 27,'[1;25H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost8: equ $-cursorPos8

cursorPos9: db 27,'[1;48H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost9: equ $-cursorPos9

cursorPos4: db 27,'[4;2H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost4: equ $-cursorPos4

cursorPos5: db 27,'[4;25H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost5: equ $-cursorPos5

cursorPos6: db 27,'[4;48H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost6: equ $-cursorPos6

cursorPos1: db 27,'[7;2H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost1: equ $-cursorPos1

cursorPos2: db 27,'[7;25H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost2: equ $-cursorPos2

cursorPos3: db 27,'[7;48H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPost3: equ $-cursorPos3

;----------------------------------------------------constantes de los bloques-------------------------------------------------------------


msg2: db    27,"[7;5f","Gracias por jugar Micronoid",27,"[12;5f",'Daniel Leon Gamboa 2013036468',27,"[13;5f",'Enrique Hernandez 2013000000',27,"[14;5f",'Gabriel Madrigal Bozer 2013012324',27,"[15;5f",'Amit Ferencz Appel 2013385898',0xa; Mensaje RBN-490
len2: equ $-msg2

msg3: db    27,"[22;15f","porcentaje del micro",27,"[30;15f","*****Presione Enter para terminar****",27,"[?25l",0xa;mensaje RBN-530
len3: equ $-msg3

men_Warn: db 'El cpu no puede obtener la info',0xa
mw: equ $-men_Warn

esconde: db 27,"[u"
largo_esconde: equ $-esconde


prueba: db 'z', 0xa
pruebalen: equ $-prueba

Linea1D: equ 48 ;1 -- 0
Linea1U: equ 48 ;0

Linea2D: equ 48 ;0
Linea2U: equ 55 ;7

Linea3D: equ 48 ;0
Linea3U: equ 52 ;4

Linea4D: equ 48 ;0
Linea4U: equ 50 ;2

Colum1D: equ 50 ;2
Colum1U: equ 52 ;4

Colum2D: equ 52 ;4
Colum2U: equ 55 ;7

brick1: equ 49  ; 1
brick2: equ 49  ; 1
brick3: equ 49  ; 1

borraPan: db 27,'[2J'				; borramos la pantalla y
borraPanT: equ 4					; tamanno de la variable anterior

SinCursor: db 27,'[?25l'		 	; me elimina el parpadeo del cursos en la consola
SinCursorT: equ 6					; tamanno de la variable anterior

bola: db 'O'						; dibujo de la bola
bolaT: equ $-bola					; tamanno de la variable de la bola

borrarBola: db ' '					; vacio para caerle encima a la bola y borrarla
borrarBolaT: equ $-borrarBola		; tamanno de la variable de la bola

cursorPos: db 27,'[30;42H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPosT: equ 8

		;------------- LIMITES DE LA PANTALLA DONDE LA BOLA REBOTA------

RightU: equ 48							; todos los valores en Ascii
RightD: equ 55		;----------------------------------------------;
LeftU: equ 50		;0,2									   0,52;
LeftD: equ 48		;											   ; 
			 		;											   ;
DownU: equ 48		;											   ;
DownD: equ 53		;											   ;
UpU: equ 48			;73,2									 73,52 ;
UpD: equ 48			;----------------------------------------------;


bloqueU: db "+---------------------+", 27,'[23D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------------------+", 27,'[1A',27,'[1D',"|"
Lbloque: equ $-bloqueU

borraBloque: db "                       ", 27,'[23D', 27,'[1B'," ",27,'[1B',27,'[1D',"                       ", 27,'[1A',27,'[1D'," "
LborraBloque: equ $-borraBloque


barra_horiz_pos: db 27,"[32;10f ","------"			;se debe dejar el '-----'
barra_horiz_pos_tam: equ $-barra_horiz_pos

barra_horiz: db "o======o"
barra_horiz_tam: equ $-barra_horiz




segment .bss; seccion de varaibles
res: resb 255; variable donde se aloja el nombre de la personas tiene un Tamanao de 255 bits
nom1: resb 32
ent: resb 1
nombre: resb 20
ingreso: resb 1

Numero_vidas: resb 3
b1: resb 1
b2: resb 1
b3: resb 1
b4: resb 1
b5: resb 1
b6: resb 1
b7: resb 1
b8: resb 1
b9: resb 1

dato_ent: resb 1
pos_barra_uni: resb 1
pos_barra_dec: resb 1
pos_barra: resb 1
salida: resb 1
barra_f: resb 1
altura_barra_dec: resb 1
altura_barra_uni: resb 1
altura_barra: resb 1
altura_bola_dec: resb 1
altura_bola_uni: resb 1
altura_bola: resb 1
pos_bola_dec: resb 1
pos_bola_uni: resb 1
pos_bola: resb 1
aux: resb 1
;---------------------------------------------------------------------

segment .text

Proc_GetKey:				;Subrutina para obtener el codigo de la
					;tecla presionada (si se presiono alguna)
	;Escribir cons_banner, cons_tam_banner
	mov rax, 0				;rax = "sys_read"
	mov rdi, 0				;rdi = 0 (standard input = teclado)
	mov rsi, dato_ent			;rsi = dir de memoria donde se guarda el dato de entrada
	mov rdx, 1				;rdx = 1 =>  cuantos eventos o teclazos capturar
	syscall
ret					;Final del procedimiento 'Proc_GetKey'
;-----------------------------------------------------

Proc_DecoKey:				;Procedimiento para determinar que tecla se obtuvo
					;se debe ejecutar inmediatamente despues de Proc_GetKey si se obtuvo el valor de una tecla
	cmp byte [dato_ent], 99
	jz tecla_c			;se mueve hacia la izquierda

	cmp byte [dato_ent], 122
	jz tecla_z			;se mueve hacia la derecha

	cmp byte [dato_ent], 32			;sale del ciclo '_ciclo_juego';32 => space
	jz tecla_space

	jnz Continue

tecla_c:
	Sumar_Barra byte [pos_barra_dec], byte [pos_barra_uni]
	jmp Continue

tecla_z:
	Restar_Barra byte [pos_barra_dec], byte [pos_barra_uni]
	jmp Continue

tecla_space:
	;25 se escogio al azar, cuando [salida] tenga este valor se sale del juego
	mov byte [salida], 25
	jmp Continue

Continue:
ret
;-------------------------------------------------------

Proc_ImprimeBarra:			;Procedimiento para imprimir la barra movil
					;llama al macro Escribir luego de modificar los valores del string 'barra_horiz_pos'
	push r15
	mov r15, [pos_barra_dec]
	mov [barra_horiz_pos + 0x5], r15

	mov r15, [pos_barra_uni]
	mov [barra_horiz_pos + 0x6], r15

	mov r15, [barra_f]
	mov [barra_horiz_pos + 0x7], r15
	pop r15

	Escribir barra_horiz_pos, barra_horiz_pos_tam
	Escribir barra_horiz, barra_horiz_tam
	;Escribir final_marco, final_marco_tam
ret
;-------------------------------------------------------

Proc_ComparaPosicion:
	;Procedimiento usado para comparar la posicion de la bola con respecto a la barra

	push rax

	mov rax, r10
	mov byte [altura_bola_dec], al

	mov rax, r9
	mov byte [altura_bola_uni], al

	mov rax, r13
	mov byte [pos_bola_dec], al

	mov rax, r12
	mov byte [pos_bola_uni], al

	pop rax

	push r9				;almacenar en el stack los valores actuales de r9,r10,r12,r13,r14
	push r10			;r9 = altura_barra + 1 , r10 = altura_bola
	push r12			;r12 = pos_barra, r13 = pos_bola
	push r13

	Carac2Num byte [altura_barra_dec], byte [altura_barra_uni], byte [altura_barra], byte [aux]
	movzx r9, byte [altura_barra]
	add r9, 1

        Carac2Num byte [altura_bola_dec], byte [altura_bola_uni], byte [altura_bola], byte [aux]
	movzx r10, byte [altura_bola]

        Carac2Num byte [pos_barra_dec], byte [pos_barra_uni], byte [pos_barra], byte [aux]
	movzx r12, byte [pos_barra]

        Carac2Num byte [pos_bola_dec], byte [pos_bola_uni], byte [pos_bola], byte [aux]
	movzx r13, byte [pos_bola]

	cmp r9, r10
	jz cmp_pos_ini				;posicion del inicio de la barra
	jnz Salir_ComparaPosicion

cmp_pos_ini:
	cmp r12, r13
	jbe cmp_pos_fin				;posicion del final de la barra
	ja pierde_vida

cmp_pos_fin:
	add r12, 8
	cmp r12, r13
	jae rebote
	jb pierde_vida

rebote:
	call cambioDirUp			;revisar el nombre de la funcion que se debe llamar
						;para implementar el rebote de la bola
	jmp Salir_ComparaPosicion

pierde_vida:
	;decidir que hacer al perder una vida
	jmp Salir_ComparaPosicion

Salir_ComparaPosicion:
	pop r13
	pop r12
	pop r10
	pop r9
ret

;--------------------------------------------------------

bloques:
	escribe borrar,borrarl
	escribe cursorPos9,cursorPost9
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
	mov byte [termios + 23], 0
	mov byte [termios + 24], 0
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

	;escribe lineaHorizontalSup,L_H_S; escriturazbe el primer caracter de la linea horizontal superiror
	Pinta_a:;etiqueta
	;escribe lineaHorizontal,L_H; llama a la funcion escribe para pintar un = para terminar de pinar
	add r9, 1; suma 1 a rdi
	cmp r9,r8; compara rdi con rsi
	jne Pinta_a; salta a pint_arriba si rdi es menos a
	;--------------------------------------------------------------------------------
	;-----------------------------------------ciclo para pintar el borde inferior----	------------------------------
	mov r8, 69;parametro limite del loop
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
mov byte [b1],0x31
mov byte [b2],0x31
mov byte [b3],0x31
mov byte [b4],0x31
mov byte [b5],0x31
mov byte [b6],0x31
mov byte [b7],0x31
mov byte [b8],0x31
mov byte [b9],0x31

mov byte [salida], 5

mov byte [pos_barra_dec], 49

mov byte [pos_barra_uni], 49

mov byte [barra_f], 102

mov byte [altura_barra_dec], 0x33

mov byte [altura_barra_uni], 0x32

escribe borrar, borrarl;-----------------borra la consola--------------------
call marco
;------------------------------------Pantalla 1---------------------------------------------
escribe msg1, len1;

;-------------------------------------------------------------------------------------------------------
mov rsi, nombre;guarda en el registro RCX lo leido del teclado
call leetecla; llama al procedimiento de leet la tecla
escribe borrar, borrarl;-----------------borra la consola--------------------

;*******************************************Pantalla 2******************************************************************
call canonical_off
call echo_off

;deteccion de teclass----------------------------------------
call bloques
call marco
call Proc_ImprimeBarra

escribe jugador,Ljugador
escribe nombre, 10
mov dword[vidas],0x3

escribe vidas,lvidas

escribe Bienvenida,L_Bienvenida
escribe esconde,largo_esconde

;-----------------BOLA SIN MOVER PARA INICIO DE JUEGO-------------

	mov r10, 0x34		; valores iniciales para imprimir la bola
	mov r9, 0x38		; linea 30
	mov r13, 0x33			; columna 42
	mov r12, 0x39

	mov r15,59 					    ; caracter " ; " ascii
	mov [cursorPos + 0x2],r10 	    ; decena de la coodenada n
	mov [cursorPos + 0x3],r9		; unidad de la coodenada n
	mov [cursorPos + 0x4],r15		; 
	mov [cursorPos + 0x5],r13		; decena de la coodenada m
	mov [cursorPos + 0x6],r12		; unidad de la coodenada m

	mov r15,72						; caracter H final del string CursorPos
	mov [cursorPos + 0x7],r15       ; lo muevo
	escribe SinCursor,SinCursorT
	escribe cursorPos,cursorPosT
	escribe bola,bolaT


;-----------------FIN DE BOLA SIN MOVER PARA INICIO-------------- 

inicio:
	mov rsi, ingreso
	call leetecla
	cmp dword[ingreso],0x78
	jnz inicio

	escribe SinCursor,SinCursorT
	;call canonical_on
	;call echo_on

;-------------------SE DERTERMINA LOS VALORES INICIALES DE LA POSICION DE LA BOLA






;--------------------EMPIEZA ALGORITMO DE LA BOLA-----------

;----------------quitamos el cursor o el pardeo del mismo-------------

	;escribe SinCursor,SinCursorT

;-------------------SE DERTERMINA LOS VALORES INICIALES DE LA POSICION DE LA BOLA

	mov r10, 51			; valores iniciales para imprimir la bola
	mov r9, 57			; linea 30
	mov r13, 0x33			; columna 42
	mov r12, 0x39

;---------------- SE DEFINEN REGISTROS PARA LA DIRECCION DE LA BOLA

	mov r8,0				; 0 derecha 1 izquierda
	mov r14,1				; 0 abajo 1 arriba

;------------SE EMPIEZA EL MOVIMIENDO DE LA BOLA

movimiento:
;-----antes de mover la bola tenemos que definir su direccion

	call direccion ;ver seccion de direccion

;-----     fila(n) ; columna(m) --->> cusorPos Esc "[r10,r9 ; r13,r12H"
; Se le asignan los valores iniciales(y los que le siguen) de la posicion de la bola a su variable, estos valores
; van cambiando con el tiempo, en cada ciclo es diferente


	mov r15,59 					    ; caracter " ; " ascii
	mov [cursorPos + 0x2],r10 	    ; decena de la coodenada n
	mov [cursorPos + 0x3],r9		; unidad de la coodenada n
	mov [cursorPos + 0x4],r15		;
	mov [cursorPos + 0x5],r13		; decena de la coodenada m
	mov [cursorPos + 0x6],r12		; unidad de la coodenada m

	mov r15,72						; caracter H final del string CursorPos
	mov [cursorPos + 0x7],r15		; lo muevo

;------Se mueve el cursor a las coordenadas asignadas en el segmento anterior

	escribe cursorPos,cursorPosT

;-----una ves en la posicion deseada imprime la bola


	escribe bola,bolaT
	mov rcx, 0xfffffe 	; la velocidad de la bola en el juego

;!!!!NOTA!!!!: si se quisiera poner la dificulta en el juego cambiar la velocidad es una buena opcion 

;--------empieza el ciclo para un movimiento "perpetuo" o constante de la bola

cicloFor:
	loop cicloFor

;---------una ves que se imprime la bola se tiene que borrar, entonces lo que se hace en imprimir un "  " encima


	escribe cursorPos,cursorPosT

	escribe borrarBola,borrarBolaT


        ;Seccion para tomar la tecla presionada en el teclado
        call Proc_GetKey

        ;Comparar para saber si se debe hacer una decodificacion de la tecla
        ;o si se debe seguir con el programa
        call Proc_DecoKey

        ;Escribir la barra horizontal con los parametros modificados
        call Proc_ImprimeBarra

        call cmpBolaBloque1
        call Proc_ComparaPosicion
        mov byte [dato_ent], 0

	jmp movimiento							; vuelvo a cambiar las posiciones




;-----------------------TERMINA LA BOLA -------------------------------------------







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





;---------SE DEFINE A DONDE VA LA BOLA

	direccion:
		call horizontal ;movimiento de derecha a izquierda y viceversa 
		call vertical   ;movimiento de abajo a arriba y viceversa
		ret

		horizontal:
			cmp r8,0						; para saber en que direccion r8 - 0 (la comparacion es una resta en el fondo)
			je derecha						; Y si es igual a 0 la bola va a la derecha 
			jmp izquierda					; salto sin condicion, porque si no se cumple el anterior si o si se da este salto

		derecha:
			cmp r13,RightD					; comparo el limite derecho de las Decenas a ver si coinside
			je derecha1						; si son iguales tengo que comparar las Unidades del limite para tomar la desicion de direccion
			call aumentoX					; Si aun no esta cerca del limite solo aumenta el eje X
			ret
		derecha1:
			cmp r12,RightU					; comparo las unidades del limite derecho
			je cambioDirI					; si son iguales tengo que cambiar a Izquierda la direccion
			call aumentoX					; de lo contrario solo aumento el eje X
			ret

		cambioDirI:
			mov r8,1						; cambio el r8 a un 1 que significa ir a la izq
			call decrementox				; tengo que decrementar el X a la izquierda por que no puedo ir
			ret								; mas a la derecha ya que estoy en el "limite"

		izquierda:							; el r8 es = a 1
			cmp r13,LeftD					; comparo limite izq Decimal
			je izquierdaI					; para ir a comparar las unidades del limite si las decenas son iguales
			call decrementox				; si no son iguales solo me muevo a la izq	
			ret

		izquierdaI:
			cmp r12,LeftU					; comparo el limite izq unidades
			je cambioDirD					; si estoy en el limite tengo que ir hacia la derecha
			call decrementox				; si no estoy en el limite solo me muevo a la izq
			ret

		cambioDirD:
			mov r8,0						; cambio el r8 a 0 que es derecha
			call aumentoX					; voy para la derecha entonces incremento el X
			ret

		vertical:							; funciona parecido que el eje X pero con el eje Y
			cmp r14,0
			je abajo
			jmp arriba

		abajo:
			cmp r10,DownD
			je abajoI
			call aumentoY
			ret
		abajoI:
			cmp r9,DownU
			je cambioDirUp
			call aumentoY
			ret

		cambioDirUp:
			mov r14,1
			call decrementoY
			ret

		arriba:
			cmp r10,UpD
			je arribaI
			call decrementoY
			ret

		arribaI:
			cmp r9,UpU
			je cambioDirDown
			call decrementoY
			ret

		cambioDirDown:
			mov r14,0
			call aumentoY
			ret

		aumentoY:
			add r9,1
			cmp r9,58
			jne retorno
			call setZero
		retorno:
			ret

		setZero:
			inc r10
			cmp r10,58
			jne resetZero
			call setZero1
		resetZero:
			mov r9,48
			ret

		setZero1:
			mov  r10,48
			ret

		decrementoY:
			dec r9
			cmp r9,47
			jne retorno1
			call setMax
		retorno1:
			ret

		setMax:
			dec r10
			cmp r10,47
			jne setNine
			call setNine1
		setNine:
			mov r9,57
			ret

		setNine1:
			mov  r10,57
			ret

		aumentoX:
			inc r12
			cmp r12,58
			jne retorno2
			call setZero2
		retorno2:
			ret

		setZero2:
			inc r13
			cmp r13,58
			jne setZero5
			call setZero3

		setZero5:
			mov r12,48
			ret

		setZero3:
			mov  r13,48
			ret

		decrementox:
			dec r12
			cmp r12,47
			jne retorno3
			call setZero4
		retorno3:
			ret

		setZero4:
			dec r13
			cmp r13,47
			jne setNine2
			call setNine3
		setNine2:
			mov r12,57
			ret

		setNine3:
			mov  r13,57
			ret



	
;---------------------ALGORITMO DE COMPARACION DE BOLA---------

;-----------seccion de los bloques, altura 
cmpBolaBloque1:

	X_D:
	
		cmp r10,0x30
		je X_U
		jne X_D2
		
	X_U:
		
		cmp r9,0x39
		je Y_D
		cmp r9,0x36
		je Y_DD
		cmp r9,0x33
		je Y_DDD
		
			
	X_D2:
		ret
	;------------------------primera fila------------------------	
	Y_D:
		
		
		cmp r13, '2'
		jbe Y_U
		cmp r13,'4'
		jae Y_U1
		cmp r13,'4'
		jbe Y_U1
		ret
		
	Y_U:
		
		cmp r12, '4' 
		jbe borrarBloque1
		ret

	Y_U1:

		cmp r12, '8' 
		jbe borrarBloque2
		jmp borrarBloque3
		ret 
;------------------------segunda fila--------------------
Y_DD:
		
		
		cmp r13,'2'
		jbe Y_UU
		cmp r13,'4'
		jbe Y_UU1
		cmp r13,'4'
		jae Y_UU1
		ret

	
	Y_UU:
		
		cmp r12, '4' 
		jbe borrarBloque4
		ret

	Y_UU1:

		cmp r12, '8' 
		jbe borrarBloque5
		jmp borrarBloque6
		ret 
;---------------------tercera fila-----------------------
Y_DDD:
		
		
		cmp r13, '2'
		jbe Y_UUU
		cmp r13,'4'
		jbe Y_UUU1
		cmp r13,'4'
		jae Y_UUU1
		ret
		
	Y_UUU:
		
		cmp r12, '4' 
		jbe borrarBloque7
		ret

	Y_UUU1:

		cmp r12, '8' 
		jbe borrarBloque8
		jmp borrarBloque9
		ret 
;------------llamado de borrar los bloques----------------------
	
	borrarBloque1:
		cmp byte[b1],0x31
		jne s1
		escribe cursorPos1,cursorPost1
		escribe borraBloque,LborraBloque
		mov byte [b1],0x30
		call cambioDirDown
		s1:
		ret ;sumamente IMPORTANTE

	borrarBloque2:
		cmp byte[b2],0x31
		jne s2
		escribe cursorPos2,cursorPost2
		escribe borraBloque,LborraBloque
		mov byte [b2],0x30
		call cambioDirDown
		s2:
		ret ;sumamente IMPORTANTE

	borrarBloque3:
		cmp byte[b3],0x31
		jne s3
		escribe cursorPos3,cursorPost3
		escribe borraBloque,LborraBloque
		mov byte [b3],0x30
		call cambioDirDown
		s3:
		ret ;sumamente IMPORTANTE

	borrarBloque4:
		cmp byte[b4],0x31
		jne s4
		escribe cursorPos4,cursorPost4
		escribe borraBloque,LborraBloque
		mov byte [b4],0x30
		call cambioDirDown
		s4:
		ret ;sumamente IMPORTANTE

	borrarBloque5:
		cmp byte[b5],0x31
		jne s5
		escribe cursorPos5,cursorPost5
		escribe borraBloque,LborraBloque
		mov byte [b5],0x30
		call cambioDirDown
		s5:
		ret ;sumamente IMPORTANTE

	borrarBloque6:
		cmp byte[b6],0x31
		jne s6
		escribe cursorPos6,cursorPost6
		escribe borraBloque,LborraBloque
		mov byte [b6],0x30
		call cambioDirDown
		s6:
		ret ;sumamente IMPORTANTE


	borrarBloque7:
		cmp byte[b7],0x31
		jne s7
		escribe cursorPos7,cursorPost7
		escribe borraBloque,LborraBloque
		mov byte [b7],0x30
		call cambioDirDown
		s7:
		ret ;sumamente IMPORTANTE

	borrarBloque8:
		cmp byte[b8],0x31
		jne s8
		escribe cursorPos8,cursorPost8
		escribe borraBloque,LborraBloque
		mov byte [b8],0x30
		call cambioDirDown
		s8:
		ret ;sumamente IMPORTANTE

	borrarBloque9:
		cmp byte[b9],0x31
		jne s9
		escribe cursorPos9,cursorPost9
		escribe borraBloque,LborraBloque
		mov byte [b9],0x30
		call cambioDirDown
		s9:
		ret ;sumamente IMPORTANTE
