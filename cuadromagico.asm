name "CUADRO MAGICO"
org 100h

MwriteToFile MACRO value
		; write to file:
		mov ah, 40h
		mov bx, filehandler
		mov varhelper, value		
		mov dx, offset varhelper
		mov cx, bytesize
		int 21h
ENDM

Mseek MACRO
	mov ax, index_casilla
	mov bx, bytesize
	mul bx
	mov di, ax

	mov al, 0
	mov bx, filehandler
	mov cx, 0
	mov dx, di
	mov ah, 42h
	int 21h
ENDM

Mcalculate_index_casilla MACRO i, j
	mov ax, i
	mov bx, inputNum
	mul bx
	mov bx, j
	add ax, bx
	mov index_casilla, ax
ENDM

MopenFile MACRO
	mov al, 2 ; WRITE/READ MODE
	mov dx, offset filename
	mov ah, 3dh
	int 21h
	jc EXEPTION
	mov filehandler, ax
ENDM

MreadFromFile MACRO
		;Reading file
		mov bx, filehandler
		mov cx, bytesize
		mov ah, 3fh
		mov dx, offset buffer_reader
		int 21h
ENDM

McloseFile MACRO 
	mov ah, 3eh  ;Cierre de archivo
	mov bx, filehandler 
	int 21h
ENDM

Mblankline MACRO
	mov ah,02h 
	mov dl,0ah ;salto de línea 
	int 21h 
	mov ah,02h 
	mov dl,0dh ;retorno de carro 
	int 21h
ENDM

Mprint MACRO string 
  mov ah,09
  mov dx,OFFSET string
  int 21h
ENDM

Mdebugmode MACRO
	McloseFile
	Mblankline
	Mprint msg_debug
	; WAIT USER
	mov ah, 0
	int 16h
	MopenFile
ENDM

.data
	input DB 31 DUP(?),"$"
	inputNum dw ?
	squaresize dw ?
	msg db "Please type the size of the magic square :) " , 0Dh,0Ah, "$"
	msg_badinput db "Please type only real numbres starting from 3 :) " , 0Dh,0Ah, "$"
	msg_fileexption db "AN EEROR OCURS CREATING THE FILE... " , 0Dh,0Ah, "$"
  msg_ok db "File writting successful" , 0Dh,0Ah, "$"
  msg_debug db "Numero escritom, revisa el archivo" , 0Dh,0Ah, "$"
	filename db 'squarefile.txt',0
	filehandler dw 0
	varhelper  dw 0
	i_index  dw ?
	j_index  dw ?
	i_temp	dw ?
	j_temp	dw ?
	index_casilla dw ?
	bytesize dw 2
	contador dw 0
	buffer_reader dw 0
	zeros dw 0
