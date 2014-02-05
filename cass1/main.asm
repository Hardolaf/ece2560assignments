;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
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

			.data
i			.word	0x0001					; for loop counter
n			.word	0x0004					; number of items in list
done		.word	0x0000					; boolean 0x0000 = false, 0x000=true
temp		.word	0x0000					; temporary holding variable
list		.word	0x0000, 0x0001, 0x0002	; words to sort

; While NOT done repeat
rpt			tst		done
			jne		cont
;   done = True
tol											; FOR i = 1 to n-1 Loop
			inc		i
			cmp		i,n						; are we at the end
											; will compute n-i
			JGE		tol
;     IF list(i) > list(i+1) THEN
;       temp = list(i)
;       list(i) = list(i+1)
;       list(i+1) = temp
;       done = FALSE
;     END IF
;   END loop
;   n = n-1
;   IF n=1 THEN done=True
			jmp		rpt
cont										; END While

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
