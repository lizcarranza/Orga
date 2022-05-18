; Dado un archivo en formato BINARIO que contiene informacion sobre autos llamado listado.dat
; donde cada REGISTRO del archivo representa informacion de un auto con los campos: 
;   marca:							10 caracteres
;   año de fabricacion:				4 caracteres
;   patente:						7 caracteres
;	precio							7 caracteres
; Se pide codificar un programa en assembler intel que lea cada registro del archivo listado y guarde
; en un nuevo archivo en formato binario llamado seleccionados.dat las patentes y el precio (en bpfc/s) de aquellos autos
; cuyo año de fabricación esté entre 2010 y 2020 inclusive
; Como los datos del archivo pueden ser incorrectos, se deberan validar mediante una rutina interna.
; Se deberá validar Marca (que sea Fiat, Ford, Chevrolet o Peugeot), año (que sea un valor
; numérico y que cumpla la condicion indicada del rango) y precio que sea un valor numerico.


global	main
extern  puts
extern  printf
extern  fopen
extern  fclose
extern  fread 
extern  sscanf
extern  fwrite

section	.data
	fileListado		db	"listado.dat",0
	modeListado		db	"rb",0		;read | binario | abrir o error
	msjErrOpenLis	db	"Error en apertura de archivo Listado",0
    handleListado	dq	0

	fileSeleccion	db	"seleccion.dat",0
	modeSeleccion	db	"wb",0
	msjErrOpenSel   db	"Error en apertura de archivo seleccion",0
	handleSeleccion	dq	0

	regListado		times	0 	db ''	;Longitud total del registro: 28
	  marca			times	10	db ' '
	  anio			times	4	db ' '
	  patente		times	7	db ' '
	  precio		times	7	db ' '

	vecMarcas		db	"Ford      Chevrolet Peugeot   Fiat      ",0

	anioStr	 		db "****",0
	anioFormat	    db "%hi",0	;16 bits (word)
	anioNum			dw	0		;16 bits (word)  

	precioStr 		db "*******",0
	precioFormat    db "%d",0 ; '%i',0	;32 bits (double word)

	regSeleccion	times	0	db	'' ;11 bytes en total
	 patenteSel		times	7	db ' ' ;7 bytes
	 precioSel					dd 0   ;4 bytes

	;*** Mensajes para debug
	msjAperturaOk db "Apertura Listado ok",0
	msjLeyendo	db	"leyendo...",0

	charFormat		db "%c",10,0

section .bss
	regsitroValido	resb 1
	datoValido		resb	1

section  .text
main:

	;Abro archivo listado
    mov		rcx,fileListado 
    mov     rdx,modeListado
	sub		rsp,32
	call	fopen
	add		rsp,32

	cmp		rax,0
	jle		errorOpenLis
	mov     [handleListado],rax

mov		rcx,msjAperturaOk
sub		rsp,32
call	puts
add		rsp,32

	;Abro archivo seleccion
	mov		rcx,fileSeleccion
	mov		rdx,modeSeleccion
	sub		rsp,32
	call	fopen
	add		rsp,32

	cmp		rax,0
	jle		errorOpenSel
	mov		[handleSeleccion],rax
leerRegistro:
    mov     rcx,regListado
    mov     rdx,28           
    mov     r8,1
	mov		r9,[handleListado] 
	sub		rsp,32  
	call    fread
	add		rsp,32
	cmp     rax,0
    jle     closeFiles	

