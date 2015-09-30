LIST P=16F877
;Programa que convierte un voltaje anal�gico por RA0 y lo despliega en el puerto B. Intervalo 0-5V
#include <P16F877.INC>
	TEMP 	EQU 20H
	ORG 	0X00
	GOTO 	START
	ORG 	0X04
	GOTO 	SERVICE_INT
	ORG 	0X10
START	BSF 	STATUS, RP0 	;Banco 01
	MOVLW	0FFH		;PORTA ENTRADAS
	MOVWF	TRISA
	MOVLW	0FFH		;PORTA ENTRADAS
	MOVWF	TRISD
	MOVLW	000H		;PORTB SALIDAS
	MOVWF	TRISB
	BCF	STATUS,RP0	;BANCO 00
	CALL 	INITIALIZEAD	;INICIALIZAR EL AD
	CALL 	SETUPDELAY
	BSF	ADCON0,GO
LOOP
	GOTO LOOP
	;RUTINA DE SERVICIO DE INTERRUPCI�N
SERVICE_INT
	BTFSS	PIR1,ADIF
	RETFIE
	MOVF	ADRESH,W
	MOVWF	PORTB
	MOVF	ADRESL,W
	MOVWF	PORTD
	BCF	PIR1,ADIF
	BSF	INTCON,PEIE
	CALL	SETUPDELAY
	CALL 	SETUPDELAY
	BSF	ADCON0,GO
	RETFIE
	;; INICIALIZAR A/D, AN0-AN3 ENTRADAS ANAL�GICAS, RC CLOCK
INITIALIZEAD
	BSF 	STATUS, RP0	;BANCO 01
	MOVLW	B'00000100'	;A0,1,3 ANAL�GICO
	;; A2,4,5,6,7 DIGITALES
	MOVWF	ADCON1
	BSF	PIE1,ADIE	;HABILITA LA INTERRUPCI�N
	BCF	STATUS,RP0	;REGRESAR AL BANCO 0
	MOVLW	0C1H		;CONFIGURAR EL ADCON0 CON JUSTIFICACI�N IZQUIERDA, FRECUENCIA OSCILADOR INTERNO, CANAL DE LECTURA , HABILITAR LA CONVERSI�N
	MOVWF	ADCON0
	BCF	PIR1,ADIF	;LIMPIAR LA BANDERA
	BSF	INTCON,PEIE	;HABILITAR LA INTERRUPCI�N POR PERIF�RICO
	BSF	INTCON,GIE	;HABILITAR LA INTERRUPCIONES GENERALES
	RETURN
	;; RUTINA DE RETARDO
SETUPDELAY
	MOVLW	.3		;UN DELAY DE 12 uS
	MOVWF	TEMP
SD
	DECFSZ	TEMP,F
	GOTO SD
	RETURN
	END
	