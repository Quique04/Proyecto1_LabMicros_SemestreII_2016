;###############################################################################

;El-5413 Lab. de Estructuras de Microprocesadores
;Proyecto 1 - Arkanoid - Barra horizontal


;-------------------------------Descripcion General-----------------------------
;El siguiente codigo imprime en pantalla una barra horizontal como fue
;especificada en el instructivo del primer proyecto. Haciendo uso de una
;interrupcion,la barra se mueve dependiendo de la tecla presionada.

;###############################################################################


;--------------------------------Segmento de Datos-----------------------------
;Aqui se declaran las variables utilizadas en el programa
;Hints:
;10 = 0xa = New Line
;27 = 0x1b = Escape
;[ => usado para los Ansi Escape Codes


section .data
;------------------------------------Variables---------------------------------
	pos_barra_uni: dw 50			;posicion de la barra en la pantalla, valor inicial 12
	pos_barra_dec: dw 49			;se deben definir como caracteres de decenas y unidades
	;especificamente 'pos_barra' es la posicion del extremo izquierdo de la barra
	;Codigos ascii para numeros de 0 a 9:
	;0 => 48 => 0x30
	;9 => 57 => 0x39

;segment .bss					;Aun no es necesario


;-----------------------------------Constantes---------------------------------
	borrar: db 27,"[2J"
	borrar_tam: equ $-borrar

	lineahoriz_sup: db 27,"[1;1f ","*"
	lineahoriz_sup_tam: equ $-lineahoriz_sup

	lineahoriz_inf: db 27,"[34;1f ","*"
	lineahoriz_inf_tam: equ $-lineahoriz_inf

	lineahoriz: db "="
	lineahoriz_tam: equ $-lineahoriz

	lineavert_izq: db 27,"[2;1f ","||"
	lineavert_izq_tam: equ $-lineavert_izq

	lineavert_der: db 27,"[2;32f ","||"
	lineavert_der_tam: equ $-lineavert_der

	lineavert: db 27,"[1B",27,"[2D","||"
	lineavert_tam: equ $-lineavert

	finalhor_sup: db 27,"[1;32f ","*"
	finalhor_sup_tam: equ $-finalhor_sup

	finalhor_inf: db 27,"[34;32f ","*"
	finalhor_inf_tam: equ $-finalhor_inf

	final_marco: db 27,"[34;33f "
	final_marco_tam: equ $-final_marco

	barra_horiz_pos: db 27,"[28;12f "
	barra_horiz_pos_tam: equ $-barra_horiz_pos

	barra_horiz: db "o===o"
	barra_horiz_tam: equ $-barra_horiz

;----------------------------------Segmento de Codigo---------------------------
section .text

;----------Etiquetas------------
	global _start
	global _ciclo_juego
	global _salir

;-----------Macros--------------
%macro Escribir 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro Sumar_Barra 2
	cmp dword [%2], 54	;54 => ascii decimal para '6'; compara unidades(posicion vs limite);%2 = pos_barra_uni
	je comp_dec_lim
	jne comp_uni_tope	;tope => 9

comp_dec_lim:
	cmp dword [%1], 50		;50 => ascii decimal para '2'; compara decenas(posicion vs limite);%1 = pos_barra_dec
	je set_zero_total
	jne suma_1_uni

comp_uni_tope:
	cmp dword [%2], 57		;57 =>ascii decimal para '9'; compara unidades(posiciones vs tope)
	je suma_1_dec		;suma 1 en las decenas(%1) y mueve un '0' (48) a las unidades (%2)
	jne suma_1_uni

suma_1_uni:
	inc dword [%2]
	jmp final_macro_suma

suma_1_dec:
	mov dword [%2], 48
	inc dword [%1]
	jmp final_macro_suma

set_zero_total:
	mov dword [%2], 48
	mov dword [%1], 48
	jmp final_macro_suma

final_macro_suma:
%endmacro

%macro Restar_Barra 2
	cmp dword [%2], 48	;48 => ascii decimal para '0'; compara unidades(posicion vs tope);%2 = pos_barra_uni
        je comp_dece_tope	;pregunta si %1 es igual a '0'
        jne resta_1_uni		;resta 1 a %2

comp_dece_tope:
        cmp dword [%1], 48	;48 => ascii decimal para '0'; compara decenas(posicion vs tope);%1 = pos_barra_dec
        je final_macro_resta
        jne resta_1_dec

resta_1_uni:
        dec dword [%2]
        jmp final_macro_resta

resta_1_dec:
        mov dword [%2], 57
        dec dword [%1]
        jmp final_macro_resta

final_macro_resta:
%endmacro

%macro Salida 0
	mov rax, 60
	mov rdi, 0
	syscall
%endmacro

;--------Procedimientos---------
Proc_Marco:				;Subrutina para pintar el marco del juego
	;r8 es el contador para los loops
	;cada vez que se ejecuta un loop r8 se aumenta en 1
	;hasta que alcanza el valor de r9

	;Pintar la linea horizontal superior
	Escribir lineahoriz_sup, lineahoriz_sup_tam
	mov r8, 0
	mov r9, 31

marco1:					;loop para la linea horizontal superior
	Escribir lineahoriz, lineahoriz_tam
	inc r8
	cmp r9, r8
	jnz marco1

	;Pintar la linea horizontal inferior
	Escribir lineahoriz_inf, lineahoriz_inf_tam
	mov r8, 0
	mov r9, 31

marco2:					;loop para la linea horizontal inferior
	Escribir lineahoriz, lineahoriz_tam
	inc r8
	cmp r9,r8
	jnz marco2

	;Pintar la linea vertical izquierda
	Escribir lineavert_izq, lineavert_izq_tam
	mov r8, 0
	mov r9, 31

marco3:					;loop para la linea vertical izquierda
	Escribir lineavert, lineavert_tam
	inc r8
	cmp r9, r8
	jnz marco3

	;Pintar la linea vertical derecha
	Escribir lineavert_der, lineavert_der_tam
	mov r8, 0
	mov r9, 31

marco4:					;loop para la linea vertical derecha
	Escribir lineavert, lineavert_tam
	inc r8
	cmp r9, r8
	jnz marco4

	Escribir finalhor_sup, finalhor_sup_tam
	Escribir finalhor_inf, finalhor_inf_tam

ret					;Final del procedimiento 'Marco'
;-----------------------------------------------------

Proc_GetKey:				;Subrutina para obtener el codigo de la
					;tecla presionada (si se presiono alguna)
	jmp CheckForKey
CheckForKey:
	mov ah, 0x01			;pregunta el estado del buffer del teclado, si hay o no una tecla lista
	int 0x16			;interrupciones de uso de teclado
	jnz KeyReady			;si la hay, pasa a leer cual tecla es
	jz ContinueMain			;si no la hay, sigue con el programa principal

KeyReady:
	mov ah, 0x00			;lee el buffer del teclado
	int 0x16			;interrupciones de uso del teclado
;	mov r10, rax			;mueve al registro r10 el resultado de la interrupcion (puede no ser
					;necesario, por eso se deja como comentario)
	;En este punto el registro 'al' ya contiene el valor de la tecla
	jmp ContinueMain		;salta al programa principal

ContinueMain:
ret					;Final del procedimiento 'Proc_GetKey'
;-----------------------------------------------------

Proc_DecoKey:				;Procedimiento para determinar que tecla se obtuvo
					;se debe ejecutar inmediatamente despues de Proc_GetKey si se obtuvo el valor de una tecla
	cmp al, 99
	je tecla_c			;se mueve hacia la izquierda

	cmp al, 122
	je tecla_z			;se mueve hacia la derecha

	cmp al, 32			;sale del ciclo '_ciclo_juego';32 => space
	je tecla_space

tecla_c:
	Sumar_Barra pos_barra_dec, pos_barra_uni
	jmp Continue

tecla_z:
	Restar_Barra pos_barra_dec, pos_barra_uni
	jmp Continue

tecla_space:
	mov r10, 25			;25 se escogio al azar, cuando r10 tenga este valor se sale del juego
	jmp Continue

Continue:
ret
;-------------------------------------------------------

Proc_ImprimeBarra:			;Procedimiento para imprimir la barra movil
					;llama al macro Escribir luego de modificar los valores del string 'barra_horiz_pos'
	mov dword [barra_horiz_pos + 0x5], pos_barra_dec
	mov dword [barra_horiz_pos + 0x6], pos_barra_uni
	Escribir barra_horiz_pos, barra_horiz_pos_tam
	Escribir barra_horiz, barra_horiz_tam
	Escribir final_marco, final_marco_tam
ret
;-------------------------------------------------------

;---------Rutina Principal------
_start:
	mov r10, 5
	jmp _ciclo_juego

_ciclo_juego:
	Escribir borrar, borrar_tam	;Limpia la consola

	;Seccion para pintar la barra horizontal
	call Proc_ImprimeBarra

	;Seccion para pintar el marco del juego
	;Se utiliza un procedimiento denominado 'Proc_Marco'
	call Proc_Marco

	;Seccion para tomar la tecla presionada en el teclado
	call Proc_GetKey

	;Comparar para saber si se debe hacer una decodificacion de la tecla
	;o si se debe seguir con el programa
	call Proc_DecoKey

	;Escribir la barra horizontal con los parametros modificados
	call Proc_ImprimeBarra

	;Determinar si se sigue o no en el juego, se sale si r10 != 25
	cmp r10, 25
	je _salir
	jne _ciclo_juego

_salir:
	Salida
	;Fin de la rutina principal
;------------------------------
