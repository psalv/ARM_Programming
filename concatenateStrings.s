		AREA concatenate, CODE, READWRITE
			
											; **NOTE** Memory map 0x0, 0x264 with RWX for this program to be functional.
											
		ENTRY								; Start point to the program

		LDR		r0, =STRING3				; Load the destination  of the concatenated string into r0
		LDR		r1, =STRING1				; Load the first string into r1
		BL		COPY						; Branch to the copy sub routine (a leaf sub routine)
		LDR		r1, =STRING2				; Load the second string into r1
		BL		COPY						; Branch to the copy sub routine (a leaf sub routine) 

LOOP	B		LOOP						; An endless loop, signifying the end of the program

											; The copy subroutine
COPY	LDRB 	r2, [r1], #ONE				; Load the next byte of the string in r1 one to r2 and increment pointer
		CMP 	r2, #ZERO					; Check if the loaded byte was zero
		MOVEQ	PC, LR						; If so, return from the subroutine
		STRB 	r2, [r0], #ONE				; Store the byte into the next position in r0, and increment the pointer
		B		COPY						; Branch back to the beginning of the subroutine to start again



		AREA concatenate, data, READWRITE

ZERO	EQU		0							; The literal zero
ONE		EQU		1							; The literal one
STRING1	DCB 	"This is a test string1"	; The first string to be concatenated
EOS1	DCB		0x00						; A zero spacer to signify the end of the first string
STRING2	DCB 	"This is a test string2"	; The second string to be concatenated
EOS2	DCB		0x00						; A zero spacer to signify the end of the second string
STRING3	space	0xFF						; The space in which the strings will be concatenated

		END									; The end of the program