mov 	rcx,msjLeyendo
sub		rsp,32
call	puts  
add		rsp,32

	;Valido registro
	call	validarRegistro
    cmp		byte[regsitroValido],'N'
    je		leerRegistro

	;Copio Patente al campo del registro del archivo
	mov		rcx,7
	mov		rsi,patente
	mov		rdi,patenteSel
	rep	movsb	

	;Copio campo precio a otro campo q tiene el 0 binario al final
	mov		rcx,7
	mov		rsi,precio
	mov		rdi,precioStr
	rep	movsb

	mov		rcx,precioStr  
	mov		rdx,precioFormat    
	mov		r8,precioSel   
	sub 	rsp,32
	call	sscanf
	add 	rsp,32

	;Guardo registro en archivo Seleccion
	mov		rcx,regSeleccion			;Parametro 1: dir area de memoria con los datos a copiar
	mov		rdx,11						;Parametro 2: longitud del registro
	mov		r8,1						;Parametro 3: cantidad de registros
	mov		r9,[handleSeleccion]		;Parametro 4: handle del archivo
	sub		rsp,32
	call	fwrite
	add		rsp,32

	jmp		leerRegistro


errorOpenLis:
	mov		rcx,msjErrOpenLis
	sub		rsp,32
	call	puts
	add		rsp,32
	jmp		endProg
errorOpenSel:
    mov     rcx,msjErrOpenSel
	sub		rsp,32
    call    puts
	add		rsp,32
	jmp		closeFileListado
closeFiles:
	mov		rcx,[handleSeleccion]
	sub		rsp,32
	call	fclose				
	add		rsp,32
closeFileListado:
    mov     rcx,[handleListado]
	sub		rsp,32
    call    fclose
	add		rsp,32


endProg:
ret

;------------------------------------------------------
;------------------------------------------------------
;   RUTINAS INTERNAS
;------------------------------------------------------
validarRegistro:
	mov     byte[regsitroValido],'N'

	call	validarMarca
	cmp		byte[datoValido],'N'
	jle		finValidarRegistro

	call	validarAnio
	cmp		byte[datoValido],'N'
	jle		finValidarRegistro

	call	validarPrecio
	cmp		byte[datoValido],'N'
	jle		finValidarRegistro

	mov     byte[regsitroValido],'S'
finValidarRegistro:
ret

;------------------------------------------------------
;VALIDAR MARCA
validarMarca:
	mov     byte[datoValido],'S'

	mov     rbx,0
	mov     rcx,4
nextMarca:
	push	rcx
	mov     rcx,10
	lea		rsi,[marca]
	lea		rdi,[vecMarcas + rbx]
repe cmpsb
	pop		rcx

	je		marcaOk
	add		rbx,10
	loop	nextMarca
	
	mov     byte[datoValido],'N'
marcaOk:
mov	rdx,[datoValido]
call printf_char
ret
;------------------------------------------------------
;VALIDAR AÑO
validarAnio:
	mov     byte[datoValido],'N'

	mov		rcx,4
	mov		rsi,anio
	mov		rdi,anioStr
	rep	movsb

	mov		rcx,anioStr    
	mov		rdx,anioFormat   
	mov		r8,anioNum      
	sub		rsp,32
	call	sscanf
	add		rsp,32
	cmp rax,1
	jl	anioError

; Verifico si el año esta comprendido en el rango 2010 - 2019
	cmp		word[anioNum],2010
	jl		anioError
	cmp		word[anioNum],2020
	jg		anioError 

	mov		byte[datoValido],'S'
anioError:
mov	rdx,[datoValido]
call printf_char
ret

;------------------------------------------------------
;VALIDAR PRECIO
validarPrecio:
	mov     byte[datoValido],'N'

	mov		rcx,7 ;longitud del campo 'precio'
	mov		rbx,0
nextDigitoP:
	cmp		byte[precio+rbx],'0'
	jl		precioError
	cmp		byte[precio+rbx],'9'
	jg		precioError
	inc		rbx
	loop	nextDigitoP

	mov     byte[datoValido],'S'

precioError:
mov	rdx,[datoValido]
call printf_char
ret
;------------------------------------------------------
;PRINTF_CHAR
printf_char:
	mov		rcx,charFormat	;PRIMER PARAMETRO DE printf. El segundo se carga afuera en rsi
	sub		rsp,32
	call	printf
	add		rsp,32
ret