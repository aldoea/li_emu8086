name "Automata a^2nb^n"
org 100h  
.data
    msg db 13,10, "Compilador de parentesis",0
	input DB 31 DUP(?),"$"
	inputSize dw ?
	statusCounter dw 0
	msgsucess db 13,10,"Valid input! $"
	msgfail db 13,10,"Invalid input... $"
	IsBegining dw 0
.code
		START:
			mov dx, OFFSET msg
			mov ah, 9
			int 21h

			mov bx, 0000h
			lea SI, input
			mov cx, 31

		READ:
			 mov ah,01h
		     int 21h
		     cmp al,13
		     je MAINPROC
		     mov [SI],al
		     inc SI
		     inc bx
		  LOOP READ

	  MAINPROC:
	  	mov inputSize, bx
	  	mov cx, inputSize
	  	mov si, 0
	  	mov statusCounter, 0

	  	FOREACHCHAR:
	  		mov ah, 00
  			mov al, input[si]
	  		cmp IsBegining, 0
	  		jz FIRST
	  		cmp ax, 40
	  		jz OPEN
	  		cmp ax, 41
	  		jz CLOSE
	  		jnz ERROR
	  	LOOP FOREACHCHAR

	  	FIRST:
	  		mov IsBegining, 1
	  		cmp ax, 40
	  		jnz ERROR
	  		jmp OPEN
	  	
	  	OPEN:
	  		inc statusCounter
	  		inc si
	  		LOOP FOREACHCHAR
	  	jmp EVAL

	  	CLOSE:
	  		cmp statusCounter, 0
	  		jz ERROR
	  		dec statusCounter
	  		inc si
	  		LOOP FOREACHCHAR
	  	jmp EVAL
	  	
	  	EVAL:
	  		cmp statusCounter, 0
				jnz ERROR
				mov ah, 9
				mov dx, OFFSET msgsucess
				int 21h
	  		jmp END

	  	ERROR:
	  		mov ah, 9
	  		mov dx, OFFSET msgfail
	  		int 21h  
	  		jmp END
	  		
  	   END:
            ; WAIT USER
            mov ah, 0
            int 16h
            jmp START	
ret	