.code
	START:
		Mprint msg

		mov dl, 10
		mov bl,0

	READ:
		mov ah,01h
		int 21h				
		; Wait for Enter key
		cmp al,13
		je MAINPROC
		; -----------------
		; allow only digits:
		cmp al, '0'
		jnae BADINPUT				     
		cmp al, '9'
		jnbe BADINPUT
		; -----------------
		mov ah,0
		sub al, 48
		mov cl, al
		mov al, bl ; ASCII TO DEC
		mul dl ; MULTIPLY BY 10
		add al, cl ; SUMATORI
		mov bl, al ; STORE
	LOOP READ

	  MAINPROC:
	  	test bl, 1
	    jz BADINPUT
	  	mov inputNum, bx
	  	mov al, bl
	  	mul bl
	  	mov squaresize, ax
	  	
	  	;------ CREATE FILE ----
			mov ah, 3ch
			mov cx, 0
			mov dx, offset filename			
			int 21h
			jc EXEPTION
			mov filehandler, ax		

			; Ponerse al principio del archivo    
			mov bx, filehandler                 
			mov al, 0       ; al=0 indica ponerse desde el principio
			mov cx, 0       ; limite inferior del desplazamiento
			mov dx, 0       ; limite superior del desplazamiento
			mov ah, 42h     ; funcion seek
			int 21h  

			mov ax, squaresize
			mov bx, bytesize			
			mul bx
			mov cx, ax
			mov bx, filehandler
			FILLZEROS:
				push cx
				mov dx, offset zeros
				mov cx, 1
				mov ah, 40h
				int 21h
			    pop cx
			LOOP FILLZEROS

			Mdebugmode
            
			mov i_index, 0 ; fila
			mov ax, inputNum
			mov bx, 2   
			xor dx, dx
			div bx
			mov j_index, ax  ; columna			
			Mcalculate_index_casilla i_index, j_index
			Mseek
			mov cx, 1 ; Contador
			mov contador, cx			
			MwriteToFile cx
			mov cx, contador			
			
	  	;------ HERE GOES THE ALGORITHM OMG!	  	
			MAINWHILE: ; while(cx < squaresize):
				Mdebugmode
				cmp cx, squaresize
				jnl BREAK
				mov ax, i_index
				dec ax
				cmp ax, 0				
				jnge E1
				I1: ; if((i-1)>=0)
					mov ax, j_index
					inc ax
					cmp ax, inputNum
					jnl I1_E1
					I1_I1: ; if((j+1)<(CuadroMagico.n))
						mov ax, i_index
						dec ax
						mov i_temp, ax
						mov ax, j_index
						inc ax
						mov j_temp, ax
						Mcalculate_index_casilla i_temp, j_temp
						Mseek
						MreadFromFile
						mov ax, buffer_reader
						cmp ax, 0
						jne I1_I1_E1
						I1_I1_I1: ;if (readFromFile(indexCasilla) == 0)
							dec i_index
							inc j_index
							inc contador
							Mcalculate_index_casilla i_index, j_index
							Mseek
							mov cx, contador
							MwriteToFile cx
							mov cx,contador
						jmp MAINWHILE
						I1_I1_E1: ; else
							inc i_index
							inc contador
							Mcalculate_index_casilla i_index, j_index
							Mseek
							mov cx, contador
							MwriteToFile cx
							mov cx, contador
						jmp MAINWHILE
					I1_E1: ;else
						mov ax, i_index
						dec ax
						mov i_temp, ax
						mov j_temp, 0
						Mcalculate_index_casilla i_temp, j_temp
						Mseek
						MreadFromFile
						mov ax, buffer_reader
						cmp ax, 0
						jne I1_E1_E1
						I1_E1_I1: ; if (readFromFile(indexCasilla) == 0)
							dec i_index
							mov j_index, 0
							inc contador
							Mcalculate_index_casilla i_index, j_index
							Mseek
							mov cx, contador
							MwriteToFile cx
							mov cx, contador
						jmp MAINWHILE
						I1_E1_E1: ; else
							inc i_index
							inc contador
							Mcalculate_index_casilla i_index, j_index
							Mseek
							mov cx, contador
							MwriteToFile cx
							mov cx, contador
						jmp MAINWHILE
				E1: ; else
					mov ax, j_index
					inc ax
					cmp ax, inputNum
					jnl E1_E1
					E1_I1: ;if (((j + 1) < (CuadroMagico.n)))
						mov ax, inputNum
						dec ax
						mov i_temp, ax
						mov ax, j_index
						inc ax
						mov j_temp, ax
						Mcalculate_index_casilla i_temp, j_temp
						Mseek
						MreadFromFile
						mov ax, buffer_reader
						cmp ax, 0
						jne E1_I1_E1
						E1_I1_I1: ;if (readFromFile(indexCasilla) == 0)
							mov ax, inputNum
							dec ax
							mov i_index, ax
							inc j_index
							inc contador
							Mcalculate_index_casilla i_index, j_index
							Mseek
							mov cx, contador
							MwriteToFile cx
							mov cx, contador
						jmp MAINWHILE
						E1_I1_E1: ; else
							inc i_index
							inc contador
							Mcalculate_index_casilla i_index, j_index
							Mseek
							mov cx, contador
							MwriteToFile cx
							mov cx, contador
						jmp MAINWHILE
					E1_E1: ; else
						inc i_index
						inc contador
						Mcalculate_index_casilla i_index, j_index
						Mseek
						mov cx, contador
						MwriteToFile cx
						mov cx, contador
					jmp MAINWHILE
			;----------------------------------
			BREAK:			
			McloseFile

			Mprint msg_ok	  	
	  	jmp END
	  BADINPUT:
	  	Mblankline
	  	Mprint msg_badinput
	  	mov ah, 0
	  	int 16h	  	
	  	jmp START

	  EXEPTION:
	  	Mprint msg_fileexption
	  	mov ah, 0
	  	int 16h
	  	mov ah,04ch
		int 21h
		jmp END
END: 
	mov  ax,4c00h
  int  21h
	ret