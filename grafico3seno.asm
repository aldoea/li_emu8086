
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

#fasm#              ;Bandera de ensamblador
name "grafico2"     ;Nombre archivo
org 100h            ; set location counter to 100h

mov al, 13h         ; Definimos el mode de video
mov ah, 0           ; En este caso es un tipo de video grafico de 20 x 200
int 10h             ; y 250 colores

mov cx, 1           ; Coordenada en x para pintar el pixel
mov al, 25          ; Color del pixel a pintar


ciclo:
    mov dx, cx      ; Coordenada en Y para pintar el pixel
    mov ah, 0ch     ; Interrupcion para pintar un pixel
    int 10h
    cmp cx, 200
    jz fin
    
    inc cx          ; Al incrementar el pintado sera en diagonal
    inc al          ; Cambiamos el color
    jmp ciclo
    fin:        
ret                 




