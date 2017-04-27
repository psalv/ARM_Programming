		AREA exponent, CODE, READWRITE	; The code area
										
										; README: You must memory map 0x0,0x258 with RWX for this program to function.
										
		ENTRY							; Start point to the program
		
		ADR 	sp, stack				; Loading the address of the stack into the stack pointer
		MOV 	fp, sp					; Store the frame pointer for the current frame
		
		MOV 	r0, #ZERO				; Ensure that r0 has zero in it
		LDR 	r1, x					; Loading the value of x from memory
		LDR 	r2, n					; Loading the value of n from memory
		STMFD 	sp!, {r0-r2}			; Create a stack frame for the current stack
										; The beginning of a stack frame of the form: empty space, x, n
											
		BL 		power					; Call subroutine and store return addres into link register

		ADR 	r1, result				; Load the address of the result variable
		LDR 	r2, [fp, #RESULT]		; Load the result from the recursive power function
		STR 	r2, [r1]				; Store the result into the result variable
				
loop	B 		loop					; An endless loop signifying the end of the program
		
	
power	STMFD 	sp!, {fp, lr}			; Prepare new stack frame (currently uncreated) and store the value of the old one on previous frame
		LDR 	fp, [sp]				; Load the fp of the current frame
		LDR 	r2, [fp, #N_VAR]		; Loading n from the current stack frame
		
		CMP 	r2, #ZERO				; Check if the current value of n is equal to 0
		BNE 	ifSt					; If not then we check the if statement
		MOV 	r2, #ONE				; If it is then we move 1 into r2
		STR 	r2, [fp, #RESULT]		; We set the result for this frame to be r2
		LDR 	pc, [fp, #RET_ADR]		; We move the return address of this recursive call into the program counter

		
ifSt	TST 	r2, #ONE				; We test if we are dealing with an odd number
		BEQ 	elseSt					; If not, then we branch to the final else statement
		SUB 	r2, #ONE				; If so, then we decrement the value of n by 1
		STMFD 	sp!, {r2}				; We store the value of n in the next frame
		LDR 	r2, [fp, #X_VAR]		; We load the value of x into r2
		STR 	r2, [fp, #RESULT]		; We store x as the result for this frame
		STMFD 	sp!, {r0, r2}			; We store the value of x in the next frame, and leave a space for the result
		SUB 	fp, #TWENTY				; Increment the frame pointer to the next frame
		BL 		power					; We perform a recursive call to the beginning of power
		
		LDR 	r2, [fp, #RESULT]		; Load previous result (return)
		LDR 	fp, [fp]				; Change the frame pointer to be that of the previous frame
		LDR 	lr, [fp, #RESULT]		; Load current result
		MUL 	r1, lr, r2				; Multiply the previous and current results
		STR 	r1, [fp, #RESULT]		; Store the result into the result of the current frame
		SUB 	sp, #TWENTY				; Decrement stack pointer (pop off the top frame)
		LDR 	pc, [fp, #RET_ADR]		; Branch to the return address of this call
		

elseSt	LSR 	r2, #1					; Divide n by 2
		STMFD 	sp!, {r2}				; We store the value of n in the next frame
		LDR 	r2, [fp, #X_VAR]		; We load the value of x into r2
		STMFD 	sp!, {r0, r2}			; We store the value of x in the next frame, and leave a space for the result
		SUB 	fp, #TWENTY				; Increment the frame pointer to the next frame
		BL 		power					; Recurse to the beginning of the function with the new parameters on the stack
		
		LDR 	r2, [fp, #RESULT]		; Load the previous result (return)
		LDR 	fp, [fp]				; Change the frame pointer to be that of the previous frame
		MUL 	r1, r2, r2				; Square the returned result
		STR 	r1, [fp, #RESULT]		; Store the square into the result of the current frame
		SUB 	sp, #TWENTY				; Decrement stack pointer (pop off the top frame)
		LDR 	pc, [fp, #RET_ADR] 		; Branch to the return address of this call
		
		
	
		AREA exponent, data, READWRITE	; The data area

ZERO	EQU			0					; The number zero
ONE		EQU			1					; The number one
TWENTY	EQU 		20					; The number twenty

RESULT	EQU			-12					; The fp offset needed to get the result
X_VAR	EQU			-8					; The fp offset needed to get x
RET_ADR	EQU			-16					; The fp offset needed to get the return addres
N_VAR	EQU 		-4					; The fp offset needed to get n
	
result	DCD			0x00000000			; The variable to store the final result
x		DCD			2					; The x variable for the recursive function
n		DCD			3					; The n variable for the recursive function
		SPACE		400					; A space for the stack
stack	DCD			0x00000000			; The base of the stack

		END								; The end of the program space