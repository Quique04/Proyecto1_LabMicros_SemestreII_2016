;-----------------------------------Seccion de Macros---------------------------------

%macro Carac2Num_Registros 4
        push rax
		mov rax, 0
                                        ;Toma 4 entradas, las primeras 2 son registros donde se guardan
                                        ;los caracteres de unidades y decenas
                                        ;la tercera es el registro donde se guarda el numero, y la 4 es una variable auxiliar
        mov %3, %1                      ;mueve decenas(%1) a la variable donde se almacena el resultado(%3)
        sub %3, 0x30

        mov %4, %2                      ;mueve unidades(%2) a la variable auxiliar(%4)
        sub %4, 0x30

        mov rax, 0xa
        mul %3
        mov %3, rax
        add %3, %4                      ;en %3 queda el numero final

        pop rax
%endmacro

%macro Carac2Num 4
        push rax
                                        ;Toma 4 entradas, las primeras 2 son variables donde se guardan
                                        ;los caracteres de unidades y decenas
                                        ;la tercera es la variable donde se guarda el numero, y la 4 es una variable auxiliar
        mov rax, %1
        mov %3, rax                      ;mueve decenas(%1) a la variable donde se almacena el resultado(%3)
        sub %3, 0x30

        mov rax, %2
        mov %4, rax                      ;mueve unidades(%2) a la variable auxiliar(%4)
        sub %4, 0x30

        mov rax, 0xa
        mul %3
        mov %3, rax
        mov rax, %4
        add %3, rax                      ;en %3 queda el numero final

        pop rax
%endmacro

;-------------------------------------------------------------------------------------
%macro escribe 2;----------------macro para proseso de escritura
mov rax, 1; sys_write
mov rdi, 1; consala_predeterminda
mov rsi, %1; parametro 1
mov rdx, %2; parametro 2
syscall; syscall
%endmacro

;-------------------------------------------------------------------------------------

%macro salir 0
 mov rax, 60
 mov rdi,0
 syscall
%endmacro

;-------------------------------------------------------------------------------------

%macro Sumar_Barra 2
        cmp %2, 56      ;56 => ascii decimal para '8'; compara unidades(posicion vs limite);%2 = pos_barra_uni
        jz comp_dec_lim
        jnz comp_uni_tope       ;tope => 9

comp_dec_lim:
        cmp %1, 50              ;50 => ascii decimal para '2'; compara decenas(posicion vs limite);%1 = pos_barra_dec
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

;-------------------------------------------------------------------------------------

%macro Restar_Barra 2
        cmp %1, 48      	;48 => ascii decimal para '0'; compara decenas(posicion vs tope);%1 = pos_barra_dec
        jz comp_uni_tope_resta       ;pregunta si %1 es igual a '0'
        jnz resta_1_uni         ;resta 1 a %2;%2 = pos_barra_dec

comp_uni_tope_resta:
        cmp %2, 50      ;50 => ascii decimal para '2'; compara decenas(posicion vs tope);%2 = pos_barra_uni
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


;---------------------------Segmento de Variables y Constantes------------------------
segment .data
termios:        times 36 db 0
stdin:          equ 0
ICANON:         equ 1<<1
ECHO:           equ 1<<3

perdio: db 27,'[30;47m',0x1b,"[20;3f","Perdio mejor suerte la proxima vez ",0x1b,"[21;3f"," presione Enter para continuar"
Lperdio: equ $-perdio

gano:db  0x1b,"[20;3f", 0x1b,"[49;39m"," FELICIADES HA GANADO!!!!"
ganoL equ $-gano

perdioV: db 0x1b,"[20;3f","Intentolo de nuevo",0x1b,"[21;3f"," presione Enter para continuar"
LV: equ $-perdioV

jugador: db 0x1b,"[34;1f ","Jugador: "
Ljugador: equ $-jugador

vidas: db 0x1b,"[35;1f ","Vidas: "
lvidas: equ $-vidas

life: db 0x1b,"[20;3f","Ingrese número de vidas: "
lifeL: equ $-life

bola: db 'O'						; dibujo de la bola
bolaT: equ $-bola	

borraPan: db 27,'[2J'                ; borramos la pantalla y
borraPanT: equ 4                    ; tamaño de la variable anterior

