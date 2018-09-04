.include "./m328Pdef.inc"


    Start:

        clh; inicializa la bandera de half carry en 0
        clc ;inicializa la bandera de carry en 0    
        ldi r16,0b00011111 ;este registro es el byte 0 A
        ldi r17,0b00000000 ;este registro es el byte 1 A
        ldi r18,0b00010000 ;este registro es el byte 2 A
        ldi r19,0b01000000 ;este registro es el byte 3 A
        ldi r20,0b11111111 ;este registro es el byte 0 B
        ldi r21,0b00011111 ;este registro es el byte 1 B
        ldi r22,0b00001111 ;este registro es el byte 2 B
        ldi r23,0b10000000 ;este registro es el byte 3 B
        ldi r24,0b00000000 ;este registro temp guarda los signos de ambos numeros, en los bits 0 y 1 --- en el bit 7 0 si A es mayor, 1 si B es mayor --- en el bit 6 0 si A y B son diferentes, 1 si A y B son iguales

    ;cp1: ;compara A3 con B3
        cp r19,r23;
        BREQ cp2; A3=B3 -> cp1 para comparar A2 vs B2
        BRMI B_mayor
        BRPL A_mayor
        

    cp2:
      cp r18,r22; compara A2 con B2
       BREQ cp3; A2=B2 -> cp2 para comparar A1 vs B1
       BRMI B_mayor
      BRPL A_mayor

    cp3:
      cp r17,r21; compara A1 con B1
      BREQ cp4; A2=B2 -> cp2 para comparar A1 vs B1
      BRMI B_mayor
      BRPL A_mayor
    

    cp4:
       cp r16,r20; compara A0 con B0
      BREQ iguales ; Definitivamente A=B
      BRMI B_mayor
     BRPL A_mayor
    


    B_mayor:
        ;poner 1 en bit 7 de r24
        SET
        BLD r24,7
        JMP Operacion

    A_mayor:
        ;0 en el bit7 de r24
        CLT
        BLD r24,7
        JMP Operacion

    iguales:
        ;poner 1 en bit 6 de r24
        SET
        BLD r24,6
        JMP Operacion


    Operacion:





