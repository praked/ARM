
	AREA     appcode, CODE, READONLY	;Start of the CODE area
	IMPORT printMsg
    EXPORT __main	
	ENTRY 	 
__main  FUNCTION
		;Considering 10 X 10 
		LDR r0 , =0x2000000A   ;starting address
		LDR r1 , =0x2000006D   ;end address
		LDR r3 , =0x20000042	; focus location pushing on stack for demo purpose
		PUSH {r3}
		MOV r5 , #5				;5 represents crossline data i.e data for red color
		POP {r6}				;r6=Xpixel = start add and r7=Ypixel = start add
		MOV r7,r6	
		
		MOV r8, r7
COUNTY
		CMP r7 , r0
		IT GT
		SUBGT r7, r7 , #0x0000000A
		BGT COUNTY 
		SUB r9 , r0 , r7	; r9 represents no. of locations required to go to start of y axis
		LDR r4 , =0
		MOV r2, #10
		CMP r9 ,r4
		IT GT
		SUBGT r9 , r2 , r9
		;SUBGT r9 , r9 , r2
		SUB r8 , r8 , r9	;r8 represents starting location of y axis
		MOV r9, #1			;counter for no. of consecutive y locations for cross	
LOOP1		

		STRB r5 , [r8]		;storing r5 content to y location stored in r7
		ADD r9 , r9 , #1	;increasing counter
		ADD r8 , r8 , #1
		CMP r9 , #10
		BLE LOOP1
		
DRAWX1	
		ADD r6 , r6 , #0x0000000A	; if given pixel location is in between then going to end of line first
		CMP r6 , r1
		BLE DRAWX1
		SUB r6 , r6 , #0x0000000A
DRAWX2
		STRB r5 , [r6]		; storing r5 content to x location stored in r6
		CMP r6 , r0
		SUBGE r6 , r6 , #0x0000000A	;Every x location of cross will be 240 apart
		BGE DRAWX2
	    B CYPHERENCRYPT		

;Encryption part
CYPHERENCRYPT
		LDR R0 ,=0X2000000A
		LDR R1 ,=0X2000006D
		MOV r4, r0             
		LDR r6,=0x20000C02 ;location of IV
		LDR r8,=0x20005C01 ;location of cipher text
		MOV r9, #10	;value for IV
		STR r9, [r6]  ;store 10 to IV
		LDR r10,[r6]    ;initialization vector
		
		LDR r7, [r4]  ; reading plain text from start add
		CMP r10, #10 ;initialization vector value = 10
		EOR r7,r7,r10 ; exor of plaintext & initialization vector
		STR r10 , [r6]       ;store IV 
		STR r7,[r8] ;storing the result
		ADD r4, r4,#4
ELOOP
		LDR r7, [r4]  ; reading plain text from start add
		LDR r11, [r8]  ; load encrypted result to r11
		EOR r7,r7,r11  ;exor result with plain text
		ADD r8,r8,#4
		STR r7,[r8]
		ADD r4, r4,#4	
		CMP r4,r1
		BLT ELOOP
		B TRHAM  
		
;Transmission
TRHAM		     B IMAGE	
EVEN_PARITY1	 MOV R7 ,LR		
LOOPo             AND R10 ,R9 ,R8
                 CMP R10 ,#0
				 IT HI
                 ADDHI R4 ,R4 ,#1       ;R11 AND R10 TEMP REGISTERS
				 ADD R11 ,R11 ,#1
				 LSL R9 ,R9 ,#1
                 CMP R11 ,#8	
	             IT HS
				 BHS CHECK_PARITY1
                 B LOOPo   	
CHECK_PARITY1	AND R4 ,R4 ,#1
				MOV R11 ,#0
				CMP R4 ,#0                   ;R4 TEMP REGISTER
                IT HI
                MOVHI R11 ,#1	
				MOV PC , R7


IMAGE           LDR  R12 ,=0X20005C01   ;SOURCE 
                LDR  R5 ,=0X20000050    ;DESTINATION 
				
