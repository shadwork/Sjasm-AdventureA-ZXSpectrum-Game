	
	module OUTPUT

POS_Y: db 0
POS_X: db 0
WRAP: db 0
CURSOR_ENABLE: db 0
CURSOR_BLINK_COUNTER: db 0
CURSOR_BLINK_STATUS: db 0
	
	; clear screen with border
	; A - color
CLEAR: LD HL, 16384           ; Start address of screen bitmap
	LD DE, 16385                 ; Address + 1
	LD BC, 6144                  ; Length of bitmap memory to clear
	LD (HL), 0                   ; Set the first byte to 0
	LDIR                         ; Copy this byte to the second, and so on
	LD BC, 767                   ; Length of attribute memory, less one to clear
	LD (HL), A                   ; Set the first byte to A
	LDIR                         ; Copy this byte to the second, and so on
	RRA
	RRA
	RRA
	OUT (254), A
	LD HL, POS_Y
	ld (HL), 0
	INC HL
	ld (HL), 0
	RET
	
PRINT_TEXT_WRAP:
	XOR A
	LD (WRAP),A
	PUSH BC
PRINT_TEXT_WRAP_LOOP:
	PUSH HL
	LD B, 0
SEARCH_13_LOOP: LD A, (HL)
	CP '\r'
	JR Z, DELIM_CHAR_FOUND
	CP ' '
	JR Z, DELIM_CHAR_FOUND
	OR A
	JR Z, DELIM_CHAR_FOUND
	INC HL
	INC B
	JR SEARCH_13_LOOP
DELIM_CHAR_FOUND:
	PUSH AF
	LD A, (POS_X)
	ADD B
	CP 33                        ; screen width + 1
	JR C, PRINT_WORD_WRAP
	LD A, '\r'
	CALL PRINT_CHAR
	LD A,1
	LD (WRAP),A
PRINT_WORD_WRAP: POP AF
	POP HL
	LD C, A
PRINT_WORD_LOOP: 
	LD A, (HL)
	CP C
	JR Z, PRINT_WORD_END
	CALL PRINT_CHAR
	INC HL
	JR PRINT_WORD_LOOP
PRINT_WORD_END:
	OR A
	JR Z, PRINT_ZERO_EXIT
	PUSH HL
	PUSH AF
	LD A,(WRAP)
	OR A
	JR Z,WRAP_NOT_COLUMN
	LD A,(POS_X)
	OR A
	JR NZ,WRAP_NOT_COLUMN
	POP AF
	CP 32
	JR Z, WRAP_SKIP_SPACE
	PUSH AF
WRAP_NOT_COLUMN:	POP AF
	CALL PRINT_CHAR
WRAP_SKIP_SPACE:	POP HL
	INC HL
	JR PRINT_TEXT_WRAP_LOOP
END_CHAR_FOUND:
	POP HL
PRINT_ZERO_EXIT:	
	POP BC
	RET

	
	;==================================
	; - =Процедура печати стрингов= - 
	; HL - адрес строки текста
	;0 - конец текста
	
PRINT_TEXT: LD A, (HL)        ;взять код символа
	AND A                        ;проверить на ноль
	RET Z                        ;совпало - выйти
	PUSH HL
	CALL PRINT_CHAR              ;нужная Вам процедура печати
	POP HL
	INC HL
	JR PRINT_TEXT
	
	;==================================
	; - =Процедура печати стрингов= - 
	;вх: DE - координаты
	; HL - адрес строки текста
	;поддерживаются токены:
	;0 - конец текста
	;17, X, Y - установка координат печати
	;==================================
PRINT_TEXT_AT: LD A, (HL)     ;взять код символа
	AND A                        ;проверить на ноль
	RET Z                        ;совпало - выйти
	CP 17                        ;проверка на токен
	JP NZ, Pr_Cont
	INC HL                       ;установка новых координат
	LD E, (HL)
	INC HL
	LD D, (HL)
	INC HL
	JP PRINT_TEXT_AT
Pr_Cont: PUSH HL
	PUSH DE
	CALL PRINT_CHAR              ;нужная Вам процедура печати
	POP DE
	POP HL
	INC E
	INC HL
	JP PRINT_TEXT_AT
	
	; print one digit
PRINT_DIGIT: PUSH AF
	AND 0xf
	ADD A, 0x30
	CALL PRINT_CHAR
	POP AF
	RET
	
PRINT_CR: PUSH AF
	LD A, '\r'
	CALL PRINT_CHAR
	POP AF
	RET
	;=====печать символа 8х8 (fast) =====
	;A - код символа
PRINT_CHAR:
	PUSH HL
	PUSH DE
	PUSH BC
	PUSH AF
	CP '\r'
	JR Z, PRINT_13
	CP 8
	JR Z, PRINT_8
	JR PRINT_SYM
PRINT_13: LD HL, POS_X
	PUSH AF
	XOR A
	LD (WRAP),A
	POP AF
	JR LINE_END
PRINT_8:
	CALL CURSOR_ERASE
	LD HL, POS_X
	LD A, (HL)
	DEC A
	LD (HL), A
	CP 255
	JR NZ, PRINT_RET
	LD (HL), 0
	INC HL
	LD A, (HL)
	DEC A
	CP 255
	JR PRINT_RET
PRINT_SYM: LD HL, POS_Y
	LD D, (HL)
	INC HL
	LD E, (HL)
	CALL PRINT_CHAR_ADDR
	LD HL, POS_X
	LD A, (HL)
	INC A
	CP 32
	JR NC, LINE_END
	LD (HL), A
	JR PRINT_RET
