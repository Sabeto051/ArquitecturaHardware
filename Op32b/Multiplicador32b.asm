.include "./m328Pdef.inc"

   Start:           
   
       clh; inicializa la bandera de half carry en 0
       clc ;inicializa la bandera de carry en 0  
       lds r2, 0b00000000  ; byte 0 rfinal
       lds r3, 0b00000000  ; byte 1 rfinal
       lds r4, 0b00000000  ; byte 2 rfinal
       lds r5, 0b00000000  ; byte 3 rfinal
       lds r6, 0b00000000  ; byte 4 rfinal
       lds r7, 0b00000000  ; byte 5 rfinal
       lds r8, 0b00000000  ; byte 6 rfinal
       lds r9, 0b00000000  ; byte 7 rfinal
       lds r10, 0b00000000 ; byte 0 temporal
       lds r11, 0b00000000 ; byte 1 temporal
       lds r12, 0b00000000 ; byte 2 temporal
       lds r13, 0b00000000 ; byte 3 temporal
       lds r14, 0b00000000 ; byte 4 temporal
       lds r15, 0b00000000 ; byte 5 temporal
       ldi r16, 0b00000000 ; byte 6 temporal
       ldi r17, 0b00000000 ; byte 7 temporal
       ldi r21, 0b11111111 ; byte 0 NumeroA
       ldi r20, 0b11111111 ; byte 1 NumeroA
       ldi r19, 0b11111111 ; byte 2 NumeroA
       ldi r18, 0b00000000 ; byte 3 NumeroA
       ldi r25, 0b11111111 ; byte 0 NumeroB
       ldi r24, 0b11111111 ; byte 1 NumeroB  
       ldi r23, 0b11111111 ; byte 2 NumeroB
       ldi r22, 0b00000000 ; byte 3 NumeroB  
       ldi r26, 0b00000000 ; registro contador de correrdor
       ldi r27, 0b00000000 ; registro límite de corredor
       ldi r28, 0b00000000 ; registro temporal para la primera mult
       ldi r29, 0b00000000 ; registro temporal para mostrar nibles
       ldi r30, 0b11111111 ;

       out DDRC, r29;Configuracion puerto C como entrada
       out DDRB, r30;Configuracion puerto B como salida, este muestra nible alto de respuesta
       out DDRD, r30;Configuracion puerto D como salida, este muestra nible bajo de respuesta

      
       rjmp Mult01

;           __           __
;      (___()'`;    (___()'`; Ladramelo x2
;      /,    /`     /,    /`
;      \\"--\\      \\"--\\

;========================= BEDOMASTER ========================               
   Mult01:
       mul r21, r25
       mov r11, r1
       mov r10, r0
       rcall Sumar
       rjmp Mult02
   Mult02:
       mul r20, r25
       mov r12, r1
       mov r11, r0
       rcall Sumar
       rjmp Mult03
   Mult03:
       mul r19, r25
       mov r13, r1
       mov r12, r0
       rcall Sumar
       rjmp Mult04
   Mult04:
       mul r18, r25
       mov r14, r1
       mov r13, r0
       rcall Sumar
       rjmp Mult05   
   Mult05:
       mul r21, r24
       mov r12, r1
       mov r11, r0
       rcall Sumar
       rjmp Mult06
   Mult06:
       mul r20, r24
       mov r13, r1
       mov r12, r0
       rcall Sumar
       rjmp Mult07

   ;---------------------------------------NICOMAN-------------------------------------------  
   Mult07: 
       mul r19, r24
       mov r13, r0
       mov r14, r1
       rcall Sumar
       rjmp Mult08
   Mult08:
       mul r18, r24
       mov r14, r0
       mov r15, r1
       rcall Sumar
       rjmp Mult09       
   Mult09:
       mul r21, r23
       mov r12, r0
       mov r13, r1
       rcall Sumar
       rjmp Mult10
   Mult10:
       mul r20, r23
       mov r13, r0
       mov r14, r1
       rcall Sumar
       rjmp Mult11
   Mult11:
       mul r19, r23
       mov r14, r0
       mov r15, r1
       rcall Sumar
       rjmp Mult12

   ; ✢ ✥ ✦ ✧ ❂ ❉ ✱ ✲ ✴ ✵ ✶ ✷ ✸ ❇ ✹ HOLA :V ✢ ✥ ✦ ✧ ❂ ❉ ✱ ✲ ✴ ✵ ✶ ✷ ✸ ❇ ✹
  
   Mult12:
   mul r18,r23   
   mov r15, r0
   mov r16, r1
   rcall Sumar
   rjmp Mult013
   
   Mult013:
   mul r21,r22   
   mov r13, r0
   mov r14, r1
   rcall Sumar
   rjmp Mult14

   Mult14:
   mul r20,r22   
   mov r14,r0
   mov r15, r1
   rcall Sumar
   rjmp Mult15

   Mult15:
   mul r19,r22   
   mov r15, r0
   mov r16, r1
   rcall Sumar
   rjmp Mult16

   Mult16:
   mul r18,r22   
   mov r16, r0
   mov r17, r1
   rcall Sumar

   rjmp Menu

   Sumar:
      
       clc ;inicializa la bandera de carry en 0  
       add r2, r10 ;r2 += r10
       adc r3, r11 ;r3 += r11
       adc r4, r12 ;r4 += r12
       adc r5, r13 ;r5 += r13
       adc r6, r14 ;r6 += r14
       adc r7, r15 ;r7 += r15
       adc r8, r16 ;r8 += r16
       adc r9, r17 ;r9 += r17
       clr r10
       clr r11
       clr r12
       clr r13
       clr r14
       clr r15
       clr r16
       clr r17
       ret       

   Menu:
       in r30, PinC ; Toma las estradas del pin C

       sbrs r30,0
       rjmp Byte0; entra si el boton 1 está presionado
       sbrs r30,1
       rjmp Byte1; entra si el boton 2 está presionado
       sbrs r30,2
       rjmp Byte2; entra si el boton 3 está presionado
       sbrs r30,3
       rjmp Byte3; entra si el boton 4 está presionado
       jmp Menu

  Byte0:
       sbrs r30,1
       rjmp Byte4; entra si el boton 2 está presionado
       sbrs r30,2
       rjmp Byte6; entra si el boton 3 está presionado
      
      mov r29,r2
      swap r29
      ; r29 se utiliza para mostrar el Byte0
      out PortB, r29
      out portD, r29
      rjmp Menu
  Byte1:
       sbrs r30,3
       rjmp Byte7; entra si el boton 4 está presionado
      
      mov r29,r3
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
  Byte2:
       sbrs r30,3
       rjmp Byte5; entra si el boton 4 está presionado

      mov r29,r4
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
  Byte3:
      mov r29,r5
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
   Byte4:
      mov r29,r6
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
   Byte5:
      mov r29,r7
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
   Byte6:
      mov r29,r8
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
   Byte7:
      mov r29,r9
      swap r29
      ; r29 se utiliza para mostrar el número
      out PortB, r29
      out portD, r29
      rjmp Menu
  

;           __
;        __/o \_
;        \____  \
;            /   \
;      __   //\   \
;   __/o \-//--\   \_/
;   \____  ___  \  |
;        ||   \ |\ |
;       _||   _||_||   



