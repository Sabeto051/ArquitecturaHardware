.include "./m328Pdef.inc"

        Start:

                lds r2, 0b00000000  ; byte 0 result
                lds r3, 0b00000000  ; byte 1 result
                lds r4, 0b00000000  ; byte 2 result
                lds r5, 0b00000000  ; byte 3 result

                lds r6, 0b00000000  ; byte 0 residio
                lds r7, 0b00000000  ; byte 1 residuo
                lds r8, 0b00000000  ; byte 2 residuo
                lds r9, 0b00000000  ; byte 3 residuo

                lds r10, 0b00000000 ; byte 0 temporal C
                lds r11, 0b00000000 ; byte 1 temporal C
                lds r12, 0b00000000 ; byte 2 temporal C
                lds r13, 0b00000000 ; byte 3 temporal C


                ldi r16,0b00011111 ;este registro es el byte 0 A
                ldi r17,0b00000000 ;este registro es el byte 1 A
                ldi r18,0b00010000 ;este registro es el byte 2 A
                ldi r19,0b00100000 ;este registro es el byte 3 A
        
                ldi r20,0b11111111 ;este registro es el byte 0 B
                ldi r21,0b00011111 ;este registro es el byte 1 B
                ldi r22,0b00001111 ;este registro es el byte 2 B
                ldi r23,0b00100000 ;este registro es el byte 3 B


                ldi r24,0b00000000 ; signos bit 0 para A , bit 1 para B



        cpA1: 
                cpi r19,0b00000000
                BREQ cpA2; byte3 = 0
                rjmp cpB1

        cpA2:
                cpi r18,0b00000000
                BREQ cpA3; byte2 = 0
                rjmp cpB1

        cpA3:
                cpi r17,0b00000000
                BREQ cpA4; byte1 = 0
                rjmp cpB1

        cpA4:
                cpi r16,0b00000000
                BREQ NumA0    
                rjmp cpB1

        cpB1:
                cpi r23,0b00000000
                BREQ cpB2; byte3 = 0
                rjmp divi

        cpB2:
                cpi r22,0b00000000
                BREQ cpA3; byte2 = 0
                rjmp divi

        cpB3:
                cpi r21,0b00000000
                BREQ cpA4; byte1 = 0
                rjmp divi

        cpB4:
                cpi r20,0b00000000
                BREQ NumA0    
                rjmp divi
     
        NumA0:
                ;aqui hay que poner el procedimiento de lo que pasa si el A es 0
                ;Se pone el resultado y residuo como 0
                ;Pero ya están seteados los registros
                ;Entonces deje así