SinCursor: db 27,'[?25l'             ; me elimina el parpadeo del cursos en la consola
SinCursorT: equ 6                    ; tamaño de la variable anterior

lineaHorizontalSup: db 0x1b,"[0;0f ","=================================";primer caracter de la linea Horizontal superior
L_H_S: equ $-lineaHorizontalSup

lineaHorizontalInf: db 0x1b,"[33;0f ","=================================";primer caracter de la linea Horizontal inferior
L_H_I: equ $-lineaHorizontalInf

LIzq: db 0x1b, "[2;0f","|",27,"[3;0f","|",27,"[4;0f","|",27,"[5;0f","|",27,"[6;0f","|",27,"[7;0f","|",27,"[8;0f","|",27,"[9;0f","|",27,"[10;0f","|",27,"[11;0f","|",27,"[12;0f","|",27,"[13;0f","|",27,"[14;0f","|",27,"[15;0f","|",27,"[16;0f","|",27,"[17;0f","|",27,"[18;0f","|",27,"[19;0f","|",27,"[20;0f","|",27,"[21;0f","|",27,"[22;0f","|",27,"[23;0f","|",27,"[24;0f","|",27,"[25;0f","|",27,"[26;0f","|",27,"[27;0f","|",27,"[28;0f","|",27,"[29;0f","|",27,"[30;0f","|",27,"[31;0f","|",27,"[32;0f","|"
LIzql: equ $-LIzq

LDer: db 0x1b, "[2;35f","|",27,"[3;35f","|",27,"[4;35f","|",27,"[5;35f","|",27,"[6;35f","|",27,"[7;35f","|",27,"[8;35f","|",27,"[9;35f","|",27,"[10;35f","|",27,"[11;35f","|",27,"[12;35f","|",27,"[13;35f","|",27,"[14;35f","|",27,"[15;35f","|",27,"[16;35f","|",27,"[17;35f","|",27,"[18;35f","|",27,"[19;35f","|",27,"[20;35f","|",27,"[21;35f","|",27,"[22;35f","|",27,"[23;35f","|",27,"[24;35f","|",27,"[25;35f","|",27,"[26;35f","|",27,"[27;35f","|",27,"[28;35f","|",27,"[29;35f","|",27,"[30;35f","|",27,"[31;35f","|",27,"[32;35f","|"
LDerl: equ $-LDer

msg1 db   27,"[8;3f","EL 4313 Lab. Estructuras ",27,"[9;3f", "de Microprocesadores",27,"[10;3f","II semestre 2016", 0x1b,"[14;3f","MICRONOID",0x1b,"[17;3f","Bienvenido",  0x1b,"[20;3f","Cual es su nombre: "
len1 equ $-msg1

Bienvenida: db   0x1b,"[10;5f","-----Presione Enter para continuar-----"
L_Bienvenida: equ $-Bienvenida

borrarBola: db '  '					; vacio para caerle encima a la bola y borrarla
borrarBolaT: equ $-borrarBola		; tamanno de la variable de la bola

borrar: db 27,"[2J";Mensaje para borrar la consola
borrarl: equ 4; Tamanao

cursorPos: db 27,'[30;17H'  		; Posicion de la bola en el inicio = fila ; columna,
cursorPosT: equ 8

poscontrol: db 27,'[2;2f'," "
poscontrolT: equ $-poscontrol

bloqueU1 db 27,'[1;2f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque1: equ $-bloqueU1

POSI7: db 27, "[1;2H"
PosiL7: equ $-POSI7

bloqueU2 db 27,'[1;13f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque2: equ $-bloqueU2

POSI8: db 27, "[1;13H"
PosiL8: equ $-POSI8

bloqueU3 db 27,'[1;24f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque3: equ $-bloqueU3

POSI9: db 27, "[1;24H"
PosiL9: equ $-POSI9

bloqueU4 db 27,'[4;2f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque4: equ $-bloqueU4

POSI4: db 27, "[4;2H"
PosiL4: equ $-POSI4

bloqueU5 db 27,'[4;13f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque5: equ $-bloqueU5

POSI5: db 27, "[4;13H"
PosiL5: equ $-POSI5

bloqueU6 db 27,'[4;24f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque6: equ $-bloqueU6