LINE_END:
	LD A,1
	LD (WRAP),A
	XOR A
	LD (HL), A
	DEC HL
	LD A, (HL)
	INC A
	CP 24
	JR NC, SCREEN_END
	LD (HL), A
	JR PRINT_RET
SCREEN_END:
	DEC A
	LD (HL), A
	CALL SCROLL_ALL
	CALL CL_LINE
PRINT_RET: POP AF
	POP BC
	POP DE
	POP HL
	RET
	
	;=====печать символа 8х8 (fast) =====
	;in: DE - координаты, A - код символа
PRINT_CHAR_ADDR:
	LD L, A                      ;в HL - код симво - 
	LD H, 0                      ;ла, который мы
	ADD HL, HL
	ADD HL, HL
	ADD HL, HL
	LD BC, 0x3C00                ;складываем с
	ADD HL, BC                   ;адресом начала фонта
	LD A, D                      ;знакомая нам уже
	AND 7                        ;процедурка ;)
	RRCA
	RRCA
	RRCA
	OR E
	LD E, A
	LD A, D
	AND 24
	OR 64
	LD D, A
	DUP 7                        ;директивы ALASM!!!
	LD A, (HL)                   ;берем байт из фонта
	LD (DE), A                   ;и кладем в экран
	INC HL                       ;приращение fnt adr
	INC D                        ;приращение scr adr
	EDUP                         ;и так 8 раз
	LD A, (HL)
	LD (DE), A
	RET
	
CURSOR_SHOW: LD A,'_'
	LD (CURSOR_ENABLE),A
	RET

CURSOR_HIDE:LD A,0
	LD (CURSOR_ENABLE),A
	CALL CURSOR_ERAISED
	RET

CURSOR_PRINT: PUSH HL
			  PUSH BC
			PUSH DE
			LD HL, POS_Y
	LD D, (HL)
	INC HL
	LD E, (HL)
	LD A,(CURSOR_ENABLE)
	CALL PRINT_CHAR_ADDR
	POP DE
	POP BC
	POP HL
	RET

CURSOR_BLINKS: LD A,(CURSOR_ENABLE)
				OR A
				RET Z
				LD A,(CURSOR_BLINK_COUNTER)
				INC A
				CP 10 ; At 60Hz (CGA), the period is 266ms or 533ms
				LD (CURSOR_BLINK_COUNTER),A
				RET C
				XOR A
				LD (CURSOR_BLINK_COUNTER),A
				LD A,(CURSOR_BLINK_STATUS)
				XOR 255
				LD (CURSOR_BLINK_STATUS),A	
				OR A
				JR NZ, CURSOR_ERAISED
				CALL CURSOR_PRINT	
				RET	
CURSOR_ERAISED: CALL CURSOR_ERASE
				RET

CURSOR_ERASE: PUSH HL
			  PUSH BC
			  			PUSH DE
			LD HL, POS_Y
	LD D, (HL)
	INC HL
	LD E, (HL)
	LD A,' '
	CALL PRINT_CHAR_ADDR
	POP DE
	POP BC
	POP HL
	RET


	;(c) cooper / RSM / P7S ;возвращаемся...
	
SCROLL_ALL: LD DE, #4000      ;откуда
	LD HL, #4020                 ;куда
	LD B, #17                    ;кол - во строк
	
MAIN: PUSH BC
	CALL SCROLL                  ;вызов проц.сдвига
	CALL LL693E                  ;служебные процедуры (на стр. вверх)
	CALL LL6949                  ;служебные процедуры (на стр. вниз)
	POP BC
	DJNZ MAIN
	RET
	
	;а это собственно и есть служебные процедуры
	;где какая, разберетесь сами, ok?
LL692A: LD A, L
	SUB #20
	LD L, A
	RET NC
	LD A, H
	SUB #08
	LD H, A
	RET
	
LL6934: LD A, E
	SUB #20
	LD E, A
	RET NC
	LD A, D
	SUB #08
	LD D, A
	RET
	
LL693E: INC H
	LD A, L
	SUB #E0
	LD L, A
	RET NC
	LD A, H
	SUB #08
	LD H, A
	RET
	
LL6949: INC D
	LD A, E
	SUB #E0
	LD E, A
	RET NC
	LD A, D
	SUB #08
	LD D, A
	RET
	
	;непосредственный scroll screen
SCROLL: PUSH HL
	PUSH DE
	LD A, D
	RRCA
	RRCA
	RRCA
	AND #03
	OR #58
	LD D, A
	LD A, H
	RRCA
	RRCA
	RRCA
	AND #03
	OR #58
	LD H, A
	DUP 32
	LDI
	EDUP
	POP DE
	POP HL
	LD BC, #00F8
	JP LOOP2
LOOP1: INC H
	INC D
LOOP2: DUP 31
	LDI
	EDUP
	LD A, (HL)
	LD (DE), A
	INC H
	INC D
	DUP 31
	LDD
	EDUP
	LD A, (HL)
	LD (DE), A
	JP PE, LOOP1
	RET
	
CL_LINE:
	LD HL, 16384 + 2048 * 2 + 32 * 7 ; Start address of screen bitmap
	LD DE, HL                    ; Address + 1
	INC DE
	LD B, 8
CL_LINE_LOOP: PUSH BC
	LD BC, 31                    ; Length of bitmap memory to clear
	LD (HL), 0                   ; Set the first byte to 0
	LDIR
	LD BC, 256 + 1 - 32
	ADD HL, BC
	LD DE, HL                    ; Address + 1
	INC DE
	POP BC
	DJNZ CL_LINE_LOOP
	RET
	
	endmodule
