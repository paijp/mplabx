	list p=16f887
	#include "p16f887.inc"
	__config	_CONFIG1, _DEBUG_OFF & _LVP_OFF & _FCMEN_OFF & _IESO_OFF & _BOR_ON & _CPD_ON & _CP_ON & _MCLRE_OFF & _PWRTE_ON & _WDT_OFF & _INTOSCIO
	__config	_CONFIG2, _WRT_OFF & _BOR40V


PORTA_LED	equ	0


work0	equ	0x20
work1	equ	0x21
work2	equ	0x22


	org	0
	goto	init


wait1ms
	clrf	work0
wait1ms_loop
	nop
	nop
	
	nop
	nop
	
	nop
	decfsz	work0, 1
	goto	wait1ms_loop
	retlw	0

wait10ms
	movlw	0xa
	movwf	work1
	goto	wait100ms_loop
wait50ms
	movlw	0x32
	movwf	work1
	goto	wait100ms_loop
wait100ms
	movlw	0x64
	movwf	work1
wait100ms_loop
	call	wait1ms
	decfsz	work1, 1
	goto	wait100ms_loop
	retlw	0


initport
	clrf	STATUS			; RP0
	
	movlw	0			; ra: 00000000
	movwf	PORTA
	movlw	0			; rb: 00000000
	movwf	PORTB
	movlw	0			; rc: 00000000
	movwf	PORTC
	movlw	0			; rd: 00000000
	movwf	PORTD
	movlw	0			; re: ----0000
	movwf	PORTE
	
	bsf	STATUS, RP0
	
	movlw	0x71			; 8MHz INTOSC
	movwf	OSCCON - 0x80
	
	movlw	0			; ra: OOOOOOOO
	movwf	PORTA
	movlw	0			; rb: OOOOOOOO
	movwf	PORTB
	movlw	0			; rc: OOOOOOOO
	movwf	PORTC
	movlw	0			; rd: OOOOOOOO
	movwf	PORTD
	movlw	8			; re: ----IOOO
	movwf	PORTE
	
	movlw	8			; rbpu TMR0: 1/1
	movwf	OPTION_REG - 0x80
	
	bsf	STATUS, RP1
	
	movlw	0			; ra: DDDDDDDD
	movwf	ANSEL - 0x180
	movlw	0			; rb: DDDDDDDD
	movwf	ANSELH - 0x180
	
	bcf	STATUS, RP0
	bcf	STATUS, RP1
	
	retlw	0


init
	clrf	STATUS
	call	initport
	
main
	call	wait100ms
	bsf	PORTA, PORTA_LED
	
	call	wait100ms
	bcf	PORTA, PORTA_LED
	
	goto	main


	end