POSI6: db 27, "[4;24H"
PosiL6: equ $-POSI6

bloqueU7 db 27,'[7;2f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque7: equ $-bloqueU7

POSI1: db 27, "[7;2H"
PosiL1: equ $-POSI1

bloqueU8 db 27,'[7;13f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque8: equ $-bloqueU8

POSI2: db 27, "[7;13H"
PosiL2: equ $-POSI2

bloqueU9 db 27,'[7;24f',"+---------+", 27,'[11D', 27,'[1B',"|",27,'[1B',27,'[1D',"+---------+", 27,'[1A',27,'[1D',"|"
Lbloque9: equ $-bloqueU9

POSI3: db 27, "[7;24H"
PosiL3: equ $-POSI3

msg2: db   27,"[0m",27,"[7;5f","Gracias por jugar Micronoid",27,"[12;5f",'Daniel Leon Gamboa 2013036468',27,"[13;5f",'Enrique Hernandez 2013000000',27,"[14;5f",'Gabriel Madrigal Bozer 2013012324',27,"[15;5f",'Amit Ferencz Appel 2013385898',0xa; Mensaje RBN-490
len2: equ $-msg2

msg3: db   27,"[30;5f","*****Presione Enter para terminar****",27,"[?25l",0xa;mensaje RBN-530
len3: equ $-msg3
	
men_Warn: db 'El cpu no puede obtener la info',0xa
mw: equ $-men_Warn

esconde: db 27,"[u"
largo_esconde: equ $-esconde



;-----------------CARACTER DEL BORRADO DE BLOQUE----------------


borraBloque: db "           ", 27,'[11D', 27,'[1B'," ",27,'[1B',27,'[1D',"           ", 27,'[1A',27,'[1D'," "
LborraBloque: equ $-borraBloque



;--------------------------------------------------------------------------------------------------------
barra_horiz_pos: db 27,"[30;30f"   ,"-------"			;se debe dejar el '-----'
barra_horiz_pos_tam: equ $-barra_horiz_pos

barra_horiz: db "o=====o"
barra_horiz_tam: equ $-barra_horiz

borrar_barra: db 27,'[30;2H','                                 '
borrar_barra_tam: equ $-borrar_barra

debug: db "AQUI_ESTOY"
debugL: equ $-debug

;------------- LIMITES DE LA PANTALLA DONDE LA BOLA REBOTA------

RightU: equ 51                         ; todos los valores en Ascii
RightD: equ 51       ;-----------------------------------------------;
LeftU: equ 50        ;01,2                                       0,37;
LeftD: equ 48        ;                                               ;
                     ;                                               ;
DownU: equ 50        ;                                               ;
DownD: equ 51        ;                                               ;
UpU: equ 50          ;73,2                                      73,52;
UpD: equ 48          ;-----------------------------------------------;


;-------------------------------------------------------------------------------------

segment .bss; seccion de varaibles
res resb 255; variable donde se aloja el nombre de la personas tiene un Tamanao de 255 bits
nom1 resb 32
ent resb 1
nombre resb 10
ingreso resb 1


dato_ent: resb 1
pos_barra_uni: resb 1
pos_barra_dec: resb 1
pos_barra: resb 8
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
aux: resb 8
contador: resb 1


vidas_jugador: resb 1
b1: resb 1
b2: resb 1
b3: resb 1
b4: resb 1
b5: resb 1
b6: resb 1
b7: resb 1
b8: resb 1
b9: resb 1
control: resb 1
amit: resb 1

;--------------------------------Segmento de Codigo-----------------------------------

;-----------------------Etiquetas Globales-------------------------
segment .text

	global _start
	global _pausa1
	global _pausa2
	global _pausa3

;-----------------------Procedimientos-------------------------


;----------------Configuracion de la Consola-------------------
canonical_off:
        call read_stdin_termios

        ; clear canonical bit in local mode flags
        push rax
        mov eax, ICANON
        not eax
        and [termios+12], eax
        mov byte[termios+23],0
        mov byte [termios+24],0
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

;----------------Lectura del teclado-------------------

