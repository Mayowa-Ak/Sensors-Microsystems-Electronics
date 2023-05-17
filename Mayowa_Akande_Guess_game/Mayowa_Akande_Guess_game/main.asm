;
; Mayowa_Akande_Guess_game.asm
;
; Created: 23/08/2022 16:39:10
; Author : Temark
;


.include "m328pdef.inc"


;.CSEG

.MACRO shiftColumn 
	SBI PORTB, 3
	SBRS R26, @0			    	
	SBI PINB, 3
	SBI PORTB,5   	
	CBI PORTB,5
.ENDMACRO


.MACRO shiftRow 
	SBI PORTB, 3
	SBRS R21, @0			    	
	SBI PINB, 3
	SBI PORTB,5   	
	CBI PORTB,5
.ENDMACRO


.ORG 0x0000
RJMP init

.ORG 0x0020
RJMP timerInterrupt_0

init:

	SEI

	; timer counter interrupt
	LDI R16,0b00000011 ;prescaler 64	
    OUT TCCR0B,R16  
    LDI R22, 0b00000001 ;enable interrupt
    STS TIMSK0,R22

	
    ; pc3 as output.  led off
	LDI R16, 0b0001000
	OUT DDRC, R16
	SBI PORTC, 3
	

    ;PB3 is data bit ;PB4 is data copy	;PB5 is shift clock
	LDI R16, 0b00111000
	OUT DDRB, R16
	LDI R16, 0b11000111
	OUT PORTB, R16
	
	LDI R18, 0  ; magic no
	LDI R20, 0  ; counter
    LDI R24, 1  ; check if keyboard was pressed
	
    ; Reg initial values
    LDI R22,  6		 	;   offset of 6 for row
    LDI R21,  0b01000000		  	;    row config
/*
; initialize 16 empty blocks
	LDI YH, BYTE2(0x0100)
    LDI YL, BYTE1(0x0100)

	LDI R16, 0
	LDI R23, 16

	emptyBlock:
	ST Y+, R16
	DEC R23
	BRNE emptyBlock


   LDI R16,0x01
   loop10:
   NOP	
   NOP
   NOP

   LDI R17,0x01
   loop20:
   NOP
   NOP
   NOP	
   NOP
   NOP
			   									
   INC R17
   BRNE loop20     
						
   INC R16
   BRNE loop10        

   */
	
	;; character initialization in blocks
	LDI YH, BYTE2(0x0100)
    LDI YL, BYTE1(0x0100)
	
    LDI R16, 25  ; blank space
    ST Y, R16

    LDI R16, 24  ;: colon
    STD Y+1, R16

    LDI R16, 25 
    STD Y+2, R16

	LDI R16, 25 
    STD Y+3, R16

	LDI R16, 25  
    STD Y+4, R16

	LDI R16, 25 
    STD Y+5, R16

	LDI R16, 25  
    STD Y+6, R16

	LDI R16, 25  
    STD Y+7, R16

	LDI R16, 16  ; T
    STD Y+8, R16

    LDI R16, 17  ; R
    STD Y+9, R16

	LDI R16, 18  ;I
    STD Y+10, r16

	LDI R16, 10  ;A
    STD Y+11, R16

	LDI R16, 19  ;L
    STD Y+12, R16

	LDI R16, 20  ;S
    STD Y+13, R16

	LDI R16, 24  ; colon
    STD Y+14, R16

	LDI R16, 0  ;0
    STD Y+15, R16

    RJMP main



	main:

 ;keyboard 

; PD7, PD6, PD5, PD4 - Output rows are low

SBI DDRD,7
SBI DDRD,6
SBI DDRD,5
SBI DDRD,4

; PD3, PD2, PD1, PD0 - input columns with pull-up resistor
SBI PORTD,3
SBI PORTD,2
SBI PORTD,1
SBI PORTD,0


;PD7/row1 is low, other rows are high
CBI PORTD,7
SBI PORTD,6
SBI PORTD,5
SBI PORTD,4
NOP

; check PD3,2,1,0 if cleared
;skip if bit in i/o register set
SBIS PIND,3
RJMP KeyPad7Pressed

SBIS PIND,2
RJMP KeyPad8Pressed

SBIS PIND,1
RJMP KeyPad9Pressed

SBIS PIND,0
RJMP KeyPadFPressed
NOP


;PD6/row2 is low, other rows are high
SBI PORTD,7
CBI PORTD,6
SBI PORTD,5
SBI PORTD,4
NOP

; check PD3,2,1,0 if cleared
;skip if bit in i/o register set
SBIS PIND,3
RJMP KeyPad4Pressed


SBIS PIND,2;
RJMP KeyPad5Pressed


SBIS PIND,1
RJMP KeyPad6Pressed

SBIS PIND,0
RJMP KeyPadEPressed


;PD5/row3 is low, other rows are high
SBI PORTD,7
SBI PORTD,6
CBI PORTD,5
SBI PORTD,4
NOP