IMAGELOOP      LDR R9 ,=0X20005C64
               CMP  R5 ,R9
               IT HI 
               BHI stop		   
               B START


LOADIMAGE       LSL R1 ,R1 ,#1
                ORR R0 ,R1 ,R0
                LSL R2 ,R2 ,#2  
                ORR R0 ,R2 ,R0
				LSL R3 ,R3 ,#3
				ORR R0 ,R3 ,R0
				AND R6 ,R6 ,#0X000000FF
				STR R6 ,[R5]   
                ADD R5 ,R5 ,#1
				AND R0 ,R0 ,#0X000000FF
				STR R0 ,[R5]
				ADD R5 ,R5 ,#1
				LDR R9 ,=0X20000118
				CMP R5 , R9
				ADD R12 ,R12,#1 
				IT HI 
				BHI HAMMINGDECODE
                B IMAGELOOP
START	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	   MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	  ; MOV R5 ,#0x20000000                  ;R5 will have starting address
	LDR R6 ,[R12]	;R6 will have data
    AND R6 ,R6 ,#0X000000FF	
	MOV R0 ,#0X0000005B                  ;FIRST PARITY  P1  MASK
	MOV R1 ,#0X0000006D
	MOV R2 ,#0X0000008E
	MOV R3 ,#0X000000F0
	MOV R8 ,#0X00000000
	MOV R11 ,#0X00000000 
	AND R8 ,R6 ,R0                        ;MASKING TO R8 TEMPORARY REGISTER FOR CAL PARITY
    BL  EVEN_PARITY1	
R_11	MOV R8 ,#0X00000000
    AND R8 ,R6,R1
	MOV R0 , R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S   
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY1
R_21	MOV R8 ,#0X00000000
    AND R8 ,R6,R2
	MOV R1 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY1
	MOV R8 ,#0X00000000    
R_31	AND R8 , R6 , R3
	MOV R2 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
 	MOV R11 ,#0X00000000 
	BL EVEN_PARITY1
R_41 MOV R3 ,R11
    B LOADIMAGE


HAMMINGDECODE   B CORRECT_LOAD
CORRECT_LOAD    LDR  R12 ,=0X20005C01        ;destination register r12
                LDR  R5 ,=0X20000050         ;source register r11 
LOADPARITY		LDR  R6 ,[R5]
                AND R6 ,R6 ,#0X000000FF
                ADD  R5 ,R5 ,#1              ;initializing transmitted value     
                B START1     
IMAGE1        AND R0 ,R0 ,#0X000000FF
             STR R0 ,[R12]
             ADD  R12 ,R12 ,#1	
             LDR R11 ,=0X20005c64          ;storing the decoded value     
             CMP R12 ,R11
             IT HS
             BHS CYPHERDECRYPT  			 
             B LOADPARITY     


STARTCORET  AND R6 ,R6 ,#0X000000FF
            LDR R6 ,[R5]         ;R6 REAL PARITY BITS
            ADD  R5 ,R5 ,#1
            B START1			
EVEN_PARITY		 MOV R7 ,LR		                      ;EVEN PARITY FUNCTION             
LOOP             AND R10 ,R9 ,R8
                 CMP R10 ,#0
				 IT HI
                 ADDHI R4 ,R4 ,#1       ;R11 AND R10 TEMP REGISTERS
				 ADD R11 ,R11 ,#1
				 LSL R9 ,R9 ,#1
                 CMP R11 ,#8	
	             IT HS
				 BHS CHECK_PARITY
                 B LOOP   	
CHECK_PARITY	AND R4 ,R4 ,#1                 ;SETS THE PARITY BIT IN R11 REGISTER
				MOV R11 ,#0
				CMP R4 ,#0                   ;R4 TEMP REGISTER
                IT HI
                MOVHI R11 ,#1	
				MOV PC , R7 