Proc_GetKey:				;Subrutina para obtener el codigo de la
	mov byte[dato_ent],0				;tecla presionada (si se presiono alguna)
	mov rax, 0				;rax = "sys_read"
	mov rdi, 0				;rdi = 0 (standard input = teclado)
	mov rsi, dato_ent			;rsi = dir de memoria donde se guarda el dato de entrada
	mov rdx, 1				;rdx = 1 =>  cuantos eventos o teclazos capturar
	syscall
ret					;Final del procedimiento 'Proc_GetKey'

;-----------Decodificacion de las teclas---------------

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
	escribe borrar_barra, borrar_barra_tam
	jmp Continue

tecla_z:
	Restar_Barra byte [pos_barra_dec], byte [pos_barra_uni]
	escribe borrar_barra, borrar_barra_tam
	jmp Continue

tecla_space:
	;25 se escogio al azar, cuando [salida] tenga este valor se sale del juego
	mov byte [salida], 25
	jmp Continue

Continue:
ret

;----------------Imprimir la Barra-------------------

Proc_ImprimeBarra:			;Procedimiento para imprimir la barra movil
					;llama al macro Escribir luego de modificar los valores del string 'barra_horiz_pos'	

	push r15
	
	mov r15, 0x33
	mov [barra_horiz_pos + 0x2], r15

	mov r15, 0x30
	mov [barra_horiz_pos + 0x3], r15
	
	mov r15, 59
	mov [barra_horiz_pos + 0x4], r15

	mov r15, [pos_barra_dec]
	mov [barra_horiz_pos + 0x5], r15

	mov r15, [pos_barra_uni]
	mov [barra_horiz_pos + 0x6], r15

	mov r15, [barra_f]
	mov [barra_horiz_pos + 0x7], r15
	
	pop r15

	escribe barra_horiz_pos, barra_horiz_pos_tam
	escribe barra_horiz, barra_horiz_tam
ret



;-----------Ciclo de movimiento de la barra--------------

ciclo_barra:

	;call Proc_ImprimeBarra

	;Seccion para tomar la tecla presionada en el teclado
	call Proc_GetKey

	;Comparar para saber si se debe hacer una decodificacion de la tecla
	;o si se debe seguir con el programa
	call Proc_DecoKey
	
	call Proc_ImprimeBarra

ret

;------------Pantalla Para Iniciar el Juego---------------

Play:
    	escribe Bienvenida,L_Bienvenida
	call canonical_off
    	call echo_off
    	mov dword[ingreso],0
    	mov rsi, ingreso
    	call leetecla
    	cmp dword[ingreso],0x78
    	jnz Play
    	call canonical_on
    	call echo_on
ret

;------------Procedimiento para leer teclado---------------

leetecla:; rutina de lectura de teclado
    mov rax, 0; sys_read
    mov rdi, 0; teclado
    mov rdx, 30; tamaño
    syscall
    ret; se usa para volver a la rutina

;---------Procedimiento para pintar el marco------------

marco:
	escribe lineaHorizontalSup, L_H_S
	escribe lineaHorizontalInf, L_H_I
	escribe LIzq,LIzql
	escribe LDer,LDerl
	
ret
;--------Pide X----------------------------------------

;--------Procedimiento para pantalla inicial-----------

Inicio: 

	call marco
	escribe msg1,len1
	mov rsi, nombre     ; guarda en el registro RCX lo leido del teclado
    	call leetecla       ; llama al procedimiento de leer la tecla
    	escribe life,lifeL  ; escribe la cantidad de vidas
    	mov rsi, amit
    	call leetecla;
	ret

;---------Procedimiento para pintar los bloques----------


bloques:
   escribe poscontrol,poscontrolT
   escribe bloqueU1,Lbloque1
   escribe bloqueU2,Lbloque2
   escribe bloqueU3,Lbloque3
   escribe bloqueU4,Lbloque4
   escribe bloqueU5,Lbloque5
   escribe bloqueU6,Lbloque6
   escribe bloqueU7,Lbloque7
   escribe bloqueU8,Lbloque8
   escribe bloqueU9,Lbloque9
ret


;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;--------------------------------------------Procedimiento para mover la bola--------------------------------------

movimiento:
;-----antes de mover la bola tenemos que definir su direccion
	
	call direccion ;ver seccion de direccion
	call cmpBolaBloque1
    call revision
