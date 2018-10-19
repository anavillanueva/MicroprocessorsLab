	#include p18f87k22.inc
	
	code
	org 0x0


SerialtoParallel
	call SPI_MasterInit
	movlw 0x2A
	call SPI_MasterTransmit
	movlw 0x37
	call SPI_MasterTransmit
	bra SerialtoParallel
	
SPI_MasterInit ; Set Clock edge to positive
	bcf SSP2STAT, CKE ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw (1<<SSPEN)|(1<<CKP)|(0x02)
	movwf SSP2CON1 ; SDO2 output; SCK2 output
	bcf TRISD, SDO2
	bcf TRISD, SCK2
	return 
		
	
SPI_MasterTransmit ; Start transmission of data (held in W) 
	movwf SSP2BUF 	
Wait_Transmit ; Wait for transmission to complete 
	btfss PIR2, SSP2IF 
	bra Wait_Transmit
	bcf PIR2, SSP2IF ; clear interrupt flag 
	return
	
	end
