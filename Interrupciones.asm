
;    LISTA DE EJEMPLOS DE INTERRUPCIONES

org 100h
    ;---------------------------------------------------------
    ;INT 21h / AH=1 - read character from standard input, with echo, result is stored in AL.
    ;if there is no character in the keyboard buffer, the function waits until any key is pressed. 
    ;---------------------------------------------------------°          
    mov ah, 1
	int 21h 
	
	
	;---------------------------------------------------------         
	;INT 21h / AH=2 - write character to standard output.     
    ;entry: DL = character to write, after execution AL = DL. 
    ;---------------------------------------------------------
	mov ah, 2
	mov dl, '?'
	int 21h    
	
	;---------------------------------------------------------
	;INT 21h / AH=5 - output character to printer.
    ;entry: DL = character to print, after execution AL = DL. 
    ;---------------------------------------------------------
	mov ah, 5
	mov dl, '°'
	int 21h
		
     ; ------------ Entrada de caracteres con eco ---------------------------------
     MOV AH,01H
     INT 21H 
     ; ------------ Salida de caracteres ---------------------------------
     MOV AH,02H
     INT 21H
     ; ------------------ Salida de impresora---------------------------
     MOV AH,05H
     INT 21H
    ; ------------Salida de una cadena de caracteres ---------------------------------
     MSG DB "Hola polo$"
     MOV AH, 09H
     MOV DX, Offset MSG
     INT 21H
    ; --------------Entrada con buffer-------------------------------
     BUF DB 6,0,0,0,0,0,0
     MOV AH, 0Ah
     Mov DX, Offset BUF
     INT 21H
    ; -----------------Obtener status de entrada----------------------------
     MOV AH, 0Bh
     INT 21H
    ; ------------------ Asignar unidad de disco po defecto---------------------------  
     MOV AH, 0Eh
     INT 21H
    ; ------------------ Lectura secuencial ---------------------------
     MOV AH, 14h
     INT 21H
    ; --------------------- Obtener unidad de disco por defecto ------------------------
     MOV AH, 19h
     INT 21H
    ; ----------------- Crear subdirectorio ---------------------------- 
     MOV AH, 39h
     INT 21H
     ; -----------------Borrar subdirectorio----------------------------
     MOV AH, 3Ah
     INT 21H
    ; -------------------- Asignar directorio actual-------------------------
     MOV AH, 3Bh
     INT 21H
    ; ------------------ Leer fichero o dispositivo ---------------------------
     mov BX,2 
     Mov CX,5 
     MOV AH, 3Fh 
     INT 21H
    ; ------------------Escribir en fichero o dispositivo ---------------------------
     Mov CX,5 
     MOV AH, 40h
     INT 21H
    ; -------------------Obtener directorio actual--------------------------
     MOV AH, 47h
     INT 21H
    ; ---------------------------------------------
    
    ; ------------------- WAIT USER --------------------------   
    			mov ah, 0
    			int 16h
    ; --------------------------------------------- 
    
ret      
    
    
