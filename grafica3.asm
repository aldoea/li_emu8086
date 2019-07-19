
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

#fasm#
name "Grafica3"
org 100h
mov al, 13h ; definimos el modo de video
mov ah, 0   ; tipo de video grafico de 20 x 200
int 10h     ; y 256 colores

mov cx, 10
mov si, 0
lineas:
    
    push cx
    mov cx, si  ; coordenada en x para pintar
    mov dx, 0
    mov al, 25
    
    cicloV:       
        mov ah, 0ch ; Interrupcion para pintar
        int 10h
        cmp dx, 50
        jz otralinea
        inc al      ;cambiamos el color
        inc dx
        jmp cicloV
    otralinea:
    add si, 5   
    pop cx
loop lineas  

mov cx, 10
mov si, 0
horizontales:
    push cx
    mov dx, si
    mov cx, 50
    mov al, 25
    
    cicloH:
        mov ah, 0ch
        int 10h
        ;cmp cx, 50
        ;jz outer
        inc al
        ;inc cx
    loop cicloH
    add si, 5
    pop cx
loop horizontales    
ret




