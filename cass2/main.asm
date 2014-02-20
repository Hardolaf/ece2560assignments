;-------------------------------------------------------------------------------
; MSP430 Assembler Code for Multiplying Numbers Together
;
; Author: Joseph Warner
; E-mail: hardolaf@gmail.com
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

main		clr i

;-------------------------------------------------------------------------------
											; For loop to calculate numbers
;-------------------------------------------------------------------------------

for:		nop								; Get index for addressing words
			mov.w	i,R4					; Move i to R4, mult by 2 for word
											; addressing
			rlc		R4
			mov.w	#A,R5					; Move address of A to R5
			mov.w	#B,R6					; Move address of B to R6
			add		R4,R5					; Add 2*i to A's address
			add		R4,R6					; Add 2*i to B's address
			push	0(R5)					; Pass A as a parameter
			push	0(R6)					; Pass B as a parameter
			push	R8						; Pass R8 as output
			call	#smult					; Perform multiplication
			mov.w	#results,R7				; Move address of results to R7
			add		R4,R7					; Add 2*i to resuls's address
			pop		R8						; Move R8 into result
			pop		R6
			pop		R5
			mov.w	R8,0(R7)				; Move this value to address in R7
			inc		i						; Increment i
			cmp		i,n						; Is i less than n?
			jnz		for						; If it is, go to the start
forend		jmp		forend					; loop forever at completion

;-------------------------------------------------------------------------------
											; Simple multiplication
;-------------------------------------------------------------------------------
smult:		push	R2
			push	R5
			push	R6
			push	R7
			mov.w	10(SP),R6
			mov.w	12(SP),R5
			clr		R7
mlp			add		R6,R7
			dec		R5
			jne		mlp
			mov.w	R7,12(SP)
			mov.w	R7,12(SP)
			pop		R7
			pop		R6
			pop		R5
			pop		R2
			ret

;-------------------------------------------------------------------------------
                                            ; Variable definitions
;-------------------------------------------------------------------------------
			.data
i			.word	0x0000
n			.word	0x0005
A			.word	0x000f,0x0b12,0x00b3,0x0013,0x00cf
B			.word	0x0002,0x000a,0x000d,0x0f00,0x00cf
results		.word	0x0000,0x0000,0x0000,0x0000,0x0000

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
