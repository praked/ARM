; PRANAV KEDIA - IMT2015518
; ARM Cortex M4 assembly code for exponential of a number
; INPUT: S0
; OUTPUT: S1

     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
	 
__main  FUNCTION		 		
		VMOV.F s0,#-5.00	; in
		VMOV.F s1,#1		; out
		VMOV.F s2,#1		; ctr
		VMOV.F s3,s0		; tmp
		VMOV.F s4,#31 		; cmp
		VMOV.F s5,#1 		; add
		
loop	VCMP.F s1, s4		; previous value == current value?
		VMRS APSR_nzcv,FPSCR; move FPSR flags to APSR
		BEQ stop			; YES stop
		
		VMOV.F s4, s1		; s4 = s1, for checking if value will change
		VDIV.F s3, s3, s2	; s3 /= s2
		VADD.F s1, s1, s3	; s1 += s3
		VMUL.F s3, s3, s0	; s3 *= s0
		VADD.F s2, s2, s5	; s2 += s5

		B loop
		
stop B stop 			; stop program
     ENDFUNC
     END