; check PD3,2,1,0 if cleared
;skip if bit in i/o register set
SBIS PIND,3
RJMP KeyPad1Pressed  

SBIS PIND,2
RJMP KeyPad2Pressed

SBIS PIND,1
RJMP KeyPad3Pressed

SBIS PIND,0
RJMP KeyPadDPressed


;PD4/row4 is low, other rows are high
SBI PORTD,7
SBI PORTD,6
SBI PORTD,5
CBI PORTD,4
NOP

; check PD3,2,1,0 if cleared
;skip if bit in i/o register set
SBIS PIND,3
RJMP KeyPadAPressed

SBIS PIND,2;
RJMP KeyPad0Pressed

SBIS PIND,1
RJMP KeyPadBPressed

SBIS PIND,0
RJMP KeyPadCPressed

RJMP keyPadCheck


KeyPad0Pressed:
LDI R17, 0
LDI R24, 0
RJMP main

KeyPad1Pressed:
LDI R17, 1
LDI R24, 0
RJMP main

KeyPad2Pressed:
LDI R17, 2
LDI R24, 0
RJMP main

KeyPad3Pressed:
LDI R17, 3
LDI R24, 0
RJMP main

KeyPad4Pressed:
LDI R17, 4
LDI R24, 0
RJMP main

KeyPad5Pressed:
LDI R17, 5
LDI R24, 0
RJMP main

KeyPad6Pressed:
LDI R17, 6
LDI R24, 0
RJMP main

KeyPad7Pressed:
LDI R17, 7
LDI R24, 0
RJMP main

KeyPad8Pressed:
LDI R17, 8
LDI R24, 0
RJMP main

KeyPad9Pressed:
LDI R17, 9
LDI R24, 0
RJMP main

KeyPadAPressed:
LDI R17, 10
LDI R24, 0
RJMP main

KeyPadBPressed:
LDI R17, 11
LDI R24, 0
RJMP main

KeyPadCPressed:
LDI R17, 12
LDI R24, 0
RJMP main

KeyPadDPressed:
LDI R17, 13
LDI R24, 0
RJMP main

KeyPadEPressed:
LDI R17, 14
LDI R24, 0
RJMP main

KeyPadFPressed:
LDI R17, 15
LDI R24, 0
RJMP main


    keyPadCheck:
	CPI R24, 1
	BREQ mainloop
	RJMP keyPadPressed

mainloop: RJMP main
	
	keyPadPressed:
	ST Y, R17     ; show key pressed
	INC R20 ; counter increament
	CPI R20, 5 ; is counter == to limit of 5?
	BREQ restart
	STD Y+15, R20

	LDI R24, 1  ; keypad not pressed
	
	CP R17, R18  ; keypad vs magic no			
    BREQ win
    RJMP lose


; magic no == trial no
restart: 
JMP init   ; magic no ==0

win:  

    CBI PORTC, 3

    LDI R16, 21 
    STD Y+3, R16

	LDI R16, 18  ;W
    STD Y+4, R16

	LDI R16, 22 ; I
    STD Y+5, R16

	LDI R16, 25 ;N
    STD Y+6, R16

LDI R16,0x0
loop1:
NOP	

LDI R17,0x01
loop2:
NOP
NOP
			   				
LDI R18,200
loop3:
NOP
NOP
NOP

INC R18
brne loop3
						
INC R17
brne loop2     ;branch if not equal
						
INC R16
brne loop1        ;branch if not equal  

jmp init  ; magic no ==0


lose:

SBI PORTC, 3

    LDI R16, 19 
    STD Y+3, R16

	LDI R16, 23  
    STD Y+4, R16

	LDI R16, 20 
    STD Y+5, R16

	LDI R16, 16 
    STD Y+6, R16


INC R18   ;; magic no +1 for every lose
RJMP main



timerInterrupt_0:
 
 ;stack
 PUSH R16
 LDI R16, SREG



    ; keyPadCheck timer counter
   
	LDI R27,6  ; 1khz
	STS TCNT0,R27

    ; Each block with column config
   
    LDI R19, 15  ; blocks

	block_config:

	LDI YH, BYTE2(0x0100)
    LDI YL, BYTE1(0x0100)

	
    
ADD YL, R19             ; Point to correct block
LD R26, Y            	; table offset

LDI ZH, BYTE2(table*2)  ; table adress
LDI ZL, BYTE1(table*2)

LSL R26

ADD ZL, R26            	; Point to adress of correct table character
CLR R0
ADC ZH, R0
              
LPM R23, Z          ; low byte
ADIW Z, 1
LPM R25, Z        ; high byte

MOV ZL, R23
MOV ZH, R25

CLR R0
ADD ZL, R22       ; add row offset
ADC ZH, R0
LPM R26, Z         

shiftColumn 0     	;  The column configuration for a block 
shiftColumn 1
shiftColumn 2
shiftColumn 3
shiftColumn 4  ; 1


