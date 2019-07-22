
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

imprime macro cadena
  mov ah,09
  mov dx,offset cadena
  int 21h
endm

.data
    nombre db 'aaatester.txt',0  ;nombre archivo a manejar, debe terminar en 0
    msjcrear db 0ah,0dh, 'Archivo creado con exito', '$'
    msjescr db 0ah,0dh, 'Archivo escrito con exito', '$'
    msjerr db 0ah,0dh, 'ERROR', '$'
    msj dw "REDRUM"
    handle dw ?
    text_size = $ - offset msj
    
.code    
    mov ah,3ch ;instrucción para crear el archivo.
    mov cx,0 
    mov dx,offset nombre ;crea el archivo con el nombre archivo2.txt indicado indicado en la parte .data
    int 21h
    jc salir ;si no se pudo crear el archivo arroja un error, se captura con jc.
    imprime msjcrear   
    mov handle, ax

    ;Escritura de archivo  
    mov ah,40h
    mov bx,handle ; mover hadfile
    mov dx, offset msj
    mov cx,text_size ;num de caracteres a grabar
    int 21h
    imprime msjescr
    ; close
    
    mov ah, 3eh
    mov bx, handle
    int 21h
   	mov  ax,4c00h
    int  21h
    ret
    salir: 
        imprime msjerr
        ret
        