;-----     fila(n) ; columna(m) --->> cusorPos Esc "[r9,r10 ; r12,r13H"
; Se le asignan los valores iniciales(y los que le siguen) de la posicion de la bola a su variable, estos valores
; van cambiando con el tiempo, en cada ciclo es diferente

	mov r15,59 				; caracter " ; " ascii
	mov [cursorPos + 0x2],r10 	    	; decena de la coodenada n
	mov [cursorPos + 0x3],r9		; unidad de la coodenada n
	mov [cursorPos + 0x4],r15		; 
	mov [cursorPos + 0x5],r13		; decena de la coodenada m
	mov [cursorPos + 0x6],r12		; unidad de la coodenada m

	mov r15,72				; caracter H final del string CursorPos
	mov [cursorPos + 0x7],r15		; lo muevo

;------Se mueve el cursor a las coordenadas asignadas en el segmento anterior
	
	escribe cursorPos,cursorPosT	

;-----una ves en la posicion deseada imprime la bola 

	escribe bola,bolaT

	mov rcx, 22299000 			; la velocidad de la bola en el juego
	
;!!!!NOTA!!!!: si se quisiera poner la dificulta en el juego cambiar la velocidad es una buena opcion 

;--------empieza el ciclo para un movimiento "perpetuo" o constante de la bola

cicloFor:
	loop cicloFor

;---------una vez que se imprime la bola se tiene que borrar, entonces lo que se hace en imprimir un "  " encima

	escribe cursorPos,cursorPosT

	escribe borrarBola,borrarBolaT

	escribe vidas,lvidas
	escribe amit,2	

	;call Proc_ComparaPosicion
	call ciclo_barra

	jmp movimiento							; vuelvo a cambiar las posiciones



;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;-----------------------------------Procedimiento para cambiar la direccion de la bola-----------------------------
direccion:
	call horizontal ;movimiento de derecha a izquierda y viceversa 
	call vertical   ;movimiento de abajo a arriba y viceversa
	ret

	horizontal:
	cmp r8,0					; para saber en que direccion r8 - 0 (la comparacion es una resta en el fondo)
	je derecha					; Y si es igual a 0 la bola va a la derecha 
	jmp izquierda					; salto sin condicion, porque si no se cumple el anterior si o si se da este salto

	derecha:
	cmp r13,RightD					; comparo el limite derecho de las Decenas a ver si coinside
	je derecha1			; si son iguales tengo que comparar las Unidades del limite para tomar la desicion de direccion
	call aumentoX					; Si aun no esta cerca del limite solo aumenta el eje X
	ret
	call canonical_on
call echo_on
escribe borrar,borrarl
call marco
call echo_on
escribe borrar,borrarl
call marco
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
	je vidaMenos
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
;--------------------inicializa valores-------------
variables:
	mov byte [b1],0x31
    mov byte [b2],0x31
    mov byte [b3],0x31
    mov byte [b4],0x31
    mov byte [b5],0x31
    mov byte [b6],0x31
    mov byte [b7],0x31
    mov byte [b8],0x31
    mov byte [b9],0x31
    ret
