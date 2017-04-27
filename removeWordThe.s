		AREA rmThe, CODE, READWRITE
			
						; **NOTE** Memory map 0x0, 0x1FF with RWX for this program to be functional.
										
		ENTRY				; Start point to the program

		LDR	r0, =STRING1		; The input string
		LDR	r1, =STRING2		; The register holding the output, processed string
		
						; The byte copying loop
COPY		LDRB	r2, [r0], #ONE		; Load the next byte into r2, and increment the pointer to our input string
		CMP	r2, #ZERO		; Check if the next byte is zero
		BEQ	LOOP			; If so, then this is the end of the file, so branch to the end
		
		BL	CHCKTHE			; Branch to the CHCKTHE subroutine to check if the next word is "the"
		
		CMP	r3, #ONE		; Check if the output in r3 from the CHCKTHE subroutine is 1
		ADDEQ	r0, #TWO		; If so, increment the input string pointer by 2
		BEQ	COPY			; and then branch to the beginning, skipping an occurance of "the"
		
		STRB 	r2, [r1], #ONE		; Otherwise, store the byte into our output, and increment it's pointer
		B	COPY			; Then loop back to the beginning to examine the next byte.

LOOP		B	LOOP			; An endless loop, signifying the end of the program


CHCKTHE		MOV	r3, #ZERO		; Set the output, stored in r3, to be zero initially
		
		CMP	r2, #CHAR_T		; Check if the current character is T
		MOVNE	PC, LR			; If not, the word cannot be the, return from subroutine
		
		LDRB	r4,	[r0]		; Load the next character into r4
		CMP	r4, #CHAR_H		; Check if the next character is H
		MOVNE	PC, LR			; If not, the word cannot be the, return from subroutine

		LDRB	r4,	[r0, #ONE]	; Load the next character into r4
		CMP	r4, #CHAR_E		; Check if the next character is E
		MOVNE	PC, LR			; If not, the word cannot be the, return from subroutine

		LDRB	r4,	[r0, #TWO]	; Load the next character into r4
		CMP	r4, #SPC		; Check if the next character is a space
		MOVEQ	r3, #ONE		; If so, then the current word is "the", so place 1 into our r3 output
		
		MOV	PC, LR			; Return from the subroutine
		

		AREA rmThe, data, READWRITE

CHAR_T		EQU	0x74			; The ascii code of 't'
CHAR_H		EQU	0x68			; The ascii code of 'h'
CHAR_E		EQU	0x65			; The ascii code of 'e'
SPC		EQU	0x20			; The ascii code of ' '
ZERO		EQU	0			; The number zero
ONE		EQU	1			; The number one
TWO		EQU	2			; The number two
STRING1		DCB	"y  the The y the they"	; Our input string
EoS 		DCB	0x00			; A zero spacer to signify the end of our input string
STRING2		SPACE	0xFF			; The space into which our processed string will be placed
	
		END				; The end of the program
