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
	goto	start
	
	; ******* Main programme ****************************************

	
start	call	allhigh
	call	delay
	call	shape
	call	delay
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
	
shape	movlw   0x00	    ; PORTE all outputs
	movwf	TRISE
	movlw	0x00
	movwf	PORTE	    ; set WR to low
	
	call	delay
	
	movlw   0x00	    ; PORTD all outputs
	movwf	TRISD
	movlw	0xAB	    ; input data
	movwf	PORTD
	
	call	delay
	
	movlw	0x80
	movwf	PORTE	    ; set WR to high
	
	call	delay
	return
	
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

	end