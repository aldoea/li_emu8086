
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

#fasm#

name "mycode"
org 100h

;modo video
mov al, 00h
mov ah, 0
int 10h
;imprimimos cadena de modeo GRAFICO
mov dx, Modo3
mov ah, 9
int 21h
; Hacemos esperar al programa que el usuario toque una tecla
mov ah, 0
int 16h

;Convertir al modo 80x25 e imprimimos la cadena en tipo texto
mov al, 03h
mov ah, 0
int 10h

mov dx, Modo2
mov ah, 9
int 21h

;Resolucion 40x25
mov ah, 0
int 16h

mov al, 14h
mov ah, 0

;Resolucion 40x25
mov ah, 0
int 16h

mov al, 13h
mov ah, 0
int 10h
mov dx, Modo1
mov ah, 9
int 21h
mov ah, 0
int 16h
ret
;variables
Modo1 db "Modo Grafico 40x25. 256 colores. 320x200 pixels.$",0
Modo2 db "Modo Texto. 80x25. 16 colores.$",0
Modo3 db "Modo Texto. 40x25. 16 colores.$",0




