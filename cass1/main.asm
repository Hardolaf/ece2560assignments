;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
			.list
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
			mov		#7,n
trpt:			tst		done
			jne		cont
			mov		#1,done		;set done = TRUE
			mov		#1,i
tol			mov		i,R7		;start of straight code
			dec		R7
			clrc
			rlc		R7
			add		#bls,R7
			cmp		@R7,2(R7)
			jge		noexch
			mov		@R7,temp
			mov		2(R7),0(R7)
			mov		temp,2(R7)
			clr		done
noexch		inc		i
			cmp		i,n
			jge		tol
			dec		n
			cmp		i,n
			jne		trpt
			mov		#1,done    ;set done = TRUE
			jmp		trpt
cont		nop
Loop		JMP		Loop

			.data
i 			.word 	0x0000
n			.word	0x0007
done		.word	0x0000
temp		.word	0x0000
bls			.word	0x4F00,0x2001,0x0001,0x00AA,0x1234,0x00AB,0x0311,0x000F
ch			.char	8,"def"
xx			.word	0x0000,0x0000

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