;-----------seccion de los bloques, altura
cmpBolaBloque1:
	
    X_D:
		
        cmp r10,0x30
        je X_U
        ja X_D2
        
    
    X_U:
        
        cmp r9,0x39
        je Y_D
        cmp r9,0x36
        je Y_DD
        cmp r9,0x33
        je Y_DDD
        
  
	X_D2:
		
		cmp r10,0x33
		je X_U1
		jne retorne
	
	X_U1:
		ret
		cmp r9,0x37
		je WhereBarra
		ja vidaMenos
		
	vidaMenos:
		sub byte[amit],1
		cmp byte[amit],0x30
		je lose
        jne reinicair
        ret
	
    reinicair:
    call canonical_on
    call echo_on
    call variables
    escribe perdioV,LV
    call esperar
    jmp juego
    ret
    
    esperar:
        mov rsi,ingreso
        call leetecla
        ret

   WhereBarra:
		;escribe debug,debugL
		push r8
		push r15
		
		Carac2Num_Registros r13, r12, r8, r15
		Carac2Num qword [barra_horiz_pos + 0x5], qword [barra_horiz_pos + 0x6], qword [pos_barra], qword [aux]
		pare1:
		;mov byte [contador], 1
		cmp r8, qword [pos_barra]
		jbe WhereBarra2
		ja retornoZ
	
	WhereBarra2:
		;escribe debug,debugL
		add qword [pos_barra], 0x6
		cmp r8, qword [pos_barra]
		jbe reboteBB
		ja retornoZ
	;	jnz next_pos

	;next_pos:
	;	add qword [pos_barra], 1
	;	add qword [contador], 1
	;	cmp r11, [pos_barra]
	;	jz reboteBB
	;	cmp qword [contador], 7
	;	jz retornoZ
	;	jnz next_pos
        
     retornoZ:
		pop r15
		pop r8
		ret
		
	retorne:
		
		ret
  
	reboteBB:
		;escribe debug,debugL
		pop r15
		pop r8
		call cambioDirUp
		ret
        
    ;------------------------primera fila------------------------    
    Y_D:
         
        cmp r13,0x31
        jbe Y_U
        cmp r13,0x32
        jbe Y_U1
        cmp r13,0x33
        jae BBloque3
        
        
        ret
    
        
    Y_U:
        cmp r13,0x30
        je BBloque1  
        cmp r12, 0x33
        jbe BBloque1
        ja BBloque2
        ret

    Y_U1:
		cmp r13, 0x31
		je BBloque2   
        cmp r12, 0x34
        jbe BBloque2
        jmp BBloque3
        ret

;------------llamado de borrar los bloques----------------------
    
    BBloque1:
         
        cmp byte[b1],0x31
        jne s1
        escribe POSI1,PosiL1       
        escribe borraBloque,LborraBloque
        
        mov byte[b1],0x30        
         
        call cambioDirDown
        ret
        s1:
        ret ;sumamente IMPORTANTE

    BBloque2:
    
        cmp byte[b2],0x31
        jne s2
        escribe POSI2,PosiL2
        escribe borraBloque,LborraBloque
        
        mov byte[b2],0x30
        
        call cambioDirDown
        ret
        s2:
        ret ;sumamente IMPORTANTE

    BBloque3:

        cmp byte[b3],0x31
        jne s3
        escribe POSI3,PosiL3
        escribe borraBloque,LborraBloque
        
        mov byte [b3],0x30
        sub byte[amit],1
        call cambioDirDown
        ret
        s3:
        ret ;sumamente IMPORTANTE

   ;------------------------Segunda fila------------------------    
    Y_DD:
           
        cmp r13,0x31
        jbe Y_UU
        cmp r13,0x32
        jbe Y_UU1
        cmp r13,0x33
        jae BBloque6
        
        ret
    
        
    Y_UU:
        cmp r13,0x30
        je BBloque4  
        cmp r12, 0x33
        jbe BBloque4
        jmp BBloque5
        ret

    Y_UU1:
		cmp r13, 0x31
		je BBloque5   
        cmp r12, 0x34
        jbe BBloque5
        jmp BBloque6
        ret

;------------llamado de borrar los bloques----------------------
    
    BBloque4:
         
        cmp byte[b4],0x31
        jne s4
        escribe POSI4,PosiL4       
        escribe borraBloque,LborraBloque
        
        mov byte[b4],0x30        
         
        call cambioDirDown
        ret
        s4:
        ret ;sumamente IMPORTANTE

    BBloque5:
    
        cmp byte[b5],0x31
        jne s5
        escribe POSI5,PosiL5
        escribe borraBloque,LborraBloque
        
        mov byte[b5],0x30
        
        call cambioDirDown
        ret
        s5:
        ret ;sumamente IMPORTANTE

    BBloque6:

        cmp byte[b6],0x31
        jne s6
        escribe POSI6,PosiL6
        escribe borraBloque,LborraBloque
        
        mov byte [b6],0x30
        
        call cambioDirDown
        ret
        s6:
        ret ;sumamente IMPORTANTE

;------------------------Tercera fila------------------------    
    Y_DDD:
           
        cmp r13,0x31
        jbe Y_UUU
        cmp r13,0x32
        jbe Y_UUU1
        cmp r13,0x33
        jae BBloque9
        
        ret

    Y_UUU:
        cmp r13,0x30
        je BBloque7  
        cmp r12, 0x33
        jbe BBloque7
        jmp BBloque8
        ret

    Y_UUU1:
		cmp r13, 0x31
		je BBloque8   
        cmp r12, 0x34
        jmp BBloque9
        ret

