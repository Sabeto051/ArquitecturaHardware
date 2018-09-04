.include "./m328Pdef.inc"

    Start:

        ldi r16,0b11111111
        ldi r17,0b00000000
        ldi r18,0b00001010
        out DDRB,r16
        inc r17
        inc r17
        inc r17
        inc r17
        in r20, PortD
        jmp Quiai
    
    Quiai:
        out PortB,r17
        
        jmp Quiai