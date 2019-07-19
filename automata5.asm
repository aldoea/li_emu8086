name "Automata a^2nb^n"
org 100h
.data
	input DB 31 DUP(?),"$"
	inputSize dw ?
	autCounter dw 0
	numCondAut DB 3
	msg db 13,10, "Please type it: $"
	success db 13,10,"Valid input! $"
	fail db 13,10,"Invalid input... $"
	m3 db 13,10, "</3"
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
  		mov autCounter, 0

  		FOREACHCHAR:
  			mov ah, 00
  			mov al, input[si]
  			cmp ax, "a"
  			jz ISA
  			cmp ax, "b"
  			jz ISB
  			jnz NOTOK
		LOOP FOREACHCHAR

		ISA:
			inc autCounter
			inc si
		LOOP FOREACHCHAR
		jmp EVALUTE

		ISB:
			inc si
		LOOP FOREACHCHAR
		jmp EVALUTE

		OK:
	    	mov ah, 9
            mov dx, OFFSET success
            int 21h	
            jmp END

        NOTOK:
        	mov ah, 9
        	mov dx, OFFSET fail
        	int 21h
        	jmp END

        EVALUTE:
        	xor dx, dx
        	mov ax, autCounter  
        	div numCondAut
        	cmp ah, 0
        	jz OK
        	jnz NOTOK

        END:
        	; WAIT USER
			mov ah, 0
			int 16h
			jmp START
	ret	