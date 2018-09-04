.include "./m328Pdef.inc"
    Start:
        ldi r16,0b11111111
        ldi r17,0b00011000
        ldi r18,0b00000110
        ldi r19,0b00000000
        out DDRB,r16
        out DDRD,r19
        ;sub r17,r18
        rjmp Menu

    Menu:
        in r20, PinD
        sbrs r20,7
        rjmp MostrarBajo
        rjmp MostrarAlto
    
    MostrarBajo:
        out PortB , r17
        rjmp Menu
    MostrarAlto:
        ;swap r17
        out PortB , r18
        ;swap r17
        rjmp Menu