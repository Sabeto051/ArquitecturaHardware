.include "./m328Pdef.inc"


   Start:

       clh; inicializa la bandera de half carry en 0
       clc ;inicializa la bandera de carry en 0   
       ldi r16,0b00000001 ;este registro es el byte 0 A
       ldi r17,0b00000000 ;este registro es el byte 1 A
       ldi r18,0b01010000 ;este registro es el byte 2 A
       ldi r19,0b00000000 ;este registro es el byte 3 A
       ldi r20,0b00000000 ;este registro es el byte 0 B
       ldi r21,0b00000000 ;este registro es el byte 1 B
       ldi r22,0b00010000 ;este registro es el byte 2 B
       ldi r23,0b00000000 ;este registro es el byte 3 B
       ldi r24,0b00000001 ;este registro temp guarda los signos de ambos numeros, en los bits 0 y 1 --- en el bit 7 0 si A es mayor, 1 si B es mayor --- en el bit 6 0 si A y B son diferentes, 1 si A y B son iguales

       ldi r25,0b00000000; registro temp para mostrar nibles de los Bytes
       ldi r27,0b11110000 ; Para asignar puertoC que recibe botones
       ldi r28,0b11111111 ; Para asignar como salida a puertos B y D
      
       out DDRC, r27;Configuracion puerto C como entrada
       out DDRB, r28;Configuracion puerto B como salida, este muestra nible alto de respuesta
       out DDRD, r28;Configuracion puerto D como salida, este muestra nible bajo de respuesta

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
       rjmp APos_BNeg

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
       brge AMenosBPosX ;se va a esta branch si el A es mayor que el B y el resultado es positivo
       brlt BMenosANegx ;se va a esta branch si el B es mayor que el A y el resultado es negativo

 
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
       brge BMenosAPosX ;se va a esta branch si el B es mayor que el A y el resultado es positivo
       brlt AMenosBNegX ;se va a esta branch si el A es mayor que el B y el resultado es negativo

   ;-----------------------------------------------------------------------------------------------------------------------------

   ZeroByte3APosBNeg:

       tst r18 ;revisa si el byte 2 del numero A esta vacio
       breq ZeroByte2APos
       rjmp APos_BNegByte2

 
   ZeroByte2APos:
      
       tst r22 ;revisa si el byte 2 del numero B esta vacio
       breq ZeroByte2APosBNeg ;nueva branch si el numero esta vacio, sino sigue
       rjmp APos_BNegByte2

    BMenosANegX:
        rjmp BMenosANeg

    AMenosBPosX:
        rjmp AMenosBPos

   APos_BNegByte2:

       cp r18,r22 ;compara si el numero positivo es mayor al negativo
       brge AMenosBPos ;se va a esta branch si el A es mayor que el B y el resultado es positivo
       brlt BMenosANegX ;se va a esta branch si el B es mayor que el A y el resultado es nega
 

   ZeroByte3ANegBPos:

       tst r18 ;revisa si el byte 2 del numero A esta vacio
       breq ZeroByte2ANeg
       rjmp ANeg_BPosByte2

   ZeroByte2ANeg:
      
       tst r22 ;revisa si el byte 2 del numero B esta vacio
       breq ZeroByte2ANegBPos ;nueva branch si el numero esta vacio, sino sigue
       rjmp ANeg_BPosByte2

    BMenosAPosX:
        rjmp BMenosAPos
    AMenosBNegX:
        rjmp AMenosBNeg

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
       clt
       bld r24,0
       rjmp Menu


   ZeroByte0ANegBPos:

       ;si llego aca, es porque ambos numeros son 0. Entonces, el resultado es el r16 y el signo es positivo
       clt
       bld r24,0
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
       andi r24,0b11111110 ;pone el signo del resultado positivo
       ; El resultado se pasa a los registros de A
       mov r16,r20
       mov r17,r21
       mov r18,r22
       mov r19,r23
       rjmp Menu

   BMenosANeg:

       sub r20,r16
       sbc r21,r17
       sbc r22,r18
       sbc r23,r19
       ori r24,0b00000001 ;pone el signo del resultado negativo
       ; El resultado se pasa a los registros de A
       mov r16,r20
       mov r17,r21
       mov r18,r22
       mov r19,r23
       rjmp Menu

   ;ToDo: Pasar los resultados al registro r16 -- Hecho
   ;ToDo: Los return

   Menu:
       in r26, PinC ; Toma las estradas del pin C
       sbrs r26,0
       rjmp Byte0; entra si el boton 1 está presionado
       sbrs r26,1
       rjmp Byte1; entra si el boton 2 está presionado
       sbrs r26,2
       rjmp Byte2; entra si el boton 3 está presionado
       sbrs r26,3
       rjmp Byte3; entra si el boton 4 está presionado
       jmp Menu

   Byte0:
       mov r25,r16
       swap r25
       ; r25 se utiliza para mostrar el Byte0
       out PortB, r25
       out portD, r25
       rjmp Menu
   Byte1:
       mov r25,r17
       swap r25
       ; r25 se utiliza para mostrar el número
       out PortB, r25
       out portD, r25
       rjmp Menu
   Byte2:
       mov r25,r18
       swap r25
       ; r25 se utiliza para mostrar el número
       out PortB, r25
       out portD, r25
       rjmp Menu
   Byte3:
       mov r25,r19
       swap r25
       ; r25 se utiliza para mostrar el número
       out PortB, r25
       out portD, r25
       rjmp Menu











