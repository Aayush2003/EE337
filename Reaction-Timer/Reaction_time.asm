; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 000bh
ljmp timer0_isr  // Timer 0 for generating delays

org 001bh
ljmp timer1_isr  // Timer 1 keeping track of reaction time

org 0030h
	
timer0_isr: clr tr0
		    reti
			
timer1_isr: clr tr1
			inc r3
			mov th1, #00h
		    mov tl1, #01h
			setb tr1
			reti
	
state0: 
		lcall lcd0
		ljmp state1

state1:
		lcall delay_1s
		lcall delay_1s
		mov th1, #00h
		mov tl1, #01h
		mov r3, #0
		mov p1, #00010001b
		setb tr1
		react_loop: jnb p1.0, react_loop
		clr tr1
		clr p1.4
		ljmp state2
		
state2:
		mov a, th1
		rr a
		rr a
	    rr a
		anl a, #00011111b
		// Number of milliseconds counted by TH1 TL1
		mov 52h, a
		mov a, r3
		mov b, #33
		mul ab
		mov 50h, b
		add a, 52h
		mov 51h, a
		mov a, 50h
		addc a, #00h
		mov 50h, a
		// Required milliseconds stored in 50h 51h
		lcall thousand
		lcall hundred
		lcall ten
		//Four digit representation stored in 60h 61h 62h 63h
		mov a, 60h
		add a, #30h
		mov 60h, a
		mov a, 61h
		add a, #30h
		mov 61h, a
		mov a, 62h
		add a, #30h
		mov 62h, a
		mov a, 63h
		add a, #30h
		mov 63h, a
		// ASCII Representation stored
		lcall lcd2
		lcall delay_1s
		lcall delay_1s
		lcall delay_1s
		lcall delay_1s
		lcall delay_1s
		ljmp state0
		
thousand:
		   mov r0, #00h
		   thou_loop:
		   clr c
		   mov a, 51h
		   subb a, #0e8h
		   mov r2, a
		   mov a, 50h
		   subb a, #03h
		   jc thou_ret
		   mov 50h, a
		   mov 51h, r2
		   inc r0
		   ljmp thou_loop
		   thou_ret:
		   mov 60h, r0
		   ret
		   
hundred:
		   mov r0, #00h
		   hun_loop:
		   clr c
		   mov a, 51h
		   subb a, #64h
		   mov r2, a
		   mov a, 50h
		   subb a, #00h
		   jc hun_ret
		   mov 50h, a
		   mov 51h, r2
		   inc r0
		   ljmp hun_loop
		   hun_ret:
		   mov 61h, r0
		   ret
		   
ten:
		   mov r0, #00h
		   ten_loop:
		   clr c
		   mov a, 51h
		   subb a, #0ah
		   jc ten_ret
		   mov 51h, a
		   inc r0
		   ljmp ten_loop
		   ten_ret:
		   mov 62h, r0
		   mov 63h, 51h
		   ret  

lcd0: 
      acall delay
	  mov a,#80h		 
	  acall lcd_command	 
	  acall delay
	  mov   dptr,#my_string1   
	  acall lcd_sendstring	   
	  acall delay
	  mov a,#0C0h		  
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string2
	  acall lcd_sendstring
	  ret
	  
lcd2: 
      acall delay
	  mov a,#80h		 
	  acall lcd_command	 
	  acall delay
	  mov   dptr,#my_string3  
	  acall lcd_sendstring	   
	  acall delay
	  mov a,#0C0h		  
	  acall lcd_command
	  acall delay
	  mov   dptr,#my_string7
	  acall lcd_sendstring
	  acall delay
	  acall delay
	  mov a, 60h
	  acall lcd_senddata
	  acall delay
	  mov a, 61h
	  acall lcd_senddata
	  acall delay
	  mov a, 62h
	  acall lcd_senddata
	  acall delay
	  mov a, 63h
	  acall lcd_senddata
	  acall delay
	  mov   dptr,#my_string6
	  acall lcd_sendstring
	  acall delay
	  ret
		
org 200h
start:
      mov P2,#00h
      mov P1,#00h
	  mov tmod, #11h
	  setb ea
	  setb et0
	  setb et1
      acall delay
	  acall delay
	  acall lcd_init      ;initialise LCD
	  ljmp state0

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret


here: jnb tr0, return 
	  sjmp here

delay_25ms: mov th0, #3ch
			mov tl0, #0b0h
			setb tr0
			ljmp here
			return: ret
			
delay_1s: mov r0, #41
		  delay_loop: djnz r0, delay_loop_body
		        ret
		  delay_loop_body: lcall delay_25ms
					  ljmp delay_loop

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "   Toggle SW1   ", 00H
my_string2:
		 DB   "  if LED glows  ", 00H
my_string3:
		 DB   "  Reaction Time ", 00H
my_string4:
		 DB   "Count is ", 00H
my_string5:
		 DB   " ", 00H
my_string6:
		 DB   " ms     ", 00H
my_string7:
		 DB   "    ", 00H

end