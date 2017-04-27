		    AREA palindrome, CODE, READONLY

            ENTRY				; beginning point
 
            LDR r0, =STR		; pointer to the string
            LDRB r1, [r0], #ONE	; load the first byte to r1 and set the register to be the next byte
cnt 		CMP r1, #ZERO		; see if the next byte signifies the end
            BEQ bgn			    ; if we reach the last character than branch to the bgn, the next step
            LDRB r1, [r0], #ONE	; load the next byte to r1 and set the register to be the next byte
            ADD r3, r3, #ONE	; register three keeps track of how many digits have been seen
            B cnt

bgn 		LDR r0, =STR		; pointer to the string

            MOV r2, #ZERO		; will be the pointer to the left side of the string, r3 will be pointer to the right side

palin		CMP r2, r3		    ; check if the pointers have crossed each other
            BGT	fnlP		    ; if so then we have found a palindrome, branch to final assignment when the string is a palindrome
            LDRB r4, [r0, r2]	; load the current left side char
            LDRB r5, [r0, r3]	; load the current right side char

                                ; Check if they are equal
            CMP r4, r5  		; compare them, if they are equal then look to the next position
            BEQ chgbth	    	; if they are equal, then we must change their indices so we can check the next character pairs

                                ; Check if they are equal if first is upper case
            SUB r6, r4, #NT_UP	; subtract 32 from r4 and store into r6, which would make a potential uppercase letter lowercase
            CMP r6, r5		    ; compare the new potentially lowercase ascii value with the old value of r5
            BEQ chgbth		    ; if they are equal then this is a match

                                ; Check if they are equal if second is upper case
            SUB r6, r5, #NT_UP	; subtract 32 from r5 and store into r6, which would make a potential uppercase letter lowercase
            CMP r4, r6		    ; compare the new potentially lowercase ascii value with the old value of r4
            BEQ chgbth	    	; if they are equal then this is a match

                                ; Check if left is punctuation
            CMP r4, #LW_CHAR	; check if r4 < 64, if so..
            BLT incL    		; go to the next position
            CMP r4, #UP_CHAR	; check if r4 > 122, if so..
            BGT incL	    	; go to the next position
		
					            ; Check if right is punctuation
            CMP r5, #LW_CHAR	; check if r5 < 64, if so..
            BLT decR		    ; go to the next position
		    CMP r5, #UP_CHAR	; check if r5 > 122, if so..
		    BGT decR		    ; go to the next position
		
				            	; Conclude that this is not a palindrome
		    B fnlNP			    ; branch to final assignment when the string is not a palindrome
		
incL		ADD r2, r2, #ONE	; increase the left pointer (case when punctuation is found)
		    B palin			    ; branch to palindrome check using new left index
		
decR		SUB r3, r3, #ONE	; decrease the right pointer (case when punctuation is found)
		    B palin		    	; branch to palindrome check using new right index
		
chgbth		ADD r2, r2, #ONE	; increase the pointer to the left
		    SUB r3, r3, #ONE	; decrease the pointer to the right
		    B palin			    ; branch to palindrome check using new indices
		
fnlP		MOV r0, #ONE		; store success value in r0, that being 1
		    B loop			    ; branch to the end, we are finished
		
fnlNP		MOV r0, #TWO		; store fail value in r0, that being 2


loop		B loop	    		; infinite loop signifying the end
		
		
		    AREA palindrome, DATA, READWRITE
STR		    DCB "He lived as a devil, eh?",0	; palindromic string
ZERO		EQU 0					        	; zero
ONE		    EQU 1				    	    	; one
TWO		    EQU 2			             		; two
NT_UP		EQU 32		    		        	; the value needed to subtract from an uppercase ascii character to get it's respective lowercase
LW_CHAR		EQU 64			    	    		; the value at which lower case ascii letters begin
UP_CHAR		EQU 122				    	    	; the value at which upper case ascii letter end
	    	END
