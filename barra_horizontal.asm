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
        cmp %2, 56      ;54 => ascii decimal para '6'; compara unidades(posicion vs limite);%2 = pos_barra_uni
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

;--------------------------------Segmento de Datos-----------------------------
;Aqui se declaran las variables utilizadas en el programa
;Hints:
;10 = 0xa = New Line
;27 = 0x1b = Escape
;[ => usado para los Ansi Escape Codes


section .data
;------------------------------------Variables---------------------------------
	;pos_barra_uni: db 50			;posicion de la barra en la pantalla, valor inicial 12
	;pos_barra_dec: db 49			;se deben definir como caracteres de decenas y unidades (no se usan)
	;especificamente 'pos_barra' es la posicion del extremo izquierdo de la barra
	;Codigos ascii para numeros de 0 a 9:
	;0 => 48 => 0x30
	;9 => 57 => 0x39

;-----------------------------------Constantes---------------------------------
	borrar: db 27,"[2J"
	borrar_tam: equ $-borrar

        cons_banner: db "Presione una tecla, seguida de Enter: "                ;Primer mensaje para el usuario
        cons_tam_banner: equ $-cons_banner

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

	finalhor_inf: db 27,"[34;32f ","* "
	finalhor_inf_tam: equ $-finalhor_inf

	final_marco: db 27,"[35;1f "
	final_marco_tam: equ $-final_marco

	barra_horiz_pos: db 27,"[32;10f ","------"			;se debe dejar el '-----'
	barra_horiz_pos_tam: equ $-barra_horiz_pos

	barra_horiz: db "o===o"
	barra_horiz_tam: equ $-barra_horiz

;	dato_ent: db ""
;	dato_ent_tam: equ $-dato_ent

;----------------------------Variables para apagar y encender el
;----------------------------modo canonico y el echo
	termios:        times 36 db 0
	stdin:          equ 0
	ICANON:         equ 1<<1
	ECHO:           equ 1<<3

segment .bss                                    ;Aun no es necesario
        dato_ent: resb 1
	pos_barra_uni: resb 1
	pos_barra_dec: resb 1
	salida: resb 1
	barra_f: resb 1

;----------------------------------Segmento de Codigo---------------------------
section .text

;----------Etiquetas------------
	global _start
	global _ciclo_juego
	global _salir
	global _parada

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
	Escribir cons_banner, cons_tam_banner
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
	Escribir final_marco, final_marco_tam
ret
;-------------------------------------------------------

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

;-------------------------------------------------------

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

;-------------------------------------------------------

canonical_on:
        call read_stdin_termios

        ; set canonical bit in local mode flags
        or dword [termios+12], ICANON

        call write_stdin_termios
        ret

;-------------------------------------------------------

echo_on:
        call read_stdin_termios

        ; set echo bit in local mode flags
        or dword [termios+12], ECHO

        call write_stdin_termios
        ret

;-------------------------------------------------------

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

;-------------------------------------------------------

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

;-------------------------------------------------------

;---------Rutina Principal------
_start:
	mov byte [salida], 5

	mov byte [pos_barra_dec], 49

	mov byte [pos_barra_uni], 49

	mov byte [barra_f], 102

	call canonical_off
	call echo_off

	jmp _ciclo_juego

_ciclo_juego:

	Escribir borrar, borrar_tam	;Limpia la consola

	;Seccion para pintar el marco del juego
	;Se utiliza un procedimiento denominado 'Proc_Marco'
	call Proc_Marco

	call Proc_ImprimeBarra

	;Seccion para tomar la tecla presionada en el teclado
	call Proc_GetKey

	;Comparar para saber si se debe hacer una decodificacion de la tecla
	;o si se debe seguir con el programa
	call Proc_DecoKey

	;Escribir la barra horizontal con los parametros modificados
        call Proc_ImprimeBarra

	;Determinar si se sigue o no en el juego, se sale si r10 != 25
	cmp byte [salida], 25
	jz _salir
	jnz _ciclo_juego

;----------Salida-----------
_salir:
	call canonical_on
	call echo_on

	mov rax, 60
        mov rdi, 0
        syscall

	;Fin de la rutina principal
;------------------------------
