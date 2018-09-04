.include "./m328Pdef.inc"

    Start:
        ldi r16 , 0b10100101
        ldi r17 , 0b00000000
        ldi r18 , 0b00000010
        ldi r19 , 0b11111111

        out DDRD,r17

        in r20, PinD
        sbrs r20,6
        rjmp MostrarAlto
        rjmp MostrarBajo
        

    MostrarBajo:
        out DDRB,r19
        out PortB , r16
        jmp Start
    
    MostrarAlto:
        out DDRB,r19
        swap r16
        out PortB, r16
        swap r16
        jmp Start