START1	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	   MOV R4 ,#0X00000000                    ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	  ; MOV R5 ,#0x20000000                   ;R5 will have starting address
	;LDR R6 ,[R5]                             ;R6 will have data	
	MOV R0 ,#0X0000005B                       ;FIRST PARITY  P1 ,P2,P3,P4 IN R0 ,R1,R2,R3  MASK
	MOV R1 ,#0X0000006D
	MOV R2 ,#0X0000008E
	MOV R3 ,#0X000000F0
	MOV R8 ,#0X00000000
	MOV R11 ,#0X00000000 
	AND R8 ,R6 ,R0  	;MASKING TO R8 TEMPORARY REGISTER FOR CAL PARITY
    BL  EVEN_PARITY	
R_1	MOV R8 ,#0X00000000
    AND R8 ,R6,R1
	LDR R7 ,[R5]                          ;SETTING PARITY BITS BY CALLING EVEN_PARITY
    AND R7 ,R7 ,#1
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1    
	MOV R0 , R11
	MOV R9 ,#0X00000001                   ;R9TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;R4TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
R_2	MOV R8 ,#0X00000000
    AND R8 ,R6,R2
	LDR R7 ,[R5] 
    AND R7 ,R7 ,#2
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1  
	MOV R1 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
	MOV R8 ,#0X00000000    
R_3	AND R8 , R6 , R3
    LDR R7 ,[R5] 
    AND R7 ,R7 ,#4
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1  
	MOV R2 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
 	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
	LDR R7 ,[R5] 
	AND R7 ,R7 ,#0X000000FF
	AND R7 ,R7 ,#8
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1  
R_4 MOV R3 ,R11
             LSL R1 ,R1 ,#1
                ORR R0 ,R1 ,R0               ;GETTING THE SUM OF PARITY BITS TO CHECK FOR ERROR  
                LSL R2 ,R2 ,#2  
                ORR R0 ,R2 ,R0
				LSL R3 ,R3 ,#3
				ORR R0 ,R3 ,R0
				
            MOV R4 ,R0	
			MOV R0 ,R6
            LDR R6 ,[R5]         ;R6 REAL PARITY BITS
		    AND R6 ,R6 ,#0X000000FF
           ADD  R5 ,R5 ,#1		     			
		   CMP R4 ,#0                 ;R4 CALCULATED PARITY BITS
		   IT NE
		   BNE LOOKUP
		   B IMAGE1				
LOOKUP     MOV R1 ,#3                      ;IF ERROR CHECK FOR THE CORRESPONDING BIT AND FLIP THE BITS
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT0
           MOV R1 ,#5
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT1
		    MOV R1 ,#6
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT2
		    MOV R1 ,#7
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT3
		   MOV R1 ,#9
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT4 
		   MOV R1 ,#10
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT5
		   MOV R1 ,#11
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT6
		   MOV R1 ,#12
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT7
		   

		   
BIT0       MOV R1 ,#0X1   
           ;LSL R1 ,R1 ,#3 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
BIT1       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#1 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
BIT2       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#2 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
BIT3       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#3 
           EOR R0 ,R0,R1	            ; CODE FOR CHANGING BITS IN CASE OF ERROR TRANSMISSION
           B IMAGE1                          
		   
BIT4       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#4 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
BIT5       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#5 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
BIT6       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#6 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
BIT7       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#7 
           EOR R0 ,R0,R1	           
           B IMAGE1
		   
CYPHERDECRYPT  	    LDR r8 , =0x20005C01   ;location of cipher texT
	                LDR r9,[r8]  ;ciphertext msg from encryption
	                MOV r10,r9	;storing previos ciphertext
	                EOR r9,r9,#10 ; r9 = exor of ciphertext & initialization vector(cdtn for 1st msg)	
	                STR r9,[r8]	
	                ADD r8,r8,#4
	                MOV r11,#1 ; for decrypting all words
LOOPn	
		LDR r9, [r8] ;loading result from ciphertext location (of encryped text) to r11
		mov r7 ,r9
		EOR r9,r9,r10
		MOV r10,r7
		STR R9 ,[R8]
		ADD r8,r8,#4
		ADD r11,r11,#1
		CMP r11,#25
		BNE LOOPn
		
        LDR R0 ,=0X20005C01
		BL printMsg
stop    B stop
        ENDFUNC
        END		 
 