		AREA quadForm, CODE, READWRITE
			
											; **NOTE** Memory map 0x0, 0x90 with RWX for this program to be functional.
											
		ENTRY								; Start point to the program

		MOV		r0, #2_011					; A variable for r0
		BL		CALC						; Branch to the subroutine calc
		MOV		r1, r0, LSL #1				; Double the result, which will be stored in r0, and store this in r1
		
LOOP	B		LOOP						; An endless loop, signifying the end of the program

		
											; The calculation subroutine
CALC	STR		r1, [r15, #STRVAL]			; Store the contents of r1 into memory using PC relatve addressing
		STR		r2, [r15, #STRVAL]			; Store the contents of r2 into memory using PC relatve addressing

		LDR 	r2, =A						; Load the address of A into r2
		LDR 	r2, [r2]					; Load the value of A into r2
		MUL		r1, r0, r0					; Compute the square of r0, store into t1
		MUL		r1, r2, r1					; Multiply the square of r0 by A, store into r1
				
		LDR		r2, =B						; Load the address of B into r2
		LDR		r2, [r2]					; Load the value of B into r2
		MLA		r1, r0, r2, r1				; Add the product of r0 and C to r1
		
		LDR 	r2, =C						; Load the address of C into r2
		LDR		r2, [r2]					; Load the value of C into r2
		ADD		r0, r1, r2					; Add the value of C to our sum in r1
		
		LDR		r1, =D						; Load the address of the clip value into r1
		LDR		r1, [r1]					; Load the value of the clip into r1
		CMP		r0, r1						; Compare the value in r0 to our clip value, D
		LDRGT	r0, =D						; If r0 > D, then load the address of D into r0	
		LDRGT	r0, [r0]					; Then load the contents of r0, which will be D, into r0
		
		LDR 	r1, [r15, #LDVAL]			; Load the contents of r1 into memory using PC relatve addressing
		LDR		r2, [r15, #LDVAL]			; Load the contents of r2 into memory using PC relatve addressing
		MOV		PC, LR						; Return from the subroutine.


		AREA quadForm, data, READWRITE

		SPACE	0x8							; A space reserved to save register values
A		DCD		5							; A constant variable, A
B		DCD		6							; A constant variable, B
C		DCD		7							; A constant variable, C
D		DCD		50							; The clip value signifying the largest possible return value from CALC
STRVAL	EQU		0x59						; The PC relative value needed to store register values.
LDVAL	EQU		20							; The PC relative value needed to load register values.
		END									; The end of the program