;------------llamado de borrar los bloques----------------------
    
    BBloque7:
         
        cmp byte[b7],0x31
        jne s7
        escribe POSI7,PosiL7       
        escribe borraBloque,LborraBloque
        
        mov byte[b7],0x30        
         
        call cambioDirDown
        ret
        s7:
        ret ;sumamente IMPORTANTE

    BBloque8:
    
        cmp byte[b8],0x31
        jne s8
        escribe POSI8,PosiL8
        escribe borraBloque,LborraBloque
        
        mov byte[b8],0x30
        
         call cambioDirDown
        ret
        s8:
        ret ;sumamente IMPORTANTE

    BBloque9:

      cmp byte[b9],0x31
        jne s9
        escribe POSI9,PosiL9
        escribe borraBloque,LborraBloque
        sub byte[amit],1
        mov byte [b9],0x30
        
        call cambioDirDown
        ret
        s9:
        ret ;sumamente IMPORTANTE

;---------------------------comparaacion de salida---------------------------------------
revision:
    cmp byte[b1],0x30
    jne me_fui
    cmp byte[b2],0x30
    jne me_fui
    cmp byte[b3],0x30
    jne me_fui
    cmp byte[b4],0x30
    jne me_fui
    cmp byte[b5],0x30
    jne me_fui
    cmp byte[b6],0x30
    jne me_fui
    cmp byte[b7],0x30
    jne me_fui
    cmp byte[b8],0x30
    jne me_fui
    cmp byte[b9],0x30
    je win
    me_fui:
    ret

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

;-----------------------------------RUTINA PRINCIPAL---------------------------------------

_start:
;----------------INICIALIZACION DE ESTADO DE BLOQUES------

call variables
;------------------- Valores Iniciales  la Barra------------------

mov byte [salida], 5

mov byte [pos_barra_dec], 49

mov byte [pos_barra_uni], 49

mov byte [barra_f], 102

;---------------------------------------------------------------------

escribe SinCursor,SinCursorT
escribe borraPan,borraPanT

call Inicio				;Imprime Pantalla Inicial
escribe borraPan,borraPanT

			;Pantalla donde se espera el 'X'
			
escribe	Bienvenida,L_Bienvenida


mov rsi, ingreso
call leetecla
juego:
escribe borraPan,borraPanT
;-------------Pinta el marco y los bloques------------
call marco
call bloques
call Proc_ImprimeBarra			;imprime la barra en la posicion inicial

;-----------escribe tambien el nombre del jugador-----
escribe jugador,Ljugador
escribe nombre, 10

;----------------apaga el modo canonico para entrar al movimiento de la bola y barra
call canonical_off
call echo_off

;---------------------mueve la bola y barra------------------------------
mov r9, 0x37			; valores iniciales para imprimir la bola
mov r10, 0x32			; linea 30
mov r12, 53			; columna 42
mov r13, 49

;---------------- SE DEFINEN REGISTROS PARA LA DIRECCION DE LA BOLA

mov r8,1				; 0 abajo 1 arriba
mov r14,1				; 0 derecha 1 izquierda

call movimiento
;escribe borraPan,borraPanT


lose:
call canonical_on
call echo_on
escribe borrar,borrarl
call marco
escribe perdio,Lperdio
mov rsi, ent
call leetecla;
jmp _salir

win:
call canonical_on
call echo_on
escribe borrar,borrarl
escribe gano,ganoL
mov rsi, ent
call leetecla




_salir:


mov rax,80000000h
	cpuid
	mov rsi,80000004h	
	cmp rax,rsi ; compara por si el cpu no tiene la capacidad obtener la info
	
	
	
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
escribe borrar,borrarl
escribe msg2, len2

escribe cursorPos, cursorPosT

escribe nom1, 48

escribe msg3, len3

escribe esconde,largo_esconde

mov rsi, ent
call leetecla;
escribe borrar, borrarl;-----------------borra la consola--------------------



	mov rax,60    ;rax = sys_exit (60)
	mov rdi,0     ;rdi = 0
	syscall 

;------------------------------
