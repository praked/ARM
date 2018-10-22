; Pranav Kedia - IMT2015518
; ARM Cortex M4 assembly code for greatest common divisor
; INPUT: R2, R3
; OUTPUT: R2 or R3	
	AREA     GCD, CODE, READONLY
	EXPORT __main
	ENTRY
__main  FUNCTION
        MOV r2,#14 ; (a = 15)
        MOV r3,#4 ; (b = 4)
loop    CMP r2,r3; (check if a has become equal to b, loop stops if they become equal)
		SUBGT r2,r2,r3; executed if r2 > r3
		SUBLT r3,r3,r2; executed if r2 < r3
        BNE loop ; loop if a != b and finally r2 or r3 holds the result of GCD
stop    B stop ; stop program
     ENDFUNC
     END