DEC R19	 ; Configure the next block
BRPL block_config


    SBI PINB,3
    SBI PINB,5
    SBI PINB,5

	NOP
	NOP
	
    ; row config
    shiftRow 6
    shiftRow 5
    shiftRow 4
    shiftRow 3
    shiftRow 2
    shiftRow 1
    shiftRow 0

    
	LDI R19, 255  ; for delay
    DEC R22
    LSR R21
	
	TST R21
    BRNE delay        	
    LDI R21, 0b01000000  ; re-initialize row 
    LDI R22, 0b00000110  ;  an offset of 6 


    
    delay:
        SBI PINB,4 ;data latch
	    NOP
	    NOP
	    NOP
	    NOP
	    DEC R19
	    BRNE delay
        SBI PINB,4   ; output enable
    

	OUT SREG, R16
	POP R16
    RETI



		table:

    .dw Character0<<1
    .dw Character1<<1
    .dw Character2<<1
    .dw Character3<<1
    .dw Character4<<1
    .dw Character5<<1
    .dw Character6<<1
    .dw Character7<<1
    .dw Character8<<1
    .dw Character9<<1
 
    .dw CharacterA<<1  ;10
    .dw CharacterB<<1
    .dw CharacterC<<1 ;12
    .dw CharacterD<<1 ;13
    .dw CharacterE<<1 ;14
    .dw CharacterF<<1 ;15
	.dw CharacterT<<1  ;16
	.dw CharacterR<<1 ;17
	.dw CharacterI<<1 ;18
	.dw CharacterL<<1 ;19
	.dw CharacterS<<1 ;20
	.dw CharacterW<<1 ;21
	.dw CharacterN<<1 ;22
	.dw CharacterO<<1 ;23
	.dw CharacterColon<<1 ;24
	.dw CharacterEmpty<<1  ;25
	


characterA: 
	.db 0b01100, 0b10010, 0b10010, 0b11110, 0b10010, 0b10010, 0b10010, 0b00000

CharacterB: 
	.db 0b11100, 0b10010, 0b10010, 0b11100, 0b10010, 0b10010, 0b11100, 0b00000

CharacterC: 
	.db 0b01110, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b01110, 0b00000

CharacterD: 
	.db 0b11100, 0b10010, 0b10010, 0b10010, 0b10010, 0b10010, 0b11100, 0b00000

CharacterE: 
	.db 0b11110, 0b10000, 0b10000, 0b11100, 0b10000, 0b10000, 0b11110, 0b00000

CharacterF: 
	.db 0b11110, 0b10000, 0b10000, 0b11100, 0b10000, 0b10000, 0b10000, 0b00000

CharacterT:
    .db 0b11111, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000

CharacterR:
    .db 0b11110, 0b10010, 0b10010, 0b11110, 0b11000, 0b10100, 0b10010, 0b00000

CharacterI:
    .db 0b01110, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b01110, 0b00000

CharacterL:
    .db 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b10000, 0b11110, 0b00000

CharacterS:
    .db 0b01110, 0b10000, 0b10000, 0b01100, 0b00010, 0b00010, 0b11100, 0b00000

CharacterW:
    .db 0b10001, 0b10001, 0b10001, 0b10001, 0b10101, 0b11011, 0b10001, 0b00000
	

CharacterN:
    .db 0b10010, 0b11010, 0b10110, 0b10010, 0b10010, 0b10010, 0b10010, 0b00000

CharacterO:
    .db 0b11110, 0b10010, 0b10010, 0b10010, 0b10010, 0b10010, 0b11110, 0b00000


Character0:
	.db 0b11110, 0b10010, 0b10010, 0b10010, 0b10010, 0b10010, 0b11110, 0b00000

Character1: 
	.db 0b00100, 0b01100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000

Character2: 
	.db 0b11110, 0b00010, 0b00010, 0b11110, 0b10000, 0b10000, 0b11110, 0b00000

Character3: 
	.db 0b11110, 0b00010, 0b00010, 0b01110, 0b00010, 0b00010, 0b11110, 0b00000	

Character4: 
	.db 0b10100, 0b10100, 0b10100, 0b11110, 0b00100, 0b00100, 0b00100, 0b00000

Character5: 
	.db 0b11110, 0b10000, 0b10000, 0b11110, 0b00010, 0b00010, 0b11110, 0b00000

Character6: 
	.db 0b11110, 0b10000, 0b10000, 0b11110, 0b10010, 0b10010, 0b11110, 0b00000

Character7: 
	.db 0b11110, 0b00010, 0b00100, 0b00100, 0b00100, 0b00100, 0b00100, 0b00000

Character8: 
	.db 0b11110, 0b10010, 0b10010, 0b11110, 0b10010, 0b10010, 0b11110, 0b00000

Character9: 
	.db 0b11110, 0b10010, 0b10010, 0b11110, 0b00010, 0b00010, 0b11110, 0b00000


CharacterColon:
	.db 0b00000, 0b00000, 0b00100, 0b00000, 0b00100, 0b00000, 0b00000, 0b00000

CharacterEmpty:
    .db 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000, 0b00000


