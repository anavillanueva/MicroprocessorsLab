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
myTable data	    0xFF, 0xFE	; message, plus carriage return
	constant    myTable_l=.3	; length of data
	
yourTable data      "Hello World! XX \n"
	constant    yourTable_1 = .16   ; length of data
	
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	goto	start
	
	; ******* Main programme ****************************************
start 	
	
	
input	
	movlw   b'11110000'
	movwf   PORTD
	movlw   b'00001111'	    ; PORTD all inputs
	movwf	TRISD
	;movff   PORTD, 0x01
	
	
	
	movlw	0xF1
	;CPFSEQ	0x01, ACCESS
	CPFSEQ	PORTD, ACCESS
	goto    secondbit
	
	movlw   b'00001111'
	movwf   PORTD
	movlw   b'11110000'	    ; PORTD all inputs
	movwf	TRISD
	;movff   PORTD, 0x02
	
	movlw	0x1F
	;CPFSEQ	0x01, ACCESS
	CPFSEQ	PORTD, ACCESS
	goto    secondbit
	
	call LCD_clear
	
	;CMP PORTD, b'00000001'
	;JE 
secondbit
	movlw   b'11110000'
	movwf   PORTD
	movlw   b'00001111'	    ; columns are read
	movwf	TRISD
	
	movlw	0xF2
	CPFSEQ	PORTD, ACCESS
	goto    thirdbit
	
	movlw   b'00001111'
	movwf   PORTD
	movlw   b'11110000'	    ; rows are read
	movwf	TRISD
	
	movlw	0x2F
	CPFSEQ	PORTD, ACCESS
	goto    thirdbit
	
	

	;lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
;	movlw	myTable_l	; bytes to read
;	movwf 	counter		; our counter register
;loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
;	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
;	decfsz	counter		; count down to zero
;	bra	loop		; keep going until finished

	call	LCD_Top
	movlw	myTable_l-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	
thirdbit	
	movlw	0xF4
	CPFSEQ	PORTD, ACCESS
	goto	input
	
	movlw	upper(yourTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(yourTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(yourTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	
	call	LCD_Bottom
	movlw	yourTable_1-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	
	
	goto	input 		; goto current line in code

outputdata  
	movlw	myTable_l-1	; output message to LCD (leave out "\n")
	call	LCD_Write_Message
	return

	movlw	myTable_l	; output message to UART
	call	UART_Transmit_Message
	return
	
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

L7	call	LCD_clear
	
	
	end