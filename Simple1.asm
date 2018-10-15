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
	
	call subroutine
	
	clrf TRISD ; Port D all outputs
	clrf TRISC ; Port C all outputs
	movlw   0x0F  ; set p0 and p1 to 1
	movwf   PORTD
	movlw	0x8E
	movwf	0xF84
	
	movlw   0x0D  ; Sets clock1 to low, output1 still high
	movwf   PORTD
	movlw   0x0F  ; Clocks data into memory
	movwf   PORTD
	setf TRISE ; sets PORTE to tri-state
	movlw 0x0E
	movwf PORTD ; sets output1 to low
	movf PORTE, W 
	movwf PORTC
	movlw 0x0F
	movwf PORTD ; sets output1 to high
	
call subroutine
	
	clrf TRISE ; Port E all outputs
	movlw	0x8F
	movwf	0xF84
	
	movlw   0x07  ; Sets clock2 to low, output2 still high
	movwf   PORTD
	movlw   0x0F  ; Clocks data into memory
	movwf   PORTD
	setf TRISE ; sets PORTE to tri-state
	movlw 0x0B
	movwf PORTD ; sets output2 to low
	movf PORTE, W 
	movwf PORTC
	movlw 0x0F
	movwf PORTD ; sets output2 to high
	
	bra start
	
loop	movlw   0x01  ; Clock with period of 374ns
	movwf   PORTD
	movlw   0x0
	movwf   PORTD
	bra loop
	
subroutine
movlw 0xFF
movwf 0x10

counting  
	movwf	0x10
	call subsubroutine
	decfsz 0x10, W
	bra counting
	return
	
subsubroutine
movlw 0xFF
movwf 0x11
subcounting  

	movwf	0x11
	decfsz 0x11, W
	bra subcounting
	return
	
	
	end 