
org 100h
      
DATA SEGMENT
        STR1 DB "INGRESE CADENA #1 ->$"
        STR2 DB "INGRESE CADENA #2 ->$"
        STR11 DB "Cadena1 : ->$"
        STR22 DB "Cadena2 : ->$"

        INSTR1 DB 20 DUP("$")
        INSTR2 DB 20 DUP("$")
        NEWLINE DB 10,13,"$"
        N DB ?
        S DB ?
        MSG1 DB "LAS CADENAS SON IGUALES$"
        MSG2 DB "LAS CADENAS NO SON IGUALES$"

DATA ENDS

CODE SEGMENT

        ASSUME DS:DATA,CS:CODE
START:

        MOV AX,DATA
        MOV DS,AX

        LEA SI,INSTR1
        LEA DI,INSTR2

;GET STRING
        MOV AH,09H
        LEA DX,STR1
        INT 21H

        MOV AH,0AH
        MOV DX,SI
        INT 21H


        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

        MOV AH,09H
        LEA DX,STR2
        INT 21H

        MOV AH,0AH
        MOV DX,DI
        INT 21H


        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H


;PRINT THE STRING

        MOV AH,09H
        LEA DX,STR11
        INT 21H

        MOV AH,09H
        LEA DX,INSTR1+2
        INT 21H

        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

        MOV AH,09H
        LEA DX,STR22
        INT 21H

        MOV AH,09H
        LEA DX,INSTR2+2
        INT 21H

        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

;STRING COMPARISION
        MOV BX,00

        MOV BL,INSTR1+1
        MOV BH,INSTR2+1

        CMP BL,BH
        JNE L1

        ADD SI,2
        ADD DI,2

      L2:MOV BL,BYTE PTR[SI]
        CMP BYTE PTR[DI],BL
        JNE L1
        INC SI
        INC DI
        CMP BYTE PTR[DI],"$"
        JNE L2

        MOV AH,09H
        LEA DX,MSG1
        INT 21H

        JMP L5

      L1:MOV AH,09H
        LEA DX,MSG2
        INT 21H



     L5:
        MOV AH,09H
        LEA DX,NEWLINE
        INT 21H

        MOV AH,4CH
        INT 21H


CODE ENDS
END START

ret




