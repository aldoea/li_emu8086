name "CUADRO MAGICO"
org 100h

MwriteToFile MACRO number
		; write to file:
		mov ah, 40h
		mov bx, filehandler
		mov varhelper, number
		mov dx, offset varhelper
		mov cx, 2
		int 21h
ENDM

Mseek MACRO index
	mov ax, index
	mov bx, 2
	mul bx
	mov di, ax

	mov al, 0
	mov bx, filehandler
	mov cx, 0
	mov dx, di
	mov ah, 42h
	int 21h
ENDM

MopenFile MACRO
	mov al, 1 ; WRITE MODE
	mov dx, offset filename
	mov ah, 3dh
	int 21h
	jc EXEPTION
	mov filehandler, ax
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

Mprint macro string 
  mov ah,09
  mov dx,OFFSET string
  int 21h
endm

.data
	input DB 31 DUP(?),"$"
	inputNum db ?
	squaresize dw ?
	msg db "Please type the size of the magic square :) " , 0Dh,0Ah, "$"
	msg_badinput db "Please type only real numbres starting from 3 :) " , 0Dh,0Ah, "$"
	msg_fileexption db "AN EEROR OCURS CREATING THE FILE... " , 0Dh,0Ah, "$"
  msg_ok db "File writting successful" , 0Dh,0Ah, "$"
	filename db 'squarefile.txt',0
	filehandler dw 0
	varhelper  dw 0
	
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
	  	mov inputNum, bl
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

			mov cx, squaresize
			mov si, 0
			mov di, squaresize
			dec di
			inc si
			FORI:
				push cx
				push di
				Mseek di
				pop di
				MwriteToFile si
				pop cx
				inc si
				dec di
			LOOP FORI
			


			McloseFile

			Mprint msg_ok
	  	
	  	;------ HERE GOES THE ALGORITHM OMG!
	  	;----------------------------------
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




