.include "./m328Pdef.inc"
	start:
        ldi		r16,0x00 ; ARH Byte 0
		ldi		r17,0x00 ; ARL Byte 1
        ldi		r18,0x00 ; Contador
		ldi 	r19,0x14 ; N-Max (20)
		ldi     r20,0x00 ; A Byte0
        ldi     r21,0x00 ; A Byte1
		ldi     r22,0x00 ; AA Byte0
        ldi     r23,0x00 ; AA Byte1
		ldi     r24,0x00 ; T Byte0
        ldi     r25,0x00 ; T Byte1
		rjmp Previo
	
	Previo:
		rcall 	EEPROM_write0 ; escribe el primer numero de la serie (0) - Byte0
		inc 	r17 ; siguiente posición en la EEPROM
		rcall 	EEPROM_write1 ; escribe el primer numero de la serie (0) - Byte1
		inc 	r17 ; siguiente posición en la EEPROM
		inc 	r18 ; contador += 1

		inc		r20		
		rcall 	EEPROM_write0 ; escribe el segundo numero de la serie (1) - Byte0
		inc 	r17 ; siguiente posición en la EEPROM
		rcall 	EEPROM_write1 ; escribe el segundo numero de la serie (1) - Byte1
		inc 	r17 ; siguiente posición en la EEPROM
		inc 	r18 ; contador += 1

		; como ya se tienen los primeros 2 numeros, ya se puede hallar
		; los seguientes numeros de la serie con la suma de los dos anteriores
		rjmp 	CalcularFibo
	
	CalcularFibo:
		cp 		r18,r19 ; compara contador con N-Max
		breq 	FiboTerminado ; Branch si contador = 20 (N-Max)
		clc 	; clear carry
		; se calcula el sig numero sobre escribiendo el anterior
		add 	r22,r20 ; calcula Byte0 sig numero
		adc 	r23,r21 ; calcula Byte1 sig numero
		rcall 	ActualizarRegistros

		rcall 	EEPROM_write0 ; escribe el siguinte numero de la serie - Byte0
		inc 	r17 ; siguiente posición en la EEPROM
		rcall 	EEPROM_write1 ;  escribe el siguinte numero de la serie - Byte1
		inc 	r17 ; siguiente posición en la EEPROM

		inc 	r18 ; contador += 1
		rjmp	CalcularFibo


	
	ActualizarRegistros:
		; como el siguiente numero está en AA, se intercambia con A
		; T = AA
		mov 	r24,r22
		mov 	r25,r23
		; AA = A
		mov 	r22,r20
		mov 	r23,r21
		; A = T
		mov 	r20,r24
		mov 	r21,r25
		ret

	EEPROM_write1:
		; Wait for completion of previous write
		sbic 	EECR,EEPE
		rjmp 	EEPROM_write1
		; Set up address (r16:r17) in address register
		out     EEARH, r16
		out     EEARL, r17
		; Write data (r20) to Data Register
		out     EEDR,r20
		; Write logical one to EEMPE
		sbi     EECR,EEMPE
		; Start eeprom write by setting EEPE
		sbi     EECR,EEPE
		ret
	EEPROM_write0:
		; Wait for completion of previous write
		sbic     EECR,EEPE
		rjmp     EEPROM_write0
		; Set up address (r16:r17) in address register
		out     EEARH, r16
		out     EEARL, r17
		; Write data (r21) to Data Register
		out     EEDR,r21
		; Write logical one to EEMPE
		sbi     EECR,EEMPE
		; Start eeprom write by setting EEPE
		sbi     EECR,EEPE
		ret

	FiboTerminado:
		inc r18


	EEPROM_read:
		; Wait for completion of previous write 
		sbic	EECR,EEPE 
		rjmp	EEPROM_read
		; Set up address (r16:r17) in address register
		out     EEARH, r16
		out     EEARL, r17
		; Start eeprom read by writing EERE
		sbi     EECR,EERE
		; Read data from Data Register
		in      r19,EEDR
		ret