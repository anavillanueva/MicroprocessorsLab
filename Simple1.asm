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
start	clrf TRISE ; Port E all outputs
	clrf TRISD ; Port D all outputs
	clrf TRISC ; Port C all outputs
	movlw   0x03  ; set p0 and p1 to 1
	movwf   PORTD
	movlw	0x8E
	movwf	0xF84
	
	movlw   0x01  ; Sets clock to low, output still high
	movwf   PORTD
	movlw   0x03  ; Clocks data into memory
	movwf   PORTD
	setf TRISE ; sets PORTE to tri-state
	movlw 0x02
	movwf PORTD ; sets output to low
	movf PORTE, W 
	movwf PORTC
	
loop	movlw   0x01  ; Clock with period of 374ns
	movwf   PORTD
	movlw   0x0
	movwf   PORTD
	bra loop
	
	end 