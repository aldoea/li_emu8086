;able was ere ere saw elba
name "palindrome"
org 100h

jmp start

START:
		mov dx, OFFSET msg
		mov ah, 9
		int 21h

		mov bx, 0000h
		lea SI, input
		mov cx, 32

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
    mov si, inputSize
    dec si
    mov di, 0
    
    mov cx, inputSize
    cmp cx, 1
    je is_palindrome  
    
    shr cx, 1 
    
    next_char:
        mov al, input[di]
        mov bl, input[si]
        cmp al, bl
        jne not_palindrome
        inc di
        dec si
    loop next_char
    
    
    is_palindrome:        
       mov ah, 9
       mov dx, offset msg1
       int 21h
    jmp stop
    
    not_palindrome:       
       mov ah, 9
       mov dx, offset msg2
       int 21h
stop:

; wait for any key press:
mov ah, 0
int 16h
ret

input db 31 DUP(?),"$"
inputSize dw 0
msg1 db 13, 10 "Is palindrome!$"
msg2 db 13,10 "Is is not a palindrome!$"
msg db 13,10, "Please type it: $"
