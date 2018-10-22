; Pranav Kedia - IMT2015518
; ARM Cortex M4 assembly code for finding greatest of three numbers
; INPUT: R0, R1, R2
; OUTPUT: R5
	AREA largest, CODE, READONLY
	EXPORT __main
	ENTRY
__main  FUNCTION ; The result is stored in register R5 i.e. the largest number
        MOV  r0, #1		;input a
		MOV  r1, #2 	;input b
		MOV  r2, #3		;input c	
		CMP r0, r1		; r0 > r1
		ITE GE			
		MOVGE r5, r0	; executed if a > b, r5 = a
		MOVLT r5, r1	; executed if a <= b, r5 = b
		CMP r2, r3		; r2 > r3
		IT GE			
		MOVGE r5, r2	; executed if r2 > r5, r5 = r2
stop    B stop ; stop program
		ENDFUNC
		END