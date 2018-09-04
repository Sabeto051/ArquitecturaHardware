.include "./m328Pdef.inc"


    Start:

        clh; inicializa la bandera de half carry en 0
        clc ;inicializa la bandera de carry en 0    
        ldi r16,0b00011111 ;este registro es el byte 0 A
        ldi r17,0b00000000 ;este registro es el byte 1 A
        ldi r18,0b00010000 ;este registro es el byte 2 A
        ldi r19,0b00100000 ;este registro es el byte 3 A
        ldi r20,0b11111111 ;este registro es el byte 0 B
        ldi r21,0b00011111 ;este registro es el byte 1 B
        ldi r22,0b00001111 ;este registro es el byte 2 B
        ldi r23,0b00100000 ;este registro es el byte 3 B
        ldi r24,0b00000000 ;este registro temp guarda los signos de ambos numeros, en los bits 0 y 1 --- en el bit 7 0 si A es mayor, 1 si B es mayor --- en el bit 6 0 si A y B son diferentes, 1 si A y B son iguales


        sbrc r24,0 ;se salta la siguiente linea si bit 0 del registro de signo es cero(el primer numero es positivo)
        rjmp A_Positivo
        rjmp A_Negativo

    A_Negativo:
      
        sbrc r24,1 ;se salta la siguiente linea si bit 1 del registro de signo es cero(el B numero es positivo)
        rjmp ANeg_BPos
        rjmp AB_Negativos

    A_Positivo:

        sbrc r24,1 ;se salta la siguiente linea si bit 1 del registro de signo es cero(el B numero es positivo)
        rjmp AB_Positivos
        rjmp DiferenteSigno

    AB_Negativos:
        
        add r16, r20 ;r16 = r16 +r20, suma los primeros 8 bits
        adc r17, r21 ;r17 = r17 + r21 + carry, suma del bit 8 al 16, modifica bandera carry si hay acarreo
        adc r18, r22 ;r18 = r18 + r22 + carry, suma del bit 16 al 24, modifica bandera carry si hay acarreo
        adc r19, r23 ;r18 = r19 + r23 + carry, suma del bit 24 al 32, modifica bandera carry si hay acarreo
        rjmp Menu

    AB_Positivos:

        add r16, r20 ;r16 = r16 +r20, suma los primeros 8 bits
        adc r17, r21 ;r17 = r17 + r21 + carry, suma del bit 8 al 16, modifica bandera carry si hay acarreo
        adc r18, r22 ;r18 = r18 + r22 + carry, suma del bit 16 al 24, modifica bandera carry si hay acarreo
        adc r19, r23 ;r18 = r19 + r23 + carry, suma del bit 24 al 32, modifica bandera carry si hay acarreo
        rjmp Menu

    APos_BNeg:
        
        tst r19 ;revisa si el byte 3 del numero A esta vacio
        breq ZeroByte3APos ;nueva branch si el numero esta vacio, sino sigue
        rjmp APos_BNegFull

    
    ZeroByte3APos:

        tst r23 ;revisa si el byte 3 del numero B esta vacio
        breq ZeroByte3APosBNeg ;nueva branch si el numero esta vacio, sino sigue
        rjmp APos_BNegFull
        
    
    APos_BNegFull:

        cp r19,r23 ;compara si el numero positivo es mayor al negativo
        brge AMenosBPos ;se va a esta branch si el A es mayor que el B y el resultado es positivo
        brlt BMenosANeg ;se va a esta branch si el B es mayor que el A y el resultado es negativo

    
    ANeg_BPos:        

        tst r19 ;revisa si el byte 3 del numero A esta vacio
        breq ZeroByte3ANeg ;nueva branch si el numero esta vacio, sino sigue
        rjmp ANeg_BPosFull
        

    ZeroByte3ANeg:

        tst r23 ;revisa si el byte 3 del numero B esta vacio
        breq ZeroByte3ANegBPos ;nueva branch si el numero esta vacio, sino sigue
        rjmp ANeg_BPosFull


    ANeg_BPosFull:

        cp r23,r19 ;compara si el numero positivo es mayor al negativo     
        brge BMenosAPos ;se va a esta branch si el B es mayor que el A y el resultado es positivo
        brlt AMenosBNeg ;se va a esta branch si el A es mayor que el B y el resultado es negativo

    ;-----------------------------------------------------------------------------------------------------------------------------

    ZeroByte3APosBNeg:

        tst r18 ;revisa si el byte 2 del numero A esta vacio
        breq ZeroByte2APos
        rjmp APos_BNegByte2

    
    ZeroByte2APos:
        
        tst r22 ;revisa si el byte 2 del numero B esta vacio
        breq ZeroByte2APosBNeg ;nueva branch si el numero esta vacio, sino sigue
        rjmp APos_BNegByte2


    APos_BNegByte2:

        cp r18,r22 ;compara si el numero positivo es mayor al negativo
        brge AMenosBPos ;se va a esta branch si el A es mayor que el B y el resultado es positivo
        brlt BMenosANeg ;se va a esta branch si el B es mayor que el A y el resultado es nega
   

    ZeroByte3ANegBPos:

        tst r18 ;revisa si el byte 2 del numero A esta vacio
        breq ZeroByte2ANeg
        rjmp ANeg_BPosByte2

    ZeroByte2ANeg:
        
        tst r22 ;revisa si el byte 2 del numero B esta vacio
        breq ZeroByte2ANegBPos ;nueva branch si el numero esta vacio, sino sigue
        rjmp ANeg_BPosByte2


    ANeg_BPosByte2:

        cp r22,r18 ;compara si el numero positivo es mayor al negativo     
        brge BMenosAPos ;se va a esta branch si el B es mayor que el A y el resultado es positivo
        brlt AMenosBNeg ;se va a esta branch si el A es mayor que el B y el resultado es negativo

    ;------------------------------------------------------------------------------------------------------------------------------    
     
    ZeroByte2APosBNeg:

        tst r17 ;revisa si el byte 1 del numero A esta vacio
        breq ZeroByte1APos
        rjmp APos_BNegByte1


    ZeroByte1APos:
        
        tst r21 ;revisa si el byte 1 del numero B esta vacio
        breq ZeroByte1APosBNeg ;nueva branch si el numero esta vacio, sino sigue
        rjmp APos_BNegByte1


    APos_BNegByte1:

        cp r17,r21 ;compara si el numero positivo es mayor al negativo
        brge AMenosBPos ;se va a esta branch si el A es mayor que el B y el resultado es positivo
        brlt BMenosANeg ;se va a esta branch si el B es mayor que el A y el resultado es nega


    ZeroByte2ANegBPos:

        tst r17 ;revisa si el byte 1 del numero A esta vacio
        breq ZeroByte1ANeg
        rjmp ANeg_BPosByte1


    ZeroByte1ANeg:
        
        tst r21 ;revisa si el byte 1 del numero B esta vacio
        breq ZeroByte1ANegBPos ;nueva branch si el numero esta vacio, sino sigue
        rjmp ANeg_BPosByte1


    ANeg_BPosByte1:

        cp r21,r17 ;compara si el numero positivo es mayor al negativo     
        brge BMenosAPos ;se va a esta branch si el B es mayor que el A y el resultado es positivo
        brlt AMenosBNeg ;se va a esta branch si el A es mayor que el B y el resultado es negativo

    ;--------------------------------------------------------------------------------------------------------------------------


    ZeroByte1APosBNeg:

        tst r16 ;revisa si el byte 0 del numero A esta vacio
        breq ZeroByte0APos
        rjmp APos_BNegByte0


    ZeroByte0APos:
        
        tst r20 ;revisa si el byte 0 del numero B esta vacio
        breq ZeroByte0APosBNeg ;nueva branch si el numero esta vacio, sino sigue
        rjmp APos_BNegByte0


    APos_BNegByte0:

        cp r16,r20 ;compara si el numero positivo es mayor al negativo
        brge AMenosBPos ;se va a esta branch si el A es mayor que el B y el resultado es positivo
        brlt BMenosANeg ;se va a esta branch si el B es mayor que el A y el resultado es nega


    ZeroByte1ANegBPos:

        tst r16 ;revisa si el byte 0 del numero A esta vacio
        breq ZeroByte0ANeg
        rjmp ANeg_BPosByte0


    ZeroByte0ANeg:
        
        tst r20 ;revisa si el byte 1 del numero B esta vacio
        breq ZeroByte0ANegBPos ;nueva branch si el numero esta vacio, sino sigue
        rjmp ANeg_BPosByte0


    ANeg_BPosByte0:

        cp r20,r16 ;compara si el numero positivo es mayor al negativo     
        brge BMenosAPos ;se va a esta branch si el B es mayor que el A y el resultado es positivo
        brlt AMenosBNeg ;se va a esta branch si el A es mayor que el B y el resultado es negativo

    ;----------------------------------------------------------------------------------------------------------------------------

    ZeroByte0APosBNeg:

        ;si llego aca, es porque ambos numeros son 0. Entonces, el resultado es el r16 y el signo es positivo
        rjmp Menu


    ZeroByte0ANegBPos:

        ;si llego aca, es porque ambos numeros son 0. Entonces, el resultado es el r16 y el signo es positivo
        rjmp Menu

    
    AMenosBPos:

        sub r16,r20
        sbc r17,r21
        sbc r18,r22
        sbc r19,r23
        andi r24,0b11111110 ;pone el signo del resultado positivo
        rjmp Menu

    AMenosBNeg:

        sub r16,r20
        sbc r17,r21
        sbc r18,r22
        sbc r19,r23
        ori r24,0b00000001 ;pone el signo del resultado negativo
        rjmp Menu

    BMenosAPos:

        sub r20,r16
        sbc r21,r17
        sbc r22,r18
        sbc r23,r19
        andi r24,0b11111101 ;pone el signo del resultado positivo
        rjmp Menu

    BMenosANeg:

        sub r20,r16
        sbc r21,r17
        sbc r22,r18
        sbc r23,r19
        ori r24,0b00000010 ;pone el signo del resultado negativoo
        rjmp Menu

    ;ToDo: Pasar los resultados al registro r16
    ;ToDo: Los return
