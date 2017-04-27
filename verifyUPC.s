		AREA    upc, CODE, READONLY
        ENTRY					; starting point of code

		LDR r0, =UPC			; pointer to upc code string
		
		LDRB r1, [r0], #ONE		; load the first byte to r1 and set the register to be the next byte
		SUB r1, r1, #TO_INT		; subtract 48 from r1, store into r1, this gets the integer represented by the ascii code
		ADD r3, r3, r1			; add the contents of r1 to r3, store in r3

		MOV r5, #ONE			; initialize a counter to one

st		LDRB r1, [r0], #ONE		; load the next byte to r1 and set the register to be the next byte
		SUB r1, r1, #TO_INT		; subtract 48 from r1, store into r1, this gets the integer represented by the ascii code
		ADD r4, r4, r1			; add the contents of r1 to r4, store in r4
		
		LDRB r1, [r0], #ONE		; load the next byte to r1 and set the register to be the next byte
		SUB r1, r1, #TO_INT		; subtract 48 from r1, store into r1, this gets the integer represented by the ascii code
		ADD r3, r3, r1			; add the contents of r1 to r3, store in r3


		ADD r5, r5, #TWO		; increment our counter by 2
		CMP r5, #ELVN			; check if our counter is equal to 11
   
		BNE st				    ; if it is not, then branch back to the beginning of the loop

    
		ADD r7, r3, r3			; multiply the odd addition register by 3, start by adding the register to itself (multiply by 2), storing in r7
		ADD r3, r7, r3			; finish multiplication by three by adding r3 to r7 (r7 = 2*r3), and storing the result in r3
		
		ADD r3, r3, r4			; add registers r3 and r4 and store them into r3
		SUB r3, r3, #ONE    	; subtract one from r3 and store in r3
    
dv		CMP r3, #NINE			; if our value is greater than 9 then it is not the remainder when dividing by 10
		BLT fnl         		; if it is, then we branch to the final value assignments
		SUB r3, r3, #TEN		; we subtract 10
		B dv				    ; loop back to check if r3 is less than or equal to 9 now
		
fnl		MOV r7, #NINE			; store the literal 9 into register r7
		SUB r1, r7, r3			; subtract r3 from r7 and store it in r0

		LDRB r0, [r0]			; load the last byte to r1 and set the register to be the next byte
		SUB r0, r0, #TO_INT		; subtract 48 from r1, store into r1, this gets the integer represented by the ascii code
		
		CMP r1, r0		    	; compare the last (check digit) and our result from calculation
		BNE two			    	; if they were not equal, then branch to two
		
		MOV r0, #ONE			; if they were equal, then store 1 in r0
		B loop			    	; branch to the end
		
two		MOV r0, #TWO			; if they were not equal, then store 2 in r0


loop		B loop				; endless loop to finish
		
		
		AREA    upc, DATA, READWRITE
UPC		DCB "060383755577",0	; a upc code
ONE		EQU 1			       	; one
TWO		EQU 2			       	; two
NINE	EQU 9		    	    ; nine
TEN		EQU 10		            ; ten
ELVN	EQU 11		        	; eleven
TO_INT	EQU 48		    	    ; the number needed to subtract from an ascii character representing a digit to get the digit itself
		END