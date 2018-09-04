.include "./m328Pdef.inc"

    Start:
  
        ldi r16,0b00000001 ;este registro es el byte 0 num1
        ldi r17,0b00000010 ;este registro es el byte 1 num1
        ldi r18,0b00000100 ;este registro es el byte 2 num1
        ldi r19,0b00001000 ;este registro es el byte 3 num1
        ldi r20,0b11111111 ;este registro es el byte 0 num2
        ldi r21,0b00011111 ;este registro es el byte 1 num2
        ldi r22,0b00001111 ;este registro es el byte 2 num2
        ldi r23,0b00100000 ;este registro es el byte 3 num2
        ldi r24,0b10000000 ;este registro temp guarda los signos
        ; bit 0 ->num1  bit 1 -> num2
        ldi r25,0b10000000; registro temp para mostrar nibles de los Bytes
        ldi r27,0b11110000 ; Para asignar puertoC que recibe botones
        ldi r28,0b11111111 ; Para asignar como salida a puertos B y D

        out DDRC, r27
        out DDRB, r28
        out DDRD, r28
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
