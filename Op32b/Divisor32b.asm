.include "./m328Pdef.inc"


        Start:

                lds r2, 0b00000000  ; BBytee 0 result
                lds r3, 0b00000000  ; BBytee 1 result
                lds r4, 0b00000000  ; BBytee 2 result
                lds r5, 0b00000000  ; BBytee 3 result

                ldi r26, 0b00000001  ; BBytee 0 add
                lds r7, 0b00000000  ; BBytee 1 add
                lds r8, 0b00000000  ; BBytee 2 add
                lds r9, 0b00000000  ; BBytee 3 add

                lds r10, 0b00000000 ; BBytee 0 temporal C
                lds r11, 0b00000000 ; BBytee 1 temporal C
                lds r12, 0b00000000 ; BBytee 2 temporal C
                lds r13, 0b00000000 ; BBytee 3 temporal C


                ldi r16,0b11111111 ;este registro es el BBytee 0 A
                ldi r17,0b11111111 ;este registro es el BBytee 1 A
                ldi r18,0b11111111 ;este registro es el BBytee 2 A
                ldi r19,0b00000000 ;este registro es el BBytee 3 A
        
                ldi r20,0b11111111 ;este registro es el BBytee 0 B
                ldi r21,0b00000001 ;este registro es el BBytee 1 B
                ldi r22,0b00000000 ;este registro es el BBytee 2 B
                ldi r23,0b00000000 ;este registro es el BBytee 3 B


                ldi r24,0b00000000 ; signos bit 0 para A , bit 1 para B
                
                ldi r29, 0b00000000 ; registro temporal para mostrar nibles
                ldi r30, 0b11111111 ;

                out DDRC, r29;Configuracion puerto C como entrada
                out DDRB, r30;Configuracion puerto B como salida, este muestra nible alto de respuesta
                out DDRD, r30;Configuracion puerto D como salida, este muestra nible bajo de respuesta
                ldi r30,0b00000000;
;           __           __
;      (___()'`;    (___()'`; Ladralo x2
;      /,    /`     /,    /`
;      \\"--\\      \\"--\\

        cpA1: 
                cpi r19,0b00000000
                BREQ cpA2; BBytee3 = 0
                rjmp cpB1

        cpA2:
                cpi r18,0b00000000
                BREQ cpA3; BBytee2 = 0
                rjmp cpB1

        cpA3:
                cpi r17,0b00000000
                BREQ cpA4; BBytee1 = 0
                rjmp cpB1

        cpA4:
                cpi r16,0b00000000
                BREQ NumA0
                rjmp cpB1

        cpB1:
                cpi r23,0b00000000
                BREQ cpB2; BBytee3 = 0
                rjmp Divi

        cpB2:
                cpi r22,0b00000000
                BREQ cpB3; BBytee2 = 0
                rjmp Divi

        cpB3:
                cpi r21,0b00000000
                BREQ cpB4; BBytee1 = 0
                rjmp Divi

        cpB4:
                cpi r20,0b00000000
                BREQ NumA0
                rjmp Divi
     
        NumA0:
                ;aqui hay que poner el procedimiento de lo que pasa si el A es 0
                ;Se pone el resultado y residuo como 0
                ;Pero ya están seteados los registros
                ;Entonces deje así

                rjmp Menu

        Divi:
                mov r10, r20 ; move B to C
                mov r11, r21
                mov r12, r22
                mov r13, r23
                rjmp While1
        
        While1:
                cp r19,r13
                brlo SalirWhile; si A < C
                breq While2; si A = C
                brsh AddC; si A > C
        
        While2:
                cp r18,r12
                brlo SalirWhile; si A < C
                breq While3; si A = C
                brsh AddC; si A > C

        While3:
                cp r17,r11
                brlo SalirWhile; si A < C
                breq While4; si A = C
                brsh AddC; si A > C

        While4:
                cp r16,r10
                brlo SalirWhile; si A < C
                breq AddC ; si A = C
                brsh AddC; si A > C

        AddC: ; C = C + B
                clc
                add r10, r20
                adc r11, r21
                adc r12, r22
                adc r13, r23
                rjmp AddResult

        AddResult:
                clc ; Result ++
                add r2, r26
                adc r3, r7
                adc r4, r8
                adc r5, r9
                rjmp While1
                
        SalirWhile:
                        
                sub r10,r20 ; C = C - B
                sbc r11,r21
                sbc r12,r22
                sbc r13,r23
                 ; A = resuduo 
                sub r16,r10 ; A = A - C
                sbc r17,r11 ; A = A - (C-B)
                sbc r18,r12
                sbc r19,r13

                rjmp Menu
        
        Menu:
                in r30, PinC ; Toma las estradas del pin C
                ;ldi r30, 0b11111110

                sbrs r30,0
                rjmp BBytee0; entra si el boton 1 está presionado
                sbrs r30,1
                rjmp BBytee1; entra si el boton 2 está presionado
                sbrs r30,2
                rjmp BBytee2; entra si el boton 3 está presionado
                sbrs r30,3
                rjmp BBytee3; entra si el boton 4 está presionado
                jmp Menu

        BBytee0:
                sbrs r30,1
                rjmp BBytee4; entra si el boton 2 está presionado
                sbrs r30,2
                rjmp BBytee6; entra si el boton 3 está presionado
                
                mov r29,r2
                swap r29
                ; r29 se utiliza para mostrar el BBytee0
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee1:
                sbrs r30,3
                rjmp BBytee7; entra si el boton 4 está presionado
                
                mov r29,r3
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee2:
                sbrs r30,3
                rjmp BBytee5; entra si el boton 4 está presionado

                mov r29,r4
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee3:
                mov r29,r5
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee4:
                mov r29,r16
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee5:
                mov r29,r17
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee6:
                mov r29,r18
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
        BBytee7:
                mov r29,r19
                swap r29
                ; r29 se utiliza para mostrar el número
                out PortB, r29
                out portD, r29
                rjmp Menu
                


