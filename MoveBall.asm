section .data

	borraPan: db 27,'[2J'				; borramos la pantalla y
	borraPanT: equ 4					; tamanno de la variable anterior

	SinCursor: db 27,'[?25l'		 	; me elimina el parpadeo del cursos en la consola
	SinCursorT: equ 6					; tamanno de la variable anterior

	bola: db 'O'						; dibujo de la bola
	bolaT: equ $-bola					; tamanno de la variable de la bola

	borrarBola: db '  '					; vacio para caerle encima a la bola y borrarla
	borrarBolaT: equ $-borrarBola		; tamanno de la variable de la bola

	cursorPos: db 27,'[30;42H'  		; Posicion de la bola en el inicio = fila ; columna,
	cursorPosT: equ 8

	;------------- LIMITES DE LA PANTALLA DONDE LA BOLA REBOTA------

	RightU: equ 57							; todos los valores en Ascii
	RightD: equ 55		;----------------------------------------------;
	LeftU: equ 50		;0,0										   ;
	LeftD: equ 48		;											   ; 
						;											   ;
	DownU: equ 50		;											   ;
	DownD: equ 51		;											   ;
	UpU: equ 48			;											   ;
	UpD: equ 48			;----------------------------------------------;

section .text

	global _start

; procedimiento para imprimir en pantalla
; Espera que el mensaje a escribir esté en el registro RSI
; Y su tamanio en el RDX
; Imprime en pantalla y retorna a la siguiente intruccion despues de su llamada

imprimir:
	mov rax,1
	mov rdi,1
	syscall
	ret

;----COMIENZO DE PROGRAMA-----

_start: 
; ----------------borramos la pantalla de la consola---------

	mov rsi,borraPan
	mov rdx,borraPanT
	call imprimir
	
;----------------quitamos el cursor o el pardeo del mismo-------------

	mov rsi,SinCursor
	mov rdx,SinCursorT
	call imprimir
	
;-------------------SE DERTERMINA LOS VALORES INICIALES DE LA POSICION DE LA BOLA

	mov r9, 48			; valores iniciales para imprimir la bola
	mov r10, 51			; linea 30
	mov r12, 50			; columna 42
	mov r13, 52
	
;---------------- SE DEFINEN REGISTROS PARA LA DIRECCION DE LA BOLA

	mov r8,0				; 0 abajo 1 arriba
	mov r14,0				; 0 derecha 1 izquierda

;------------SE EMPIEZA EL MOVIMIENDO DE LA BOLA

movimiento:
;-----antes de mover la bola tenemos que definir su direccion
	
	call direccion ;ver seccion de direccion
	
;-----     fila(n) ; columna(m) --->> cusorPos Esc "[r9,r10 ; r12,r13H"
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

	mov rsi,cursorPos						
	mov rdx,cursorPosT
	call imprimir
	
;-----una ves en la posicion deseada imprime la bola 

	mov rsi,bola								
	mov rdx,bolaT
	call imprimir
	mov rcx, 0xfffffe 	; la velocidad de la bola en el juego
	
;!!!!NOTA!!!!: si se quisiera poner la dificulta en el juego cambiar la velocidad es una buena opcion 

;--------empieza el ciclo para un movimiento "perpetuo" o constante de la bola

cicloFor:
	loop cicloFor

;---------una ves que se imprime la bola se tiene que borrar, entonces lo que se hace en imprimir un "  " encima

	mov rsi,cursorPos						; muevo el cursor a la posicion de la bola y...
	mov rdx,cursorPosT
	call imprimir

	mov rsi,borrarBola					; ... le caigo encima con un vacio
	mov rdx,borrarBolaT
	call imprimir

	jmp movimiento							; vuelvo a cambiar las posiciones


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
