	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex			    ; external LCD subroutines
	
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

 
tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup

pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "Hello World!\n"	; message, plus carriage return
	constant    myTable_l=.2	; length of data
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	movlw   0x00	    ; PORTE all outputs
	movwf	TRISE
	movlw   0x00	    ; PORTD all outputs
	movwf	TRISD
	movlw   0x01
	goto	start
	
	; ******* Main programme ****************************************
	
start	;movlw   b'00000000'
	call	output
	addlw	0x01
	
	;addlw	0x01
	
	goto	start
	
	

	
output	; Value to output stored in W

	bcf	PORTE , 7	    ; set WR to low
	
	call	delay
	call	delay

	movwf	PORTD
	
	call	delay

	bsf	PORTE , 7	    ; set WR to high
	
	call	delay
	call	delay
	return
	
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return
	
allhigh	movlw   0x00	    ; PORTE all outputs
	movwf	TRISE
	movlw	0x00
	movwf	PORTE	    ; set WR to low
	
	call	delay
	
	movlw   0x00	    ; PORTD all outputs
	movwf	TRISD
	movlw	0xFF	    ; input data
	movwf	PORTD
	
	call	delay
	
	movlw	0x80
	movwf	PORTE	    ; set WR to high
	
	call	delay
	return
	
	movlw   b'00000001'
	call	output
	movlw   b'00000010'
	call	output
	movlw   b'00000100'
	call	output
	movlw   b'00001000'
	call	output
	movlw   b'00010000'
	call	output
	movlw   b'00100000'
	call	output
	movlw   b'01000000'
	call	output
	movlw   b'10000000'
	call	output
	movlw   0xFF
	call	output
	movlw   b'10000000'
	call	output
	movlw   b'01000000'
	call	output
	movlw   b'00100000'
	call	output
	movlw   b'00010000'
	call	output
	movlw   b'00001000'
	call	output
	movlw   b'00000100'
	call	output
	movlw   b'00000010'
	call	output
	movlw   b'00000001'
	call	output
	end