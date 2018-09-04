.include "./m328Pdef.inc"


    Start:

        clh; inicializa la bandera de half carry en 0
        ldi r16,0b00011101 ;este registro es el numero 1
        ldi r17,0b00011000 ;este registro es el numero 2 para sumarlos
        ldi r18,0b00010000 ;este registro es usado para comparar el signo y carry positivo
        ldi r19,0b00100000 ;este registro es usado para comparar carry de negativos
        ldi r20,0b11111111 ;este registro es para definir el puerto como salida
        ldi r22,0b00001111 ;"Máscara" para positivo a arreglar

        cp r16,r18 ;compara el 16 con el 18
        brge Num1_Negativo ;Branch if r16 mayor o igual al 18 (es negativo)
        brlt Num1_Positivo ;Branch if r16 menor al 18 (es positivo)
        

    Num1_Negativo:
        
        cp r17,r18
        brge Num1Num2_Negativos ;Branch if r17 mayor o igual al 18 (es negativo)
        brlt Num1Neg_Num1Pos ;Branch if r17 menor al 18 (es positivo)

    Num1_Positivo:

        cp r17,r18
        brlt Num1Num2_Positivos ;Branch if r17 menor al 18 (es positivo)
        brge Num1Pos_Num2Neg ;Branch if r17 mayor o igual al 18 (es negativo)

    Num1Num2_Positivos:
    
        add r16,r17 ;r16 = r16 + r17
        bst r16,4 ; toma el bit 5 del resultado de la suma (acarreo) y lo pone en flag t
        bld r16,5 ; carga T y lo pone en bit 6 de el resultado (acarreo)
        clt ; T lo vuelve 0
        bld r16,4 ; a T=0 lo pone en la casilla signo

        jmp Return


    Num1Num2_Negativos:
        and r16,r22 ; bit 5 lo vuelve 0 en r16
        and r17,r22 ; bit 5 lo vuelve 0 en r17
        add r16,r17 ; r16 += r17 
        bst r16,4 ; toma el bit 5 del resultado de la suma (acarreo) y lo pone en flag t
        bld r16,5 ; carga T y lo pone en bit 6 de el resultado (acarreo)
        set ; T lo vuelve 1
        bld r16,4 ; a T=1 lo pone en la casilla signo

        jmp Return
        
    Num1Pos_Num2Neg:
        and r17, r22 ; quito signo al num negativo
        cp r16,r17 ; comparador
        brge AbsNum1_MayorI_Num2C2 ; Branch if abs(num1) mayor o igual al abs(num2) caso 2
        brlt AbsNum1_Menor_Num2C2 ; Branch if abs(num1) menor al abs(num2) caso 2


    Num1Neg_Num1Pos:
        and r16, r22 ; quito signo al num negativo
        cp r17,r16 ; comparador
        brge AbsNum2_MayorI_Num1C1 ; Branch if abs(num2) mayor o igual al abs(num1) caso 1
        brlt AbsNum2_Menor_Num1C1 ; Branch if abs(num2) menor al abs(num1) caso 1
        

    AbsNum1_MayorI_Num2C2:
        ; como el numero negativo es menor, el resultado da positivo
        clt ; T = 0 , guarda signo resultado
        sub r16,r17 ; r16-=r17
        bld r16,4 ; a T=0 lo pone en la casilla signo del resultado
        jmp Return


    AbsNum1_Menor_Num2C2:
        ; como el numero negativo es mayor, el resultado da negativo
        set ; T=1 , guarda signo resultado
        sub r17,r16 ; r17-=r16
        bld r17,4 ; a T=0 lo pone en la casilla signo del resultado
        jmp Return

    AbsNum2_MayorI_Num1C1:
        ; como el numero negativo es menor, el resultado da positivo
        clt ; T = 0 , guarda signo resultado
        sub r17,r16 ; r16-=r17
        bld r17,4 ; a T=0 lo pone en la casilla signo del resultado
        jmp Return


    AbsNum2_Menor_Num1C1:
        ; como el numero negativo es mayor, el resultado da negativo
        set ; T=1 , guarda signo resultado
        sub r16,r17 ; r17-=r16
        bld r16,4 ; a T=0 lo pone en la casilla signo del resultado
        jmp Return



    Return:

        out DDRB,r20 ;setea el puerto d como out
        out PortB,r16 ;saca el registro resultado
        jmp Return



