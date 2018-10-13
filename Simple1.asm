	#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
	
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	
	goto	start
	
	; ******* Main programme *********************
start 	lfsr	FSR0, 0x002	    ; Load FSR0 with starting recording address
				    ; Load the count in 0x00 and 0x01
	movlw   0x02		    ; Starting count
	movwf   0x00		    ; Starting number set here at location 0x00
loop8bit
	movlw	0x1
	CPFSLT	0x01, 0		    ; If 0x01 (highest hexadec of counting number) less than 1, i.e. number is 8 bits, dont add last 4bits to anything.
	call	addNext4Bit	    ; Subroutine to add the third hexadec to the next FSR location in RAM
	
	incf    0x00, 1 ,ACCESS	    ; Increment count by 1
	call	add8Bit		    ; Add the first 8-bits to RAM location and increment FSR by 1
	
	movlw	0xFF
	CPFSEQ  0x00, 0		    ; If count reaches 0xFF, exit loop to add 1 to third hexadec and set first two hexadec to 00, to have 0x100
	bra     loop8bit	 
	
	incf    0x01, 1, ACCESS	    ; Each time 0x00 reaches 0xFF, add 1 to 0x01 which will mean number 0x1FF
	call	addNext4Bit	    ; Add 0x01 to next location to have the third number in 0x100
	movlw   0x0		    ; Set 0x00 to 0 so we have 0x100
	movwf   0x00
	call	add8Bit		    ; Add 0x00 to 0x00 to have the first two numbers in 0x100
	; Here, we added 0x100 - 0x200 - 0x300... etc. when it is their turn to be added
	bra	loop8bit
	
	
addNext4Bit			    ; Adding the higher hexadecimal to the next RAM location in FSR
	movff   0x01, TABLAT	    ; Move count to TABLAT
	movff	TABLAT, POSTINC0    ; This takes TABLAT to location at FSR, increasing FSR0 by 1
	return
add8Bit				    ; Adding the lower two bytes to the next RAM location in FSR
	movff   0x00, TABLAT	    ; Move count to TABLAT
	movff	TABLAT, POSTINC0    ; This takes TABLAT to location at FSR, increasing FSR0 by 1
	return
	
	goto	start
	
	end
	
; CODE ENDS HERE
	

loop 	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	

	call subroutine
	decfsz	counter	; count down to zero
	bra	loop		; keep going until finished
	; test comment
	; test branch
	goto	0
	
subroutine  
	movlw .10
	movwf 0x20 ; store 10 in 0x20
subroutine_loop
	call subsubroutine
	decfsz 0x20 ; count down from 10 to 0
	bra subroutine_loop
	return
	; test comment commit
subsubroutine	
	movlw .3
	movwf 0x21 ; store 3 in 0x21	
subsubroutine_loop decfsz 0x21 ; count down from 3 to 0
	bra subsubroutine_loop
	return
;	end