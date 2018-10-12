	#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	
	
	goto	start
	; ******* My data and where to put it in RAM 
start	movlw	0x0
movwf	TRISE, ACCESS ; Port E all outputs
	movlw	0x0
movwf	TRISD, ACCESS ; Port E all outputs
	
movlw	0x8E
movwf	0xF84
	
loop	movlw   0x01  ; Clock with period of 374ns
	movwf   PORTD
	movlw   0x0
	movwf   PORTD
	bra loop
	
	end 