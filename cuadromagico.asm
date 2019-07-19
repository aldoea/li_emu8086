name "CUADRO MAGICO"
org 100h

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

			; write to file:
			mov ah, 40h
			mov bx, filehandler
			mov varhelper, 10
			mov dx, offset varhelper
			mov cx, 2
			int 21h


			mov ah, 3eh  ;Cierre de archivo
			mov bx, filehandler 
			int 21h
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




