	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message  ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message, LCD_clear, LCD_Bottom, LCD_Top    ; external LCD subroutines
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup
	

	
	
pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
	
outputs	data "147A2580369BFEDC "
	constant    length=.2	; length of data
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	bsf	PADCFG1, RDPU
	clrf	LATD
	goto	input
	
	
	
	; ******* Main programme ****************************************
	
input 	movlw	upper(outputs)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(outputs)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(outputs)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	call	delay
	
	
	movlw   b'11110000'
	movwf   PORTD
	movlw   b'00001111'	    ; PORTD all inputs
	movwf	TRISD
	
	call	delay
	
	movlw	0xF1
	call	delay
	CPFSEQ	PORTD, ACCESS	    ; Compare PORTD input to W, skip if not equal
	goto	COL2
	
	call	delay		    ; Allow time to change PORTD	
	
	movlw   b'00001111'
	movwf   PORTD
	movlw   b'11110000'	    ; PORTD all inputs
	movwf	TRISD
	
	call	delay

	btfsc	PORTD, 4
	movlw	0x00
	
	btfsc	PORTD, 5
	movlw	0x01
	
	btfsc	PORTD, 6;
	movlw	0x02

	btfsc	PORTD, 7;
	movlw	0x03
	
	addwf	TBLPTR, 1, ACCESS
	call	delay
	
	call	LCD_Top
	movlw	length-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	call	delay
	
	goto    input
	
COL2
	movlw	0xF2
	call	delay
	CPFSEQ	PORTD, ACCESS	    ; Compare PORTD input to W, skip if not equal
	goto	COL3
	
	call	delay		    ; Allow time to change PORTD	
	
	movlw   b'00001111'
	movwf   PORTD
	movlw   b'11110000'	    ; PORTD all inputs
	movwf	TRISD
	
	call	delay
	
	btfsc	PORTD, 4
	movlw	0x04
	
	btfsc	PORTD, 5
	movlw	0x05
	
	btfsc	PORTD, 6;
	movlw	0x06

	btfsc	PORTD, 7;
	movlw	0x07
	
	addwf	TBLPTR, 1, ACCESS
	call	delay
	
	call	LCD_Top
	movlw	length-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	call	delay
	
	goto	input
	
	
COL3
	movlw	0xF4
	call	delay
	CPFSEQ	PORTD, ACCESS	    ; Compare PORTD input to W, skip if not equal
	goto	COL4
	
	call	delay		    ; Allow time to change PORTD	
	
	movlw   b'00001111'
	movwf   PORTD
	movlw   b'11110000'	    ; PORTD all inputs
	movwf	TRISD
	
	call	delay
	
	btfsc	PORTD, 4
	movlw	0x08
	
	btfsc	PORTD, 5
	movlw	0x09
	
	btfsc	PORTD, 6;
	movlw	0x0A

	btfsc	PORTD, 7;
	movlw	0x0B

	addwf	TBLPTR, 1, ACCESS
	call	delay
	
	call	LCD_Top
	movlw	length-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	call	delay
	
	goto	input
	
COL4
	movlw	0xF8
	call	delay
	CPFSEQ	PORTD, ACCESS	    ; Compare PORTD input to W, skip if not equal
	goto	BLANK
	
	call	delay		    ; Allow time to change PORTD	
	
	movlw   b'00001111'
	movwf   PORTD
	movlw   b'11110000'	    ; PORTD all inputs
	movwf	TRISD
	
	call	delay
	
	btfsc	PORTD, 4
	movlw	0x0C
	
	btfsc	PORTD, 5
	movlw	0x0D
	
	btfsc	PORTD, 6;
	movlw	0x0E

	btfsc	PORTD, 7;
	movlw	0x0F
	
	addwf	TBLPTR, 1, ACCESS
	call	delay
	
	call	LCD_Top
	movlw	length-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	call	delay
	
	goto	input
	
BLANK	
	;call	LCD_clear
	movlw	0x10
	call	delay
	addwf	TBLPTR, 1, ACCESS
	call	delay
	
	call	LCD_Top
	movlw	length-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	call	delay
	
	goto	input
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return
	
	;lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
;	movlw	upper(myTable)	; address of data in PM
;	movwf	TBLPTRU		; load upper bits to TBLPTRU
;	movlw	high(myTable)	; address of data in PM
;	movwf	TBLPTRH		; load high byte to TBLPTRH
;	movlw	low(myTable)	; address of data in PM
;	movwf	TBLPTRL		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter		; our counter register
;loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter		; count down to zero
;	bra	loop		; keep going until finished
	

	
	
	end