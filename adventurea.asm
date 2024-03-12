                                            DEVICE ZXSPECTRUM48

                                            include defines.asm

	                                        define VAR_KEY_ST IX-0x8
                                            define VAR_KEY_DO IX-0x7
	                                        define VAR_KEY_BUFFER IX-0x6
	                                        define VAR_KEY_CO IX-0x5
	                                        define VAR_KEY_IN0 IX-0x4
                                            define VAR_KEY_IN1 IX-0x3
	                                        define VAR_ITEMS_COUNTER IX-0x2
	                                        define VAR_CURRENT_ROOM IX-0x1
	                                        define VAR_START_GAME IX+0x0    
                                            define VAR_START_B IX+0x1
	                                        define VAR_START_C IX+0x2    
                                            define VAR_LIGHT IX+0x3   
                                            define VAR_START_E IX+0x4                                                                                                                             

                                            module GAME
                                            org 0x5d40
                                            db 0x00; IX-8 VAR_KEY_ST
VAR_KEY_DO_LABEL:                           db 0x00; IX-7
                                            db 0x00; IX-6
VAR_KEY_CO_LABEL:                           db 0x00; IX-5
VAR_KEY_IN0_ADDR:                           db 0x00; IX-4 
VAR_KEY_IN1_ADDR:                           db 0x00; IX-3
SAVE_BUFFER_PART1:                          db 0x00; IX-2 VAR_ITEMS_COUNTER                               
CURRENT_ROOM:                               db 0x00; IX-1 VAR_CURRENT_ROOM
BUFFER:                                     ; clear on init 0x1e length = 30
                                            db 0xCD ; IX+0 VAR_START
                                            db 0x42 ; IX+1
                                            db 0x6F ; IX+2 
                                            db 0xCD ; IX+3 
                                            db 0x50 ; IX+4
                                            db 0x72
                                            db 0xCD
                                            db 0x00
                                            db 0x55
                                            db 0xC3
                                            db 0x27
                                            db 0x64
                                            db 0xE3
                                            db 0xF3
                                            db 0xD5
                                            db 0xC5
                                            db 0xDD
                                            db 0xE5
                                            db 0xE5
                                            db 0xDD
                                            db 0x21
                                            db 0x5F
                                            db 0x72
                                            db 0xC9
                                            db 0x32
                                            db 0x0F
                                            db 0x76
                                            db 0xF1
                                            db 0xDD
                                            db 0xE1
VAR_VAR1:                                   dw 0xd1c1
VAR_VAR2:                                   dw 0xf5e1
VAR_SCORE:                                  dw 0x0000
ENTRY_POINT:                                LD HL,BUFFER
                                            LD B,0x1e
CLEAR_BUFFER:                               LD (HL),0x0
                                            INC HL
                                            DJNZ CLEAR_BUFFER
                                            LD HL,0x0
                                            LD (VAR_SCORE),HL
                                            CALL GAME_INIT
                                            LD HL,ITEMS_BY_ROOM_TABLE_INIT ;copy from
                                            LD DE,ITEMS_BY_ROOM_TABLE ;copy to
                                            LD BC,0x1d ;copy size
                                            LDIR
                                            LD IX,BUFFER
                                            LD (VAR_CURRENT_ROOM),0x0 ; starting from room 0
                                            PUSH HL
                                            JR ASK_RESTORE_GAME
TEXT_RESTORE_GAME:                          db "WANT TO RESTORE A GAME?\r",0
ASK_RESTORE_GAME:                           LD HL,TEXT_RESTORE_GAME 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            CALL WAIT_KEY
                                            CP 'Y'
                                            CALL Z,GAME_RESTORED
LAB_ram_5dbd:                               CALL INIT_SCREEN
                                            XOR A
                                            CP (VAR_START_GAME) ; zero here from start
                                            JR Z,PRINT_ROOM
                                            CP (VAR_LIGHT)
                                            JR Z,LIGHT_CHECK
                                            DEC (VAR_LIGHT)
LIGHT_CHECK:                                LD A,(ITEMS_BY_ROOM_TABLE) ; starting with 0x05
                                            CP (VAR_CURRENT_ROOM)
                                            JR Z,PRINT_ROOM
                                            PUSH HL
                                            JR STATE_DARK
TEXT_EVERYTHING_DARK:                       db "EVERYTHING IS DARK.I CANT SEE.\r",0
STATE_DARK:                                 LD HL,TEXT_EVERYTHING_DARK 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            XOR A
                                            CP (VAR_START_E) ; 0x50 started = 80
                                            JR Z,LAB_ram_5e09
                                            DEC (VAR_START_E)
LAB_ram_5e09:                               JR PARSE_LOOP
PRINT_ROOM:                                 LD DE,ROOM_DESC_POINTER 
                                            LD L,(VAR_CURRENT_ROOM)
                                            LD H,0x0
                                            ADD HL,HL
                                            ADD HL,DE
                                            LD E,(HL) 
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            LD (VAR_ITEMS_COUNTER),0x0
                                            LD HL,ITEMS_BY_ROOM_TABLE
                                            LD C,0x0 ; from first item
PRINT_ITEMS:                                LD A,(HL)
                                            CP 0xff ;end of items
                                            JR Z,PARSE_LOOP ; no item left - jump to input
                                            CP (VAR_CURRENT_ROOM)
                                            JR NZ,NEXT_ROOM_FOR_ITEM
                                            XOR A ; room is found
                                            CP (VAR_ITEMS_COUNTER) 
                                            JR NZ,PRINT_NEXT_ITEM
                                            PUSH HL
                                            JR PRINT_ASLO_SEE
TEXT_ALSO_SEE:                              db "I CAN ALSO SEE :\r",0
PRINT_ASLO_SEE:                             LD HL,TEXT_ALSO_SEE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            INC (VAR_ITEMS_COUNTER)
PRINT_NEXT_ITEM:                            PUSH HL
                                            LD HL,ITEM_DESC_POINTER 
                                            LD B,0x0
                                            ADD HL,BC
                                            ADD HL,BC
                                            LD E,(HL) 
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            CALL SCREEN.PRINT_CR
                                            POP HL
NEXT_ROOM_FOR_ITEM:                         INC HL
                                            INC C
                                            JR PRINT_ITEMS
PARSE_LOOP:                                 LD HL,TABLE_SIX 
                                            JP PARSE_PROC
CMD_TELL_ME:                                POP BC
                                            POP HL
                                            XOR A
                                            CP (VAR_START_C)
                                            JR Z,LAB_ram_5e7c
                                            DEC (VAR_START_C)
LAB_ram_5e7c:                               CP (IX+0x5)
                                            JR Z,LAB_ram_5e84
                                            DEC (IX+0x5)
LAB_ram_5e84:                               JR LAB_ram_5e9b
TEXT_TELL_ME:                               db "TELL ME WHAT TO DO \r",0
LAB_ram_5e9b:                               LD HL,TEXT_TELL_ME 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            CALL READ_LINE
                                            LD (VAR_KEY_ST),0x0
LAB_ram_5ea8:                               CALL CMD_DECODE
                                            LD (VAR_KEY_IN0_ADDR),A
                                            CP 0xff
                                            JR NZ,LAB_ram_5eec
                                            LD A,(HL) 
                                            CP 0xd
                                            JR Z,LAB_ram_5eba
                                            OR A
                                            JR NZ,LAB_ram_5ed9
LAB_ram_5eba:                               PUSH HL 
                                            JR LAB_ram_5ed0
TEXT_DONT_UNDERSTAND:                       db "I DONT UNDERSTAND\r",0
LAB_ram_5ed0:                               LD HL,TEXT_DONT_UNDERSTAND 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JR PARSE_LOOP
LAB_ram_5ed9:                               LD A,(HL)                                            
                                            CP 0x20
                                            JR NZ,LAB_ram_5ee1
                                            INC HL
                                            JR LAB_ram_5ea8
LAB_ram_5ee1:                               CP 0x0
                                            JR Z,LAB_ram_5eba
                                            CP 0xd
                                            JR Z,LAB_ram_5eba
                                            INC HL
                                            JR LAB_ram_5ed9
LAB_ram_5eec:                               LD (VAR_KEY_IN1),0xff
LAB_ram_5ef0:                               LD A,(HL)                                            
                                            CP 0x20
                                            JR Z,LAB_ram_5f02
                                            CP 0x0
                                            JP Z,LAB_ram_5f1d
                                            CP 0xd
                                            JP Z,LAB_ram_5f1d
                                            INC HL
                                            JR LAB_ram_5ef0
LAB_ram_5f02:                               INC HL
                                            CALL CMD_DECODE
                                            LD (VAR_KEY_IN1_ADDR),A
                                            CP 0xff
                                            JR NZ,LAB_ram_5f1d
LAB_ram_5f0d:                               LD A,(HL) 
                                            
                                            CP 0x0
                                            JR Z,LAB_ram_5f1d
                                            CP 0xd
                                            JR Z,LAB_ram_5f1d
                                            CP 0x20
                                            JR Z,LAB_ram_5f02
                                            INC HL
                                            JR LAB_ram_5f0d
LAB_ram_5f1d:                               LD D,0x0
                                            LD E,(VAR_CURRENT_ROOM)
                                            LD HL,SOME_POINTER 
                                            ADD HL,DE
                                            ADD HL,DE
                                            LD E,(HL)
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
LAB_ram_5f2b:                               LD A,(HL)
                                            CP 0xff
                                            JR Z,LAB_ram_5f41
                                            CP (VAR_KEY_IN0)
                                            JR NZ,LAB_ram_5f3d
                                            INC HL
                                            LD A,(HL)
                                            LD (VAR_CURRENT_ROOM),A
                                            JP LAB_ram_5dbd
LAB_ram_5f3d:                               INC HL
                                            INC HL
                                            JR LAB_ram_5f2b
LAB_ram_5f41:                               LD HL,DIR_TABLE 
                                            LD (VAR_KEY_BUFFER),0x0
PARSE_PROC:                                 LD A,(HL) ; pointed to TABLE_SIX = ff from start                      
                                            OR A
                                            JR NZ,ACTION_FOUND
                                            CP (VAR_KEY_BUFFER)
                                            JP NZ,PARSE_LOOP
                                            LD A,(VAR_KEY_IN0)
                                            CP 0xd
                                            JR C,PRINT_CANT_GO ; more then d
                                            LD A,(VAR_KEY_ST)
                                            OR A
                                            JR NZ,CANT_DO_YET
                                            PUSH HL                                             
                                            JR PRINT_CANT
TEXT_I_CANT:                                db "I CANT\r",0
PRINT_CANT:                                 LD HL,TEXT_I_CANT 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP PARSE_LOOP
CANT_DO_YET:                                PUSH HL                                             
                                            JR PRINT_CANT_DO_YET
TEXT_I_CANT_DO_YET:                         db "I CANT DO THAT YET\r",0
PRINT_CANT_DO_YET:                          LD HL,TEXT_I_CANT_DO_YET 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP PARSE_LOOP
PRINT_CANT_GO:                              PUSH HL  
                                            JR PRINT_CANT_GO_TEXT
TEXT_I_CANT_GO:                             db "I CANT GO IN THAT DIRECTION\r",0
PRINT_CANT_GO_TEXT:                         LD HL,TEXT_I_CANT_GO 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP PARSE_LOOP
                                            NOP
ACTION_FOUND:                               CP 0xff ; start value ff
                                            JR Z,COMMAND_FOUND_FF
                                            CP (VAR_KEY_IN0)
                                            JR Z,COMMAND_FOUND_FF
CMD_NEXT_BLOCK:                             LD DE,0x6 ; next block 
                                            ADD HL,DE
                                            JP PARSE_PROC
COMMAND_FOUND_FF:                           INC HL ; get second byte
                                            LD A,(HL) 
                                            CP 0xff
                                            JR Z,CMD2_FOUND_FF
                                            CP (VAR_KEY_IN1)
                                            JR Z,CMD2_FOUND_FF
                                            DEC HL
                                            JR CMD_NEXT_BLOCK
CMD2_FOUND_FF:                              INC HL
                                            LD C,(HL) 
                                            INC HL
                                            LD B,(HL) ; first value in BC 
                                            INC HL
JUMP_NEXT_BCA:                              LD A,(BC) 
                                            CP 0xff
                                            JP Z,LAST_ITEM_FF
                                            LD (VAR_KEY_CO_LABEL),A ; first [0] = 6,5,1,5,6,ff
                                            INC BC
                                            LD A,(BC) 
                                            LD (VAR_KEY_DO_LABEL),A ; second [1] = 5
                                            PUSH HL 
                                            LD HL,PROC_POINTER 
                                            LD D,0x0
                                            LD E,(VAR_KEY_CO)
                                            ADD HL,DE
                                            ADD HL,DE
                                            LD E,(HL) 
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
                                            JP (HL) ; jump to pointer
PROC_00:                                    LD A,(VAR_KEY_DO_LABEL)
                                            CP (VAR_CURRENT_ROOM)
                                            JR Z,PROCS_RET
PROC_NEXT:                                  POP HL
                                            INC HL
                                            INC HL
                                            LD (VAR_KEY_ST),1
                                            JP PARSE_PROC
PROC_01:                                    LD HL,ITEMS_BY_ROOM_TABLE
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            LD A,(HL)
                                            CP (VAR_CURRENT_ROOM)
                                            JR Z,PROCS_RET
                                            CP 0xfd
                                            JR NC,PROCS_RET
                                            JR PROC_NEXT
PROC_02:                                    LD A,R
                                            SUB (VAR_KEY_DO)
                                            JR C,PROCS_RET
                                            JR PROC_NEXT
PROC_03:                                    LD HL,ITEMS_BY_ROOM_TABLE
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            LD A,(HL)
                                            CP (VAR_CURRENT_ROOM)
                                            JR Z,PROC_NEXT
                                            CP 0xfd
                                            JR NC,PROC_NEXT
                                            JR PROCS_RET
PROC_04:                                    LD HL,ITEMS_BY_ROOM_TABLE
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            LD A,(HL)
                                            CP 0xfd
                                            JR Z,PROCS_RET
                                            JR PROC_NEXT
PROC_05:                                    LD HL,BUFFER
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            LD A,(HL)
                                            OR A
                                            JR Z,PROC_NEXT
PROCS_RET:                                  POP HL
                                            INC BC
                                            JP JUMP_NEXT_BCA
PROC_06:                                    INC BC
                                            LD A,(BC) 
                                            LD HL,BUFFER
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            CP (HL)
                                            JR NZ,PROC_NEXT ; next is triggered
                                            JR PROCS_RET
PROC_07:                                    LD HL,BUFFER
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            LD A,(HL)
                                            OR A
                                            JP NZ,PROC_NEXT
                                            JR PROCS_RET
PROC_08:                                    LD HL,ITEMS_BY_ROOM_TABLE
                                            LD D,0x0
                                            LD E,(VAR_KEY_DO)
                                            ADD HL,DE
                                            LD A,(HL)
                                            CP 0xfe
                                            JR Z,PROCS_RET
                                            CP 0xfd
                                            JR Z,PROCS_RET
                                            JP PROC_NEXT
PROC_POINTER:                               dw PROC_00
                                            dw PROC_01
                                            dw PROC_02
                                            dw PROC_03
                                            dw PROC_04
                                            dw PROC_05
                                            dw PROC_06 ; start element
                                            dw PROC_07
                                            dw PROC_08
LAST_ITEM_FF:                               LD C,(HL) 
                                            INC HL
                                            LD B,(HL)
                                            INC HL
                                            LD (VAR_KEY_BUFFER),1
LAB_ram_60b7:                               LD A,(BC)             
                                            CP 0xff
                                            JP Z,PARSE_PROC
                                            LD (VAR_KEY_CO_LABEL),A
                                            INC BC
                                            LD A,(BC) 
                                            LD (VAR_KEY_DO_LABEL),A
                                            PUSH HL 
                                            PUSH BC 
                                            LD HL,CMD_POINTER 
                                            LD D,0x0
                                            LD E,(VAR_KEY_CO)
                                            ADD HL,DE
                                            ADD HL,DE
                                            LD E,(HL) 
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
                                            JP (HL)
SUB_ram_60d6:                               LD HL,ITEMS_BY_ROOM_TABLE
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            LD A,(HL)
                                            RET
READ_LINE:                                  LD HL,LINE_BUFFER 
                                            JP READ_LINE_START
LINE_BUFFER:                                db 0xB3
                                            db 0xB2
                                            db 0xB8
                                            db 0x20
                                            db 0x09
                                            db 0x52
                                            db 0x45
                                            db 0x54
                                            db 0x0D
                                            db 0xB0
                                            db 0xB0
                                            db 0xB3
                                            db 0xB3
                                            db 0xB0
                                            db 0x20
                                            db 0x09
                                            db 0x45
                                            db 0x4E
                                            db 0x44
                                            db 0x09
                                            db 0x4D
                                            db 0x41
                                            db 0x49
                                            db 0x4E
                                            db 0x0D
                                            db 0x1A
                                            db 0x4C
                                            db 0x4C
                                            db 0x09
                                            db 0x47
                                            db 0x45
                                            db 0x54
                                            db 0x42
CMD_POINTER:                                dw CMD_INVENTORY
                                            dw CMD_NOT_WEARING
                                            dw CMD_CANT_CARRY
                                            dw CMD_DONT_HAVE
                                            dw CMD_ALREADY_WEAR
                                            dw CMD_TURN_GREEN
                                            dw CMD_LOOK_AROUND
                                            dw CMD_NOTHING
                                            dw CMD_6362
                                            dw CMD_636a
                                            dw CMD_6377
                                            dw CMD_6388
                                            dw CMD_6392
                                            dw CMD_OK
                                            dw CMD_SAVE
                                            dw CMD_6492
                                            dw CMD_64a6
                                            dw CMD_64b6
                                            dw CMD_SCORE
                                            dw CMD_GAME
                                            dw CMD_LOOP
                                            dw CMD_TELL_ME
                                            dw CMD_LOOP
                                            dw CMD_LOOP
                                            dw CMD_LOOP
CMD_INVENTORY:                              PUSH HL
                                            JR LAB_ram_615c
TEXT_HAVE_WITH_ME:                          db "I HAVE WITH ME THE FOLLOWING:\r",0
LAB_ram_615c:                               LD HL,TEXT_HAVE_WITH_ME 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            LD (VAR_ITEMS_COUNTER),0x0
                                            LD HL,ITEMS_BY_ROOM_TABLE
                                            LD C,0x0
LOOP_INVENTORY:                             LD A,(HL)
                                            CP 0xff ; ff - end of items
                                            JR Z,INVENTORY_EMPTY
                                            CP 0xfd
                                            JR C,NEXT_SCAN_ITEM ; fe - in inventory
                                            LD (VAR_ITEMS_COUNTER),0x1
                                            PUSH HL
                                            LD HL,ITEM_DESC_POINTER 
                                            LD B,0x0
                                            ADD HL,BC
                                            ADD HL,BC
                                            LD E,(HL) 
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            LD A,(HL)
                                            CP 0xfd ; fd - weared item
                                            JR NZ,ITEM_NOT_WEARED
                                            PUSH HL
                                            LD HL,TEXT_WHICH_I_AM_WEARING 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JR ITEM_NOT_WEARED
TEXT_WHICH_I_AM_WEARING:                    db " WHICH I AM WEARING",0
ITEM_NOT_WEARED:                            CALL SCREEN.PRINT_CR
NEXT_SCAN_ITEM:                             INC HL
                                            INC C
                                            JR LOOP_INVENTORY
INVENTORY_EMPTY:                            XOR A
                                            CP (VAR_ITEMS_COUNTER)
                                            JP NZ,CMD_LOOP
                                            PUSH HL
                                            JR LAB_ram_61cd
TEXT_NOTHING:                               db "NOTHING AT ALL\r",0
LAB_ram_61cd:                               LD HL,TEXT_NOTHING 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
CMD_NOT_WEARING:                            CALL SUB_ram_60d6
                                            CP 0xfd
                                            JR Z,LAB_ram_6200
                                            PUSH HL
                                            JR LAB_ram_61f6
TEXT_NOT_WEARING:                           db "I AM NOT WEARING IT\r",0
LAB_ram_61f6:                               LD HL,TEXT_NOT_WEARING 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
LAB_ram_6200:                               LD A,(VAR_START_B)
                                            CP 0x6
                                            JR NZ,LAB_ram_622f
                                            PUSH HL
                                            JR LAB_ram_6225
TEXT_HAND_FULL:                             db "I CANT. MY HANDS ARE FULL\r",0
LAB_ram_6225:                               LD HL,TEXT_HAND_FULL 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
LAB_ram_622f:                               LD (HL),0xfe
                                            INC (VAR_START_B)
                                            JP LAB_ram_6382
CMD_CANT_CARRY:                             LD A,(VAR_START_B)
                                            CP 0x6
                                            JR NZ,LAB_ram_6262
                                            PUSH HL
                                            JR LAB_ram_6258
TEXT_CANT_CARRY:                            db "I CANT CARRY ANY MORE\r",0
LAB_ram_6258:                               LD HL,TEXT_CANT_CARRY 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
LAB_ram_6262:                               CALL SUB_ram_60d6
                                            CP (VAR_CURRENT_ROOM)
                                            JR NZ,LAB_ram_6272
                                            LD (HL),0xfe
                                            INC (VAR_START_B)
                                            JP LAB_ram_6382
LAB_ram_6272:                               CP 0xfd
                                            JR Z,LAB_ram_6298
                                            CP 0xfe
                                            JR Z,LAB_ram_6298
                                            LD HL,TEXT_I_DONT_SEE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            JP CMD_LOOP
TEXT_I_DONT_SEE:                            db "I DON'T SEE IT HERE\r",0
LAB_ram_6298:                               PUSH HL
                                            JR LAB_ram_62ae
TEXT_ALREADY_HAVE:                          db "I ALREADY HAVE IT\r",0
LAB_ram_62ae:                               LD HL,TEXT_ALREADY_HAVE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
CMD_DONT_HAVE:                              CALL SUB_ram_60d6
                                            CP (VAR_CURRENT_ROOM)
                                            JR NZ,LAB_ram_62dd
LAB_ram_62c0:                               PUSH HL
                                            JR LAB_ram_62d3
TEXT_I_DONT_HAVE:                           db "I DONT HAVE IT\r",0
LAB_ram_62d3:                               LD HL,TEXT_I_DONT_HAVE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
LAB_ram_62dd:                               CP 0xfd
                                            JR Z,LAB_ram_62e8
                                            CP 0xfe
                                            JR NZ,LAB_ram_62c0
                                            DEC (VAR_START_B)
LAB_ram_62e8:                               LD A,(VAR_CURRENT_ROOM)
                                            LD (HL),A
                                            JP LAB_ram_6382
CMD_ALREADY_WEAR:                           CALL SUB_ram_60d6
                                            CP 0xfe
                                            JR NZ,LAB_ram_62fe
                                            LD (HL),0xfd
                                            DEC (VAR_START_B)
                                            JP LAB_ram_6382
LAB_ram_62fe:                               CP 0xfd
                                            JR NZ,LAB_ram_6328
                                            PUSH HL
                                            JR LAB_ram_631e
TEXT_ALREADY_WEAR:                          db "I AM ALREADY WEARING IT\r",0
LAB_ram_631e:                               LD HL,TEXT_ALREADY_WEAR 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
LAB_ram_6328:                               PUSH HL
                                            JR LAB_ram_633b
TEXT_I_DONT_HAVE_IT:                        db "I DONT HAVE IT\r",0
LAB_ram_633b:                               LD HL,TEXT_I_DONT_HAVE_IT 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
CMD_TURN_GREEN:                             LD HL,ACTION_POINTER 
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            ADD HL,BC
                                            LD E,(HL) 
                                            INC HL
                                            LD D,(HL)
                                            EX DE,HL
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            JR LAB_ram_6382
CMD_LOOK_AROUND:                            POP BC
                                            POP HL
                                            JP LAB_ram_5dbd
CMD_NOTHING:                                POP BC
                                            POP HL
                                            JP PARSE_LOOP
CMD_6362:                                   LD A,(VAR_KEY_DO)
                                            LD (VAR_CURRENT_ROOM),A
                                            JR LAB_ram_6382
CMD_636a:                                   LD HL,BUFFER
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            LD (HL),0xff
                                            JR LAB_ram_6382
CMD_6377:                                   LD HL,BUFFER
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            LD (HL),0x0
LAB_ram_6382:                               POP BC
                                            POP HL
                                            INC BC
                                            JP LAB_ram_60b7
CMD_6388:                                   CALL SUB_ram_60d6
                                            INC HL
                                            LD B,(HL)
                                            LD (HL),A
                                            DEC HL
                                            LD (HL),B
                                            JR LAB_ram_6382
CMD_6392:                                   JP LAB_ram_643f
CMD_OK:                                     PUSH HL
                                            JR LAB_ram_639e
TEXT_OK:                                    db "OK..\r",0
LAB_ram_639e:                               LD HL,TEXT_OK 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            JP CMD_LOOP
CMD_SAVE:                                   PUSH HL
                                            JR LAB_ram_63ca
TEXT_WANT_SAVE:                             db "DO YOU WANT TO SAVE THE GAME?\r",0
LAB_ram_63ca:                               LD HL,TEXT_WANT_SAVE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            CALL WAIT_KEY
                                            CP 0x59
                                            JR NZ,LAB_ram_643f
                                            PUSH IX
                                            LD IX,SAVE_BUFFER_PART1
                                            LD DE,0x2b
                                            PUSH HL
                                            JR LAB_ram_63f4
TEXT_READY_TYPE:                            db "READY CASSETTE\r",0
LAB_ram_63f4:                               LD HL,TEXT_READY_TYPE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            CALL WAIT_KEY
                                            LD A,0xff
                                            SCF
                                            CALL 0x04c2
                                            LD IX,ITEMS_BY_ROOM_TABLE
                                            LD DE,0x1d
                                            LD A,0xff
                                            SCF
                                            CALL 0x04c2
                                            POP IX
                                            PUSH HL
                                            JR LAB_ram_6430
TEXT_CONTINUE:                              db "DO YOU WISH TO CONTINUE?\r",0
LAB_ram_6430:                               LD HL,TEXT_CONTINUE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            CALL WAIT_KEY
                                            CP 0x59
                                            JP Z,CMD_LOOP
LAB_ram_643f:                               PUSH HL
                                            JR LAB_ram_645d
TEXT_TRY_AGAIN:                             db "DO YOU WISH TO TRY AGAIN?\r",0
LAB_ram_645d:                               LD HL,TEXT_TRY_AGAIN 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
LAB_ram_6464:                               PUSH HL
                                            JR LAB_ram_6479
TEXT_ANSWER:                                db "ANSWER YES OR NO\r",0
LAB_ram_6479:                               LD HL,TEXT_ANSWER 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            CALL WAIT_KEY
                                            NOP
                                            NOP
                                            NOP
                                            CP 0x59
                                            JP Z,ENTRY_POINT
                                            CP 0x4e
                                            JP Z,0x0000
                                            JR LAB_ram_6464
CMD_6492:                                   POP BC
                                            INC BC
                                            PUSH BC
                                            LD A,(BC)
                                            LD (VAR_KEY_CO_LABEL),A
                                            LD HL,BUFFER
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            LD (HL),A
                                            JP LAB_ram_6382
CMD_64a6:                                   LD HL,ITEMS_BY_ROOM_TABLE
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            LD A,(VAR_CURRENT_ROOM)
                                            LD (HL),A
                                            JP LAB_ram_6382
CMD_64b6:                                   LD HL,ITEMS_BY_ROOM_TABLE
                                            LD B,0x0
                                            LD C,(VAR_KEY_DO)
                                            ADD HL,BC
                                            LD (HL),0xfc
                                            JP LAB_ram_6382
CMD_LOOP:                                   POP BC
                                            POP HL
                                            JP PARSE_LOOP
CMD_SCORE:                                  LD A,(VAR_SCORE)
                                            LD B,A
                                            LD A,(VAR_KEY_DO_LABEL)
                                            ADD A,B
                                            DAA
                                            LD (VAR_SCORE),A
                                            POP HL
                                            INC HL
                                            PUSH HL
                                            LD A,(VAR_SCORE+1)
                                            ADC A,(HL)
                                            DAA
                                            LD (VAR_SCORE+1),A
                                            JP LAB_ram_6382
TEXT_SCORE:                                 db "YOU HAVE A SCORE OF ",0
CMD_GAME:                                   LD HL,TEXT_SCORE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            LD A,(VAR_SCORE+1)
                                            CALL PRINT_SCORE
                                            LD A,(VAR_SCORE)
                                            CALL PRINT_SCORE
                                            CALL SCREEN.PRINT_CR
                                            POP BC
                                            POP HL
                                            JP LAB_ram_60b7
PRINT_SCORE:                                PUSH AF
                                            RRA
                                            RRA
                                            RRA
                                            RRA
                                            CALL SCREEN.PRINT_DIGIT
                                            POP AF

CMD_DECODE:                                 PUSH HL
                                            LD HL,0x2020
                                            LD (VAR_VAR1),HL 
                                            LD (VAR_VAR2),HL 
                                            POP HL
                                            LD DE,VAR_VAR1 
                                            LD B,0x4 ; cmd length
CMD_DECODE_LOOP:                            LD A,(HL)
                                            CP 0x20
                                            JR Z,LABEL_LINE_DELIM
                                            CP 0x0
                                            JR Z,LABEL_LINE_DELIM
                                            CP 0xd
                                            JR Z,LABEL_LINE_DELIM
                                            LD (DE),A 
                                            INC HL
                                            INC DE
                                            DJNZ CMD_DECODE_LOOP
LABEL_LINE_DELIM:                           PUSH HL
                                            LD HL,COMMAND_LIST 
                                            LD A,0xff
                                            PUSH AF
LAB_ram_654e:                               LD (VAR_ITEMS_COUNTER),0x0
                                            LD B,0x4
                                            LD DE,VAR_VAR1 
LAB_ram_6557:                               LD A,(HL) 
                                            
                                            CP 0xff
                                            JR Z,LAB_ram_6571
                                            LD A,(DE) 
                                            CP (HL) 
                                            JR Z,LAB_ram_6564
                                            LD (VAR_ITEMS_COUNTER),0x1
LAB_ram_6564:                               INC HL
                                            INC DE
                                            DJNZ LAB_ram_6557
                                            XOR A
                                            CP (VAR_ITEMS_COUNTER)
                                            JR NZ,LAB_ram_6574
                                            POP AF
                                            LD A,(HL) 
                                            PUSH AF
LAB_ram_6571:                               POP AF
                                            POP HL
                                            RET
LAB_ram_6574:                               INC HL
                                            JR LAB_ram_654e
GAME_RESTORED:                              PUSH HL
                                            JR LAB_ram_658a
TEXT_READY_CASSETE:                         db "READY CASSETTE\r",0
LAB_ram_658a:                               LD HL,TEXT_READY_CASSETE 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            POP HL
                                            CALL WAIT_KEY
                                            PUSH IX
                                            LD IX,SAVE_BUFFER_PART1
                                            LD DE,0x29 ;size of save
                                            LD A,0xff
                                            SCF
                                            CALL 0x0556
                                            LD IX,ITEMS_BY_ROOM_TABLE
                                            LD DE,0x1d ;size of game state
                                            LD A,0xff
                                            SCF
                                            CALL 0x0556
                                            POP IX
                                            RET
GAME_INIT:                                  CALL INIT_SCREEN
                                            LD HL,TEXT_WELCOME 
                                            CALL SCREEN.PRINT_TEXT_WRAP
                                            JP WAIT_KEY
TEXT_WELCOME:                               db "WELCOME TO ADVENTURE 'A'\rTHE PLANET OF DEATH\r\rIN THIS ADVENTURE YOU FIND YOUR"
                                            db "SELF STRANDED ON AN ALIEN PLANET. YOUR AIM IS TO ESCAPE FROM THIS PLANET BY FIND"
                                            db "ING YOUR, NOW CAPTURED AND DISABLED, SPACE SHIP\rYOU WILL MEET VARIOUS HAZARDS A"
                                            db "ND DANGERS ON YOUR ADVENTURE, SOME NATURAL, SOME NOT, ALL OF WHICH YOU MUST OVER"
                                            db "COME TO SUCCEED\r\rGOOD LUCK, YOU WILL NEED IT!\r\rPRESS ANY KEY TO START\r",0
WAIT_KEY:                                   XOR A
                                            LD (KEYBOARD.LASTK),A
WRONG_KEY:                                  LD A,(KEYBOARD.LASTK)
                                            OR A
                                            JR Z,WRONG_KEY
                                            CP 0x90 ;
                                            JR NC,WRONG_KEY
                                            CP 0xc ; "Form Feed" - next CR
                                            JR C,WRONG_KEY
                                            CP 0x60 ; "`"
                                            RET C
                                            SUB 0x20 ; lower to caps
                                            RET
                                            db 0xD5
                                            db 0x57
                                            db 0x3E
                                            db 0x7F
                                            db 0xDB
                                            db 0xFE
                                            db 0x1F
                                            db 0x38
                                            db 0x0D
                                            db 0x3E
                                            db 0xFE
                                            db 0xDB
                                            db 0xFE
                                            db 0x1F
                                            db 0x38
                                            db 0x06
                                            db 0x3E
                                            db 0x01
                                            db 0xB7
LAB_ram_6787:                               LD A,D
                                            POP DE
                                            RET
                                            XOR A
                                            JR LAB_ram_6787
READ_LINE_START:                            PUSH HL
                                            LD B,0x20
INPUT_LINE_LOOP:                            LD (HL),0x0
                                            CALL WAIT_KEY
                                            CP 0xc ; delete
                                            JR NZ,INPUT_CHAR
                                            LD A,0x20
                                            CP B
                                            JR Z,INPUT_LINE_LOOP
                                            INC B
                                            DEC HL
INPUT_LINE_FULL:                            LD A,0x8
                                            CALL SCREEN.PRINT_CHAR
                                            LD A,0x20
                                            CALL SCREEN.PRINT_CHAR
                                            LD A,0x8
                                            CALL SCREEN.PRINT_CHAR
                                            JR INPUT_LINE_LOOP
INPUT_CHAR:                                 CALL SCREEN.PRINT_CHAR
                                            CP 0xd
                                            JR Z,INPUT_END_LINE
                                            INC B
                                            DEC B
                                            JR Z,INPUT_LINE_FULL
                                            DEC B
                                            LD (HL),A
                                            INC HL
                                            JR INPUT_LINE_LOOP
INPUT_END_LINE:                             POP HL
                                            RET
INIT_SCREEN:                                PUSH HL
                                            PUSH DE
                                            PUSH BC
                                            PUSH AF
                                            LD A, CLR_BLACK<<3 | CLR_GREEN
                                            CALL SCREEN.CLEAR
                                            POP AF
                                            POP BC
                                            POP DE
                                            POP HL
                                            RET
ROOM_DESC_POINTER:                          dw PLACE_MOUNTAIN_PLATEA 
                                            dw PLACE_EDGE_OF_A_DEEP_PIT 
                                            dw PLACE_DAMP_LIMESTONE_CAVE 
                                            dw PLACE_DENSE_FOREST 
                                            dw PLACE_BESIDE_A_LAKE 
                                            dw PLACE_STRANGE_HOUSE 
                                            dw PLACE_OLD_SHED 
                                            dw PLACE_MAZE 
                                            dw PLACE_MAZE 
                                            dw PLACE_MAZE 
                                            dw PLACE_MAZE 
                                            dw PLACE_ICE_CAVERN 
                                            dw PLACE_QUIET_CAVERN 
                                            dw PLACE_WIND_TUNNEL 
                                            dw PLACE_COMPUTER_ROOM 
                                            dw PLACE_PASSAGE 
                                            dw PLACE_LARGE_HANGER 
                                            dw PLACE_TALL_LIFT 
                                            dw PLACE_LIFT_CONTROL_ROOM 
                                            dw PLACE_PRISON_CELL 
                                            dw PLACE_SPACE_SHIP 
                                            dw 0x0000
PLACE_MOUNTAIN_PLATEA:                      db "I AM ON A MOUNTAIN PLATEAU\rTO THE NORTH THERE IS A STEEP CLIFF\rOBVIOUS EXITS A"
                                            db "RE DOWN,EAST AND WEST\r",0
PLACE_EDGE_OF_A_DEEP_PIT:                   db "I AM AT THE EDGE OF A DEEP PIT\rOBVIOUS EXITS ARE EAST\r",0
PLACE_DAMP_LIMESTONE_CAVE:                  db "I AM IN A DAMP LIMESTONE CAVE WITH STALACTITES HANGING DOWN.\rTHE EXIT IS TO THE"
                                            db " WEST\rTHERE IS A PASSAGE TO THE NORTH\r",0
PLACE_DENSE_FOREST:                         db "I AM IN A DENSE FOREST\rTHERE IS A ROPE HANGING FROM ONE TREE\rOBVIOUS EXITS ARE"
                                            db " SOUTH AND WEST\r",0
PLACE_BESIDE_A_LAKE:                        db "I AM BESIDE A LAKE\rEXITS ARE EAST AND NORTH.THERE IS A RAVINE TO THE WEST\r",0
PLACE_STRANGE_HOUSE:                        db "I AM IN A STRANGE HOUSE\rTHE DOOR IS TO THE NORTH\r",0
PLACE_OLD_SHED:                             db "I AM IN AN OLD SHED\rTHE EXIT IS TO THE EAST\r",0
PLACE_MAZE:                                 db "I AM IN A MAZE.THERE ARE PASSAGES EVERYWHERE\r",0
PLACE_ICE_CAVERN:                           db "I AM IN AN ICE CAVERN\rTHERE IS AN EXIT TO THE EAST\r",0
PLACE_QUIET_CAVERN:                         db "I AM IN A QUIET CAVERN\rTHERE ARE EXITS WEST,EAST AND SOUTH\r",0
PLACE_WIND_TUNNEL:                          db "I AM IN A WIND TUNNEL\rTHERE IS A CLOSED DOOR AT THE END\rTHERE IS ALSO AN EXIT "
                                            db "TO THE WEST\r",0
PLACE_COMPUTER_ROOM:                        db "I AM IN A ROOM WITH A COMPUTER IN\rTHE COMPUTER IS WORKING AND HAS A KEYBOARD\rT"
                                            db "HE EXIT IS WEST\r",0
PLACE_PASSAGE:                              db "I AM IN A PASSAGE\rTHERE IS A FORCE FIELD TO THE SOUTH : BEWARE OF SECURITY\rTHE"
                                            db "RE ARE EXITS TO NORTH,EAST AND WEST\r",0
PLACE_LARGE_HANGER:                         db "I AM IN A LARGE HANGER\rTHERE IS A LOCKED DOOR TO THE WEST\rTHERE ARE ALSO EXITS"
                                            db " EAST,NORTH AND SOUTH\r",0
PLACE_TALL_LIFT:                            db "I AM IN A TALL LIFT.THE BUTTONS ARE VERY HIGH\rTHE EXIT IS WEST\r",0
PLACE_LIFT_CONTROL_ROOM:                    db "I AM IN THE LIFT CONTROL ROOM\rTHERE ARE THREE SWITCHES ON THE WALL.THEY ARE ALL"
                                            db " OFF\rA SIGN SAYS : 5,4 NO DUSTY BIN RULES\rTHE EXIT IS EAST\r",0
PLACE_PRISON_CELL:                          db "I AM IN A PRISON CELL\r",0
PLACE_SPACE_SHIP:                           db "I AM IN A SPACE SHIP.THERE IS NO VISIBLE EXIT\rTHERE IS A SMALL OPEN WINDOW IN T"
                                            db "HE SIDE\rTHERE ARE ALSO TWO BUTTONS,ONE MARKED MAIN AND THE OTHER AUX.\r",0
ITEMS_BY_ROOM_TABLE_INIT:                            
                                            db 0x05 ; value = room number, where item is placed
                                            db 0x11
                                            db 0x0E
                                            db 0x06
                                            db 0x11
                                            db 0xFC
                                            db 0xFC
                                            db 0x0C
                                            db 0xFC
                                            db 0x0D
                                            db 0xFC
                                            db 0x05
                                            db 0xFC
                                            db 0xFC
                                            db 0x0B
                                            db 0xFC
                                            db 0x0C
                                            db 0xFC
                                            db 0x13
                                            db 0xFC
                                            db 0x13
                                            db 0xFC
                                            db 0x10
                                            db 0x10
                                            db 0x00
                                            db 0x01
                                            db 0x02
                                            db 0x0F
                                            db 0xFF
ITEMS_BY_ROOM_TABLE:                        ds 0x1d ; current state of items

ITEM_DESC_POINTER:                          dw OBJECT_A_PAIR_OF_BOOTS 
                                            dw OBJECT_A_STARTER_MOTOR 
                                            dw OBJECT_A_KEY 
                                            dw OBJECT_A_LASER_GUN 
                                            dw OBJECT_AN_OUT_OF_ORDER_SIGN 
                                            dw OBJECT_A_METAL_BAR 
                                            dw OBJECT_A_GOLD_COIN 
                                            dw OBJECT_A_MIRROR 
                                            dw OBJECT_BROKEN_GLASS 
                                            dw OBJECT_A_PAIR_OF_SLIMY_GLOVES 
                                            dw OBJECT_A_ROPE 
                                            dw OBJECT_A_FLOOR_BOARD 
                                            dw OBJECT_A_BROKEN_FLOOR_BOARD 
                                            dw OBJECT_STALACTITES 
                                            dw OBJECT_A_BLOCK_OF_ICE 
                                            dw OBJECT_A_POOL_OF_WATER 
                                            dw OBJECT_A_SMALL_GREEN_MAN_SLEEPING 
                                            dw OBJECT_A_SLEEPING_GREEN_MAN 
                                            dw OBJECT_A_LOCKED_DOOR 
                                            dw OBJECT_AN_OPEN_DOOR 
                                            dw OBJECT_A_BARRED_WINDOW 
                                            dw OBJECT_A_HOLE_IN_THE_WALL 
                                            dw OBJECT_A_SMALL_BUT_POWERFULL_SPACE_SHIP 
                                            dw OBJECT_A_SLEEPING_SECURITY_MAN 
                                            dw OBJECT_A_PIECE_OF_SHARP_FLINT 
                                            dw OBJECT_SOME_STONES 
                                            dw OBJECT_A_DRAWING_ON_THE_WALL 
                                            dw OBJECT_A_LOUDSPEAKER_WITH_DANCE_MUSIC 
                                            dw 0x0000
OBJECT_A_PAIR_OF_BOOTS:                     db "A PAIR OF BOOTS",0
OBJECT_A_STARTER_MOTOR:                     db "A STARTER MOTOR",0
OBJECT_A_KEY:                               db "A KEY",0
OBJECT_A_LASER_GUN:                         db "A LASER GUN",0
OBJECT_AN_OUT_OF_ORDER_SIGN:                db "AN OUT OF ORDER SIGN",0
OBJECT_A_METAL_BAR:                         db "A METAL BAR",0
OBJECT_A_GOLD_COIN:                         db "A GOLD COIN",0
OBJECT_A_MIRROR:                            db "A MIRROR",0
OBJECT_BROKEN_GLASS:                        db "BROKEN GLASS",0
OBJECT_A_PAIR_OF_SLIMY_GLOVES:              db "A PAIR OF SLIMY GLOVES",0
OBJECT_A_ROPE:                              db "A ROPE",0
OBJECT_A_FLOOR_BOARD:                       db "A FLOOR BOARD",0
OBJECT_A_BROKEN_FLOOR_BOARD:                db "A BROKEN FLOOR BOARD",0
OBJECT_STALACTITES:                         db "STALACTITES",0
OBJECT_A_BLOCK_OF_ICE:                      db "A BLOCK OF ICE",0
OBJECT_A_POOL_OF_WATER:                     db "A POOL OF WATER",0
OBJECT_A_SMALL_GREEN_MAN_SLEEPING:          db "A SMALL GREEN MAN SLEEPING ON THE MIRROR",0
OBJECT_A_SLEEPING_GREEN_MAN:                db "A SLEEPING GREEN MAN",0
OBJECT_A_LOCKED_DOOR:                       db "A LOCKED DOOR",0
OBJECT_AN_OPEN_DOOR:                        db "AN OPEN DOOR",0
OBJECT_A_BARRED_WINDOW:                     db "A BARRED WINDOW",0
OBJECT_A_HOLE_IN_THE_WALL:                  db "A HOLE IN THE WALL",0
OBJECT_A_SMALL_BUT_POWERFULL_SPACE_SHIP:    db "A SMALL BUT POWERFULL SPACE SHIP",0
OBJECT_A_SLEEPING_SECURITY_MAN:             db "A SLEEPING SECURITY MAN",0
OBJECT_A_PIECE_OF_SHARP_FLINT:              db "A PIECE OF SHARP FLINT",0
OBJECT_SOME_STONES:                         db "SOME STONES",0
OBJECT_A_DRAWING_ON_THE_WALL:               db "A DRAWING ON THE WALL",0
OBJECT_A_LOUDSPEAKER_WITH_DANCE_MUSIC:      db "A LOUDSPEAKER WITH DANCE MUSIC COMING OUT",0
COMMAND_LIST:                               db "DOWN"
                                            db 0x01
                                            db "D   "
                                            db 0x01
                                            db "NORT"
                                            db 0x02
                                            db "N   "
                                            db 0x02
                                            db "SOUT"
                                            db 0x03
                                            db "S   "
                                            db 0x03
                                            db "EAST"
                                            db 0x04
                                            db "E   "
                                            db 0x04
                                            db "WEST"
                                            db 0x05
                                            db "W   "
                                            db 0x05
                                            db "GET "
                                            db 0x0D
                                            db "PICK"
                                            db 0x0D
                                            db "DROP"
                                            db 0x0E
                                            db "PUT "
                                            db 0x0E
                                            db "FIRE"
                                            db 0x0F
                                            db "SHOO"
                                            db 0x0F
                                            db "BOOT"
                                            db 0x10
                                            db "STAR"
                                            db 0x11
                                            db "MOTO"
                                            db 0x11
                                            db "KEY "
                                            db 0x12
                                            db "LASE"
                                            db 0x13
                                            db "GUN "
                                            db 0x13
                                            db "USED"
                                            db 0x14
                                            db "BAR "
                                            db 0x15
                                            db "BARS"
                                            db 0x15
                                            db "GOLD"
                                            db 0x16
                                            db "COIN"
                                            db 0x16
                                            db "MIRR"
                                            db 0x17
                                            db "BROK"
                                            db 0x18
                                            db "GLOV"
                                            db 0x19
                                            db "ROPE"
                                            db 0x1A
                                            db "FLOO"
                                            db 0x1B
                                            db "BOAR"
                                            db 0x1B
                                            db "PLAN"
                                            db 0x1B
                                            db "STAL"
                                            db 0x1C
                                            db "BLOC"
                                            db 0x1D
                                            db "ICE "
                                            db 0x1D
                                            db "POOL"
                                            db 0x1E
                                            db "WATE"
                                            db 0x1E
                                            db "LAKE"
                                            db 0x1E
                                            db "SLEE"
                                            db 0x1F
                                            db "GREE"
                                            db 0x1F
                                            db "MAN "
                                            db 0x1F
                                            db "DOOR"
                                            db 0x20
                                            db "OPEN"
                                            db 0x21
                                            db "UNLO"
                                            db 0x21
                                            db "WIND"
                                            db 0x22
                                            db "SMAL"
                                            db 0x23
                                            db "SPAC"
                                            db 0x23
                                            db "SHIP"
                                            db 0x23
                                            db "SECU"
                                            db 0x24
                                            db "FLIN"
                                            db 0x25
                                            db "STON"
                                            db 0x26
                                            db "DRAW"
                                            db 0x27
                                            db "HELP"
                                            db 0x28
                                            db "INVE"
                                            db 0x29
                                            db "I   "
                                            db 0x29
                                            db "QUIT"
                                            db 0x2A
                                            db "STOP"
                                            db 0x2A
                                            db "ABOR"
                                            db 0x2A
                                            db "YES "
                                            db 0x2B
                                            db "Y   "
                                            db 0x2B
                                            db "NO  "
                                            db 0x2C
                                            db "COMP"
                                            db 0x2D
                                            db "KEYB"
                                            db 0x2D
                                            db "TYPE"
                                            db 0x2E
                                            db "TURN"
                                            db 0x2F
                                            db "HAND"
                                            db 0x30
                                            db "KILL"
                                            db 0x31
                                            db "DANC"
                                            db 0x32
                                            db "WALT"
                                            db 0x32
                                            db "REMO"
                                            db 0x33
                                            db "KICK"
                                            db 0x34
                                            db "BREA"
                                            db 0x34
                                            db "HIT "
                                            db 0x34
                                            db "BANG"
                                            db 0x34
                                            db "BRIB"
                                            db 0x35
                                            db "USE "
                                            db 0x36
                                            db "WITH"
                                            db 0x36
                                            db "PUSH"
                                            db 0x37
                                            db "THRE"
                                            db 0x38
                                            db "3   "
                                            db 0x38
                                            db "TWO "
                                            db 0x39
                                            db "2   "
                                            db 0x39
                                            db "ONE "
                                            db 0x3A
                                            db "1   "
                                            db 0x3A
                                            db "MEND"
                                            db 0x3B
                                            db "FIX "
                                            db 0x3B
                                            db "REPA"
                                            db 0x3B
                                            db "FOUR"
                                            db 0x3C
                                            db "4   "
                                            db 0x3C
                                            db "LOOK"
                                            db 0x3D
                                            db "STAN"
                                            db 0x3E
                                            db "TREE"
                                            db 0x3F
                                            db "CUT "
                                            db 0x40
                                            db "SAW "
                                            db 0x40
                                            db "WEAR"
                                            db 0x41
                                            db "CROS"
                                            db 0x42
                                            db "JUMP"
                                            db 0x43
                                            db "RAVI"
                                            db 0x44
                                            db "UP  "
                                            db 0x45
                                            db "U   "
                                            db 0x45
                                            db "CLIM"
                                            db 0x45
                                            db "FUSE"
                                            db 0x46
                                            db "REDE"
                                            db 0x47
                                            db "R   "
                                            db 0x47
                                            db "MAIN"
                                            db 0x48
                                            db "AUX "
                                            db 0x49
                                            db "FIEL"
                                            db 0x4A
                                            db "SHIE"
                                            db 0x4A
                                            db 0xFF
BYTE_ram_72b7:                              db 0xFF
BYTE_ram_72b8:                              db 0x01
                                            db 0x00
                                            db 0xFF
BYTE_ram_72bb:                              db 0x01
                                            db 0x01
                                            db 0xFF
BYTE_ram_72be:                              db 0x01
                                            db 0x02
                                            db 0xFF
BYTE_ram_72c1:                              db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_72c4:                              db 0x01
                                            db 0x05
                                            db 0xFF
BYTE_ram_72c7:                              db 0x01
                                            db 0x06
                                            db 0xFF
BYTE_ram_72ca:                              db 0x01
                                            db 0x07
                                            db 0x03
                                            db 0x10
                                            db 0xFF
BYTE_ram_72cf:                              db 0x01
                                            db 0x08
                                            db 0xFF
BYTE_ram_72d2:                              db 0x01
                                            db 0x09
                                            db 0xFF
BYTE_ram_72d5:                              db 0x01
                                            db 0x0A
                                            db 0xFF
BYTE_ram_72d8:                              db 0x01
                                            db 0x0B
                                            db 0xFF
BYTE_ram_72db:                              db 0x01
                                            db 0x0C
                                            db 0xFF
BYTE_ram_72de:                              db 0x01
                                            db 0x0D
                                            db 0xFF
BYTE_ram_72e1:                              db 0x01
                                            db 0x0E
                                            db 0xFF
BYTE_ram_72e4:                              db 0x01
                                            db 0x18
                                            db 0xFF
BYTE_ram_72e7:                              db 0x01
                                            db 0x19
                                            db 0xFF
BYTE_ram_72ea:                              db 0x01
                                            db 0x07
                                            db 0xFF
BYTE_ram_72ed:                              db 0x00
                                            db 0x02
                                            db 0xFF
BYTE_ram_72f0:                              db 0x00
                                            db 0x02
                                            db 0x01
                                            db 0x0E
                                            db 0xFF
BYTE_ram_72f5:                              db 0x00
                                            db 0x03
                                            db 0xFF
BYTE_ram_72f8:                              db 0x00
                                            db 0x03
                                            db 0x01
                                            db 0x18
                                            db 0xFF
BYTE_ram_72fd:                              db 0x00
                                            db 0x04
                                            db 0xFF
BYTE_ram_7300:                              db 0x00
                                            db 0x06
                                            db 0xFF
BYTE_ram_7303:                              db 0x00
                                            db 0x04
                                            db 0x01
                                            db 0x0B
                                            db 0xFF
BYTE_ram_7308:                              db 0x00
                                            db 0x06
                                            db 0x01
                                            db 0x0B
                                            db 0xFF
BYTE_ram_730d:                              db 0x00
                                            db 0x0B
                                            db 0xFF
BYTE_ram_7310:                              db 0x00
                                            db 0x0B
                                            db 0x08
                                            db 0x0E
                                            db 0xFF
BYTE_ram_7315:                              db 0x01
                                            db 0x10
                                            db 0x01
                                            db 0x09
                                            db 0x04
                                            db 0x09
                                            db 0xFF
BYTE_ram_731c:                              db 0x01
                                            db 0x10
                                            db 0x01
                                            db 0x09
                                            db 0xFF
BYTE_ram_7321:                              db 0x01
                                            db 0x10
                                            db 0xFF
BYTE_ram_7324:                              db 0x01
                                            db 0x11
                                            db 0xFF
BYTE_ram_7327:                              db 0x01
                                            db 0x07
                                            db 0x03
                                            db 0x10
                                            db 0xFF
BYTE_ram_732c:                              db 0x01
                                            db 0x10
                                            db 0xFF
BYTE_ram_732f:                              db 0x01
                                            db 0x10
                                            db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_7334:                              db 0x01
                                            db 0x11
                                            db 0x01
                                            db 0x03
                                            db 0x08
                                            db 0x11
                                            db 0xFF
BYTE_ram_733b:                              db 0x01
                                            db 0x11
                                            db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_7340:                              db 0x00
                                            db 0x0E
                                            db 0xFF
BYTE_ram_7343:                              db 0x00
                                            db 0x0F
                                            db 0xFF
BYTE_ram_7346:                              db 0x00
                                            db 0x0F
                                            db 0x07
                                            db 0x07
                                            db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_734d:                              db 0x05
                                            db 0x07
                                            db 0x07
                                            db 0x08
                                            db 0x00
                                            db 0x0F
                                            db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_7356:                              db 0x05
                                            db 0x08
                                            db 0x00
                                            db 0x0F
                                            db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_735d:                              db 0x00
                                            db 0x0F
                                            db 0x08
                                            db 0x07
                                            db 0x05
                                            db 0x08
                                            db 0xFF
BYTE_ram_7364:                              db 0x00
                                            db 0x0F
                                            db 0xFF
BYTE_ram_7367:                              db 0x00
                                            db 0x10
                                            db 0xFF
BYTE_ram_736a:                              db 0x00
                                            db 0x10
                                            db 0x01
                                            db 0x02
                                            db 0xFF
BYTE_ram_736f:                              db 0x00
                                            db 0x10
                                            db 0x01
                                            db 0x03
                                            db 0xFF
BYTE_ram_7374:                              db 0x00
                                            db 0x13
                                            db 0xFF
BYTE_ram_7377:                              db 0x02
                                            db 0x00
                                            db 0x0D
BYTE_ram_737a:                              db 0x02
                                            db 0x01
                                            db 0x0D
BYTE_ram_737d:                              db 0x02
                                            db 0x02
                                            db 0x0D
BYTE_ram_7380:                              db 0x02
                                            db 0x03
                                            db 0x0D
BYTE_ram_7383:                              db 0x02
                                            db 0x05
                                            db 0x0D
BYTE_ram_7386:                              db 0x02
                                            db 0x06
                                            db 0x0D
BYTE_ram_7389:                              db 0x02
                                            db 0x07
                                            db 0x0D
BYTE_ram_738c:                              db 0x02
                                            db 0x08
                                            db 0x0D
BYTE_ram_738f:                              db 0x02
                                            db 0x09
                                            db 0x0D
BYTE_ram_7392:                              db 0x02
                                            db 0x0A
                                            db 0x0D
BYTE_ram_7395:                              db 0x02
                                            db 0x0B
                                            db 0x0D
BYTE_ram_7398:                              db 0x02
                                            db 0x0C
                                            db 0x0D
BYTE_ram_739b:                              db 0x02
                                            db 0x0D
                                            db 0x0D
BYTE_ram_739e:                              db 0x02
                                            db 0x0E
                                            db 0x0F
                                            db 0x02
                                            db 0x09
                                            db 0x0D
BYTE_ram_73a4:                              db 0x02
                                            db 0x18
                                            db 0x0D
BYTE_ram_73a7:                              db 0x02
                                            db 0x19
                                            db 0x0D
BYTE_ram_73aa:                              db 0x00
                                            db 0x07
BYTE_ram_73ac:                              db 0x0E
BYTE_ram_73ad:                              db 0x03
                                            db 0x00
                                            db 0x0D
BYTE_ram_73b0:                              db 0x03
                                            db 0x01
                                            db 0x0D
BYTE_ram_73b3:                              db 0x03
                                            db 0x02
                                            db 0x0D
BYTE_ram_73b6:                              db 0x03
                                            db 0x03
                                            db 0x0D
BYTE_ram_73b9:                              db 0x03
                                            db 0x05
                                            db 0x0D
BYTE_ram_73bc:                              db 0x03
                                            db 0x06
                                            db 0x0D
BYTE_ram_73bf:                              db 0x03
                                            db 0x07
                                            db 0x0D
BYTE_ram_73c2:                              db 0x03
                                            db 0x08
                                            db 0x0D
BYTE_ram_73c5:                              db 0x03
                                            db 0x09
                                            db 0x0D
BYTE_ram_73c8:                              db 0x03
                                            db 0x0A
                                            db 0x0D
BYTE_ram_73cb:                              db 0x03
                                            db 0x0B
                                            db 0x0D
BYTE_ram_73ce:                              db 0x03
                                            db 0x0C
                                            db 0x0D
BYTE_ram_73d1:                              db 0x03
                                            db 0x0D
                                            db 0x0D
BYTE_ram_73d4:                              db 0x03
                                            db 0x0E
                                            db 0x0D
BYTE_ram_73d7:                              db 0x03
                                            db 0x18
                                            db 0x0D
BYTE_ram_73da:                              db 0x03
                                            db 0x19
                                            db 0x0D
BYTE_ram_73dd:                              db 0x05
                                            db 0x00
                                            db 0x07
BYTE_ram_73e0:                              db 0x05
                                            db 0x01
                                            db 0x07
BYTE_ram_73e3:                              db 0x10
                                            db 0x0D
                                            db 0x05
                                            db 0x02
                                            db 0x07
BYTE_ram_73e8:                              db 0x05
                                            db 0x03
                                            db 0x07
BYTE_ram_73eb:                              db 0x10
                                            db 0x0A
                                            db 0x05
                                            db 0x02
                                            db 0x07
BYTE_ram_73f0:                              db 0x04
                                            db 0x00
                                            db 0x0D
BYTE_ram_73f3:                              db 0x01
                                            db 0x00
                                            db 0x0D
BYTE_ram_73f6:                              db 0x05
                                            db 0x03
                                            db 0x07
BYTE_ram_73f9:                              db 0x08
                                            db 0x06
                                            db 0x06
BYTE_ram_73fc:                              db 0x08
                                            db 0x04
                                            db 0x11
                                            db 0x0B
                                            db 0x10
                                            db 0x0C
                                            db 0x06
BYTE_ram_7403:                              db 0x05
                                            db 0x04
                                            db 0x0C
BYTE_ram_7406:                              db 0x08
                                            db 0x0C
                                            db 0x03
                                            db 0x0E
                                            db 0x0B
                                            db 0x0E
                                            db 0x0F
                                            db 0x02
                                            db 0x07
                                            db 0x06
BYTE_ram_7410:                              db 0x02
                                            db 0x10
                                            db 0x0B
                                            db 0x10
                                            db 0x05
                                            db 0x05
                                            db 0x0F
                                            db 0x05
                                            db 0x0A
                                            db 0x0A
                                            db 0x06
                                            db 0x07
BYTE_ram_741c:                              db 0x02
                                            db 0x10
                                            db 0x0B
                                            db 0x10
                                            db 0x0D
BYTE_ram_7421:                              db 0x03
                                            db 0x11
                                            db 0x0D
BYTE_ram_7424:                              db 0x02
                                            db 0x07
                                            db 0x0D
BYTE_ram_7427:                              db 0x02
                                            db 0x08
                                            db 0x0D
BYTE_ram_742a:                              db 0x03
                                            db 0x07
                                            db 0x0D
BYTE_ram_742d:                              db 0x03
                                            db 0x08
                                            db 0x0D
BYTE_ram_7430:                              db 0x05
                                            db 0x03
                                            db 0x07
BYTE_ram_7433:                              db 0x11
                                            db 0x10
                                            db 0x0B
                                            db 0x07
                                            db 0x05
                                            db 0x06
                                            db 0x05
                                            db 0x07
                                            db 0x07
BYTE_ram_743c:                              db 0x05
                                            db 0x26
                                            db 0x07
BYTE_ram_743f:                              db 0x11
                                            db 0x11
                                            db 0x05
                                            db 0x06
                                            db 0x07
BYTE_ram_7444:                              db 0x05
                                            db 0x08
                                            db 0x07
BYTE_ram_7447:                              db 0x09
                                            db 0x07
                                            db 0x05
                                            db 0x09
                                            db 0x07
BYTE_ram_744c:                              db 0x09
                                            db 0x08
                                            db 0x05
                                            db 0x09
                                            db 0x07
BYTE_ram_7451:                              db 0x05
                                            db 0x0A
                                            db 0x07
BYTE_ram_7454:                              db 0x08
                                            db 0x10
                                            db 0x0F
                                            db 0x02
                                            db 0x09
                                            db 0x06
BYTE_ram_745a:                              db 0x05
                                            db 0x0B
                                            db 0x08
                                            db 0x13
                                            db 0x06
BYTE_ram_745f:                              db 0x08
                                            db 0x12
                                            db 0x06
BYTE_ram_7462:                              db 0x11
                                            db 0x17
                                            db 0x0D
BYTE_ram_7465:                              db 0x05
                                            db 0x0C
                                            db 0x07
BYTE_ram_7468:                              db 0x0B
                                            db 0x14
                                            db 0x10
                                            db 0x05
                                            db 0x06
DIR_TABLE:                                  db 0x0D
                                            db 0x10
                                            dw BYTE_ram_72b8 
                                            dw BYTE_ram_7377 
                                            db 0x0D
                                            db 0x11
                                            dw BYTE_ram_72bb 
                                            dw BYTE_ram_737a 
                                            db 0x0D
                                            db 0x12
                                            dw BYTE_ram_72be 
                                            dw BYTE_ram_737d 
                                            db 0x0D
                                            db 0x13
                                            dw BYTE_ram_72c1 
                                            dw BYTE_ram_7380 
                                            db 0x0D
                                            db 0x15
                                            dw BYTE_ram_72c4 
                                            dw BYTE_ram_7383 
                                            db 0x0D
                                            db 0x16
                                            dw BYTE_ram_72c7 
                                            dw BYTE_ram_7386 
                                            db 0x0D
                                            db 0x17
                                            dw BYTE_ram_72ca 
                                            dw BYTE_ram_7389 
                                            db 0x0D
                                            db 0x17
                                            dw BYTE_ram_72cf 
                                            dw BYTE_ram_738c 
                                            db 0x0D
                                            db 0x18
                                            dw BYTE_ram_72cf 
                                            dw BYTE_ram_738c 
                                            db 0x0D
                                            db 0x19
                                            dw BYTE_ram_72d2 
                                            dw BYTE_ram_738f 
                                            db 0x0D
                                            db 0x1A
                                            dw BYTE_ram_72d5 
                                            dw BYTE_ram_7392 
                                            db 0x0D
                                            db 0x1B
                                            dw BYTE_ram_72d8 
                                            dw BYTE_ram_7395 
                                            db 0x0D
                                            db 0x1B
                                            dw BYTE_ram_72db 
                                            dw BYTE_ram_7398 
                                            db 0x0D
                                            db 0x18
                                            dw BYTE_ram_72db 
                                            dw BYTE_ram_7398 
                                            db 0x0D
                                            db 0x1C
                                            dw BYTE_ram_72de 
                                            dw BYTE_ram_739b 
                                            db 0x0D
                                            db 0x1D
                                            dw BYTE_ram_72e1 
                                            dw BYTE_ram_739e 
                                            db 0x0D
                                            db 0x25
                                            dw BYTE_ram_72e4 
                                            dw BYTE_ram_73a4 
                                            db 0x0D
                                            db 0x26
                                            dw BYTE_ram_72e7 
                                            dw BYTE_ram_73a7 
                                            db 0x29
                                            db 0xFF
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_73aa
                                            db 0x2A
                                            db 0xFF
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_73ac 
                                            db 0x0E
                                            db 0x10
                                            dw BYTE_ram_72b8 
                                            dw BYTE_ram_73ad 
                                            db 0x0E
                                            db 0x11
                                            dw BYTE_ram_72bb 
                                            dw BYTE_ram_73b0 
                                            db 0x0E
                                            db 0x12
                                            dw BYTE_ram_72be 
                                            dw BYTE_ram_73b3 
                                            db 0x0E
                                            db 0x13
                                            dw BYTE_ram_72c1 
                                            dw BYTE_ram_73b6 
                                            db 0x0E
                                            db 0x15
                                            dw BYTE_ram_72c4 
                                            dw BYTE_ram_73b9 
                                            db 0x0E
                                            db 0x16
                                            dw BYTE_ram_72c7 
                                            dw BYTE_ram_73bc 
                                            db 0x0E
                                            db 0x17
                                            dw BYTE_ram_72ea 
                                            dw BYTE_ram_73bf 
                                            db 0x0E
                                            db 0x17
                                            dw BYTE_ram_72cf 
                                            dw BYTE_ram_73c2 
                                            db 0x0E
                                            db 0x18
                                            dw BYTE_ram_72cf 
                                            dw BYTE_ram_73c2 
                                            db 0x0E
                                            db 0x19
                                            dw BYTE_ram_72d2 
                                            dw BYTE_ram_73c5 
                                            db 0x0E
                                            db 0x1A
                                            dw BYTE_ram_72d5 
                                            dw BYTE_ram_73c8 
                                            db 0x0E
                                            db 0x1B
                                            dw BYTE_ram_72d8 
                                            dw BYTE_ram_73cb 
                                            db 0x0E
                                            db 0x1B
                                            dw BYTE_ram_72db 
                                            dw BYTE_ram_73ce 
                                            db 0x0F
                                            db 0x18
                                            dw BYTE_ram_72db 
                                            dw BYTE_ram_73ce 
                                            db 0x0E
                                            db 0x1C
                                            dw BYTE_ram_72de 
                                            dw BYTE_ram_73d1 
                                            db 0x0E
                                            db 0x1D
                                            dw BYTE_ram_72e1 
                                            dw BYTE_ram_73d4 
                                            db 0x0E
                                            db 0x25
                                            dw BYTE_ram_72e4 
                                            dw BYTE_ram_73d7 
                                            db 0x0E
                                            db 0x26
                                            dw BYTE_ram_72e7 
                                            dw BYTE_ram_73da 
                                            db 0x3D
                                            db 0x27
                                            dw BYTE_ram_72ed
                                            dw BYTE_ram_73dd 
                                            db 0x34
                                            db 0x1C
                                            dw BYTE_ram_72ed
                                            dw BYTE_ram_73e0 
                                            db 0x36
                                            db 0x1D
                                            dw BYTE_ram_72f0
                                            dw BYTE_ram_73e3 
                                            db 0x40
                                            db 0x1A
                                            dw BYTE_ram_72f5
                                            dw BYTE_ram_73e8 
                                            db 0x36
                                            db 0x25
                                            dw BYTE_ram_72f8
                                            dw BYTE_ram_73eb 
                                            db 0x41
                                            db 0x10
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_73f0 
                                            db 0x33
                                            db 0x10
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_73f3 
                                            db 0x42
                                            db 0x44
                                            dw BYTE_ram_72fd
                                            dw BYTE_ram_73f6 
                                            db 0x42
                                            db 0x44
                                            dw BYTE_ram_7300
                                            dw BYTE_ram_73f6 
                                            db 0x36
                                            db 0x1B
                                            dw BYTE_ram_7303
                                            dw BYTE_ram_73f9 
                                            db 0x36
                                            db 0x1B
                                            dw BYTE_ram_7308
                                            dw BYTE_ram_73fc 
                                            db 0x43
                                            db 0x44
                                            dw BYTE_ram_7303
                                            dw BYTE_ram_7403 
                                            db 0x43
                                            db 0x44
                                            dw BYTE_ram_7300
                                            dw BYTE_ram_7403 
                                            db 0x01
                                            db 0xFF
                                            dw BYTE_ram_730d
                                            dw BYTE_ram_73f6 
                                            db 0x36
                                            db 0x1D
                                            dw BYTE_ram_7310
                                            dw BYTE_ram_7406 
                                            db 0x0D
                                            db 0x1F
                                            dw BYTE_ram_7315 
                                            dw BYTE_ram_7410 
                                            db 0x0D
                                            db 0x1F
                                            dw BYTE_ram_731c 
                                            dw BYTE_ram_741c 
                                            db 0x0D
                                            db 0x1F
                                            dw BYTE_ram_7321 
                                            dw BYTE_ram_7410 
                                            db 0x0E
                                            db 0x1F
                                            dw BYTE_ram_7324 
                                            dw BYTE_ram_7421 
                                            db 0x0D
                                            db 0x17
                                            dw BYTE_ram_7327 
                                            dw BYTE_ram_7424 
                                            db 0x0D
                                            db 0x18
                                            dw BYTE_ram_72cf 
                                            dw BYTE_ram_7427 
                                            db 0x0E
                                            db 0x17
                                            dw BYTE_ram_72ea 
                                            dw BYTE_ram_742a 
                                            db 0x0E
                                            db 0x18
                                            dw BYTE_ram_72cf 
                                            dw BYTE_ram_742d 
                                            db 0x31
                                            db 0x1F
                                            dw BYTE_ram_732c 
                                            dw BYTE_ram_7430 
                                            db 0x31
                                            db 0x1F
                                            dw BYTE_ram_7324 
                                            dw BYTE_ram_7430 
                                            db 0x36
                                            db 0x13
                                            dw BYTE_ram_732f 
                                            dw BYTE_ram_7433 
                                            db 0x36
                                            db 0x13
                                            dw BYTE_ram_7334 
                                            dw BYTE_ram_743c 
                                            db 0x36
                                            db 0x13
                                            dw BYTE_ram_733b 
                                            dw BYTE_ram_743f 
                                            db 0x2E
                                            db 0x28
                                            dw BYTE_ram_7340
                                            dw BYTE_ram_7444 
                                            db 0x0F
                                            db 0x13
                                            dw BYTE_ram_7343
                                            dw BYTE_ram_743c 
                                            db 0x4A
                                            db 0xFF
                                            dw BYTE_ram_7346
                                            dw BYTE_ram_7447 
                                            db 0x4A
                                            db 0xFF
                                            dw BYTE_ram_734d 
                                            dw BYTE_ram_744c 
                                            db 0x4A
                                            db 0xFF
                                            dw BYTE_ram_7356 
                                            dw BYTE_ram_7451 
                                            db 0x32
                                            db 0xFF
                                            dw BYTE_ram_735d
                                            dw BYTE_ram_7454 
                                            db 0x32
                                            db 0xFF
                                            dw BYTE_ram_7364
                                            dw BYTE_ram_745a 
                                            db 0x21
                                            db 0x20
                                            dw BYTE_ram_7367
                                            dw BYTE_ram_7430 
                                            db 0x36
                                            db 0x12
                                            dw BYTE_ram_736a
                                            dw BYTE_ram_745f 
                                            db 0x31
                                            db 0x24
                                            dw BYTE_ram_736f
                                            dw BYTE_ram_7462 
                                            db 0x3D
                                            db 0x45
                                            dw BYTE_ram_7374
                                            dw BYTE_ram_7465 
                                            db 0x34
                                            db 0x15
                                            dw BYTE_ram_7374
                                            dw BYTE_ram_7468 
                                            db 0x45
                                            db 0xFF
                                            dw BYTE_ram_775c
                                            dw BYTE_ram_77ff 
                                            db 0x35
                                            db 0x24
                                            dw BYTE_ram_7761
                                            dw BYTE_ram_7804 
                                            db 0x36
                                            db 0x16
                                            dw BYTE_ram_7764
                                            dw BYTE_ram_7807 
                                            db 0x20
                                            db 0xFF
                                            dw BYTE_ram_7769
                                            dw BYTE_ram_780c 
                                            db 0x3D
                                            db 0x1E
                                            dw BYTE_ram_776e
                                            dw BYTE_ram_7811 
                                            db 0x0D
                                            db 0x16
                                            dw BYTE_ram_776e
                                            dw BYTE_ram_7814 
                                            db 0x1E
                                            db 0xFF
                                            dw BYTE_ram_7773
                                            dw BYTE_ram_781a 
                                            db 0x1E
                                            db 0xFF
                                            dw BYTE_ram_777c
                                            dw BYTE_ram_7817 
                                            db 0x1E
                                            db 0xFF
                                            dw BYTE_ram_776e
                                            dw BYTE_ram_781f 
                                            db 0x21
                                            db 0x20
                                            dw BYTE_ram_7783
                                            dw BYTE_ram_7822 
                                            db 0x37
                                            db 0x38
                                            dw BYTE_ram_7786
                                            dw BYTE_ram_7825 
                                            db 0x37
                                            db 0x38
                                            dw BYTE_ram_778d
                                            dw BYTE_ram_7829 
                                            db 0x37
                                            db 0x39
                                            dw BYTE_ram_7792
                                            dw BYTE_ram_7830 
                                            db 0x37
                                            db 0x39
                                            dw BYTE_ram_778d
                                            dw BYTE_ram_7829 
                                            db 0x37
                                            db 0x3A
                                            dw BYTE_ram_779a
                                            dw BYTE_ram_7834 
                                            db 0x37
                                            db 0x3A
                                            dw BYTE_ram_778d
                                            dw BYTE_ram_7829 
                                            db 0x3B
                                            db 0x46
                                            dw BYTE_ram_77a2
                                            dw BYTE_ram_783a 
                                            db 0x36
                                            db 0x15
                                            dw BYTE_ram_77a7
                                            dw BYTE_ram_783d 
                                            db 0x3D
                                            db 0xFF
                                            dw BYTE_ram_77ae
                                            dw BYTE_ram_7842 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77b1
                                            dw BYTE_ram_7845 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77b4
                                            dw BYTE_ram_7848 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77b7
                                            dw BYTE_ram_784b 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77ba
                                            dw BYTE_ram_784e 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77bd
                                            dw BYTE_ram_784e 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77c0
                                            dw BYTE_ram_784e 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77c3
                                            dw BYTE_ram_784e 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_77c6
                                            dw BYTE_ram_7845 
                                            db 0x3D
                                            db 0x45
                                            dw BYTE_ram_77cb 
                                            dw BYTE_ram_7851 
                                            db 0x05
                                            db 0xFF
                                            dw BYTE_ram_77d0
                                            dw BYTE_ram_7854 
                                            db 0x02
                                            db 0xFF
                                            dw BYTE_ram_77b4
                                            dw BYTE_ram_7854 
                                            db 0x41
                                            db 0x19
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_785a 
                                            db 0x33
                                            db 0x19
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_785d 
                                            db 0x47
                                            db 0xFF
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_7860 
                                            db 0x01
                                            db 0xFF
                                            dw BYTE_ram_77d3
                                            dw BYTE_ram_7861 
                                            db 0x36
                                            db 0x1A
                                            dw BYTE_ram_77d6
                                            dw BYTE_ram_7864 
                                            db 0x43
                                            db 0xFF
                                            dw BYTE_ram_77d3
                                            dw BYTE_ram_786b 
                                            db 0x45
                                            db 0x1A
                                            dw BYTE_ram_77db
                                            dw BYTE_ram_786e 
                                            db 0x23
                                            db 0xFF
                                            dw BYTE_ram_77e0 
                                            dw BYTE_ram_7871 
                                            db 0x37
                                            db 0x48
                                            dw BYTE_ram_77e3
                                            dw BYTE_ram_7874 
                                            db 0x37
                                            db 0x49
                                            dw BYTE_ram_77e3
                                            dw BYTE_ram_7877 
                                            db 0x37
                                            db 0x38
                                            dw BYTE_ram_77e8
                                            dw BYTE_ram_787c 
                                            db 0x37
                                            db 0x39
                                            dw BYTE_ram_77e8
                                            dw BYTE_ram_787c 
                                            db 0x37
                                            db 0x3C
                                            dw BYTE_ram_77ed
                                            dw BYTE_ram_787f 
                                            db 0x37
                                            db 0x3A
                                            dw BYTE_ram_77f5
                                            dw BYTE_ram_7887 
                                            db 0x37
                                            db 0x3A
                                            dw BYTE_ram_77ed
                                            dw BYTE_ram_7882 
                                            db 0x28
                                            db 0xFF
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_788e 
                                            db 0x3D
                                            db 0xFF
                                            dw BYTE_ram_72b7 
                                            dw BYTE_ram_7891 
                                            db 0x00
BYTE_ram_775c:                              db 0x00
                                            db 0x13
                                            db 0x01
                                            db 0x15
                                            db 0xFF
BYTE_ram_7761:                              db 0x00
                                            db 0x13
                                            db 0xFF
BYTE_ram_7764:                              db 0x00
                                            db 0x13
                                            db 0x01
                                            db 0x06
                                            db 0xFF
BYTE_ram_7769:                              db 0x00
                                            db 0x13
                                            db 0x01
                                            db 0x13
                                            db 0xFF
BYTE_ram_776e:                              db 0x00
                                            db 0x04
                                            db 0x03
                                            db 0x06
                                            db 0xFF
BYTE_ram_7773:                              db 0x00
                                            db 0x04
                                            db 0x03
                                            db 0x06
                                            db 0x04
                                            db 0x00
                                            db 0x01
                                            db 0x00
                                            db 0xFF
BYTE_ram_777c:                              db 0x00
                                            db 0x04
                                            db 0x03
                                            db 0x06
                                            db 0x01
                                            db 0x00
                                            db 0xFF
BYTE_ram_7783:                              db 0x00
                                            db 0x0D
                                            db 0xFF
BYTE_ram_7786:                              db 0x00
                                            db 0x12
                                            db 0x07
                                            db 0x09
                                            db 0x07
                                            db 0x0A
                                            db 0xFF
BYTE_ram_778d:                              db 0x00
                                            db 0x12
                                            db 0x07
                                            db 0x0A
                                            db 0xFF
BYTE_ram_7792:                              db 0x00
                                            db 0x12
                                            db 0x06
                                            db 0x09
                                            db 0x01
                                            db 0x07
                                            db 0x0A
                                            db 0xFF
BYTE_ram_779a:                              db 0x00
                                            db 0x12
                                            db 0x06
                                            db 0x09
                                            db 0x02
                                            db 0x07
                                            db 0x0A
                                            db 0xFF
BYTE_ram_77a2:                              db 0x00
                                            db 0x12
                                            db 0x05
                                            db 0x0A
                                            db 0xFF
BYTE_ram_77a7:                              db 0x00
                                            db 0x12
                                            db 0x01
                                            db 0x05
                                            db 0x05
                                            db 0x0A
                                            db 0xFF
BYTE_ram_77ae:                              db 0x00
                                            db 0x0B
                                            db 0xFF
BYTE_ram_77b1:                              db 0x00
                                            db 0x11
                                            db 0xFF
BYTE_ram_77b4:                              db 0x00
                                            db 0x0F
                                            db 0xFF
BYTE_ram_77b7:                              db 0x00
                                            db 0x0E
                                            db 0xFF
BYTE_ram_77ba:                              db 0x00
                                            db 0x07
                                            db 0xFF
BYTE_ram_77bd:                              db 0x00
                                            db 0x08
                                            db 0xFF
BYTE_ram_77c0:                              db 0x00
                                            db 0x09
                                            db 0xFF
BYTE_ram_77c3:                              db 0x00
                                            db 0x0A
                                            db 0xFF
BYTE_ram_77c6:                              db 0x00
                                            db 0x14
                                            db 0x05
                                            db 0x0C
                                            db 0xFF
BYTE_ram_77cb:                              db 0x05
                                            db 0x0B
                                            db 0x00
                                            db 0x0C
                                            db 0xFF
BYTE_ram_77d0:                              db 0x00
                                            db 0x0D
                                            db 0xFF
BYTE_ram_77d3:                              db 0x00
                                            db 0x01
                                            db 0xFF
BYTE_ram_77d6:                              db 0x00
                                            db 0x01
                                            db 0x08
                                            db 0x0A
                                            db 0xFF
BYTE_ram_77db:                              db 0x00
                                            db 0x0C
                                            db 0x05
                                            db 0x0B
                                            db 0xFF
BYTE_ram_77e0:                              db 0x01
                                            db 0x16
                                            db 0xFF
BYTE_ram_77e3:                              db 0x00
                                            db 0x14
                                            db 0x01
                                            db 0x01
                                            db 0xFF
BYTE_ram_77e8:                              db 0x00
                                            db 0x14
                                            db 0x05
                                            db 0x0C
                                            db 0xFF
BYTE_ram_77ed:                              db 0x00
                                            db 0x14
                                            db 0x05
                                            db 0x0C
                                            db 0x06
                                            db 0x09
                                            db 0x03
                                            db 0xFF
BYTE_ram_77f5:                              db 0x00
                                            db 0x14
                                            db 0x05
                                            db 0x0C
                                            db 0x04
                                            db 0x00
                                            db 0x06
                                            db 0x09
                                            db 0x03
                                            db 0xFF
BYTE_ram_77ff:                              db 0x08
                                            db 0x0C
                                            db 0x0B
                                            db 0x14
                                            db 0x06
BYTE_ram_7804:                              db 0x05
                                            db 0x0D
                                            db 0x07
BYTE_ram_7807:                              db 0x0B
                                            db 0x12
                                            db 0x11
                                            db 0x06
                                            db 0x06
BYTE_ram_780c:                              db 0x08
                                            db 0x0C
                                            db 0x0B
                                            db 0x12
                                            db 0x06
BYTE_ram_7811:                              db 0x05
                                            db 0x0E
                                            db 0x07
BYTE_ram_7814:                              db 0x05
                                            db 0x01
                                            db 0x07
BYTE_ram_7817:                              db 0x05
                                            db 0x0F
                                            db 0x07
BYTE_ram_781a:                              db 0x10
                                            db 0x06
                                            db 0x02
                                            db 0x06
                                            db 0x0D
BYTE_ram_781f:                              db 0x05
                                            db 0x0F
                                            db 0x07
BYTE_ram_7822:                              db 0x08
                                            db 0x0E
                                            db 0x06
BYTE_ram_7825:                              db 0x0F
                                            db 0x09
                                            db 0x01
                                            db 0x0D
BYTE_ram_7829:                              db 0x05
                                            db 0x10
                                            db 0x0A
                                            db 0x09
                                            db 0x09
                                            db 0x0A
                                            db 0x07
BYTE_ram_7830:                              db 0x0F
                                            db 0x09
                                            db 0x02
                                            db 0x0D
BYTE_ram_7834:                              db 0x05
                                            db 0x11
                                            db 0x0F
                                            db 0x09
                                            db 0x03
                                            db 0x07
BYTE_ram_783a:                              db 0x05
                                            db 0x0D
                                            db 0x07
BYTE_ram_783d:                              db 0x0A
                                            db 0x0A
                                            db 0x11
                                            db 0x05
                                            db 0x0D
BYTE_ram_7842:                              db 0x05
                                            db 0x18
                                            db 0x07
BYTE_ram_7845:                              db 0x05
                                            db 0x13
                                            db 0x07
BYTE_ram_7848:                              db 0x05
                                            db 0x14
                                            db 0x07
BYTE_ram_784b:                              db 0x05
                                            db 0x15
                                            db 0x07
BYTE_ram_784e:                              db 0x05
                                            db 0x16
                                            db 0x07
BYTE_ram_7851:                              db 0x05
                                            db 0x1A
                                            db 0x07
BYTE_ram_7854:                              db 0x08
                                            db 0x0C
                                            db 0x0F
                                            db 0x02
                                            db 0x07
                                            db 0x06
BYTE_ram_785a:                              db 0x04
                                            db 0x09
                                            db 0x0D
BYTE_ram_785d:                              db 0x01
                                            db 0x09
                                            db 0x0D
BYTE_ram_7860:                              db 0x06
BYTE_ram_7861:                              db 0x05
                                            db 0x03
                                            db 0x07
BYTE_ram_7864:                              db 0x09
                                            db 0x0B
                                            db 0x03
                                            db 0x0A
                                            db 0x08
                                            db 0x0C
                                            db 0x06
BYTE_ram_786b:                              db 0x05
                                            db 0x1B
                                            db 0x07
BYTE_ram_786e:                              db 0x08
                                            db 0x01
                                            db 0x06
BYTE_ram_7871:                              db 0x08
                                            db 0x14
                                            db 0x06
BYTE_ram_7874:                              db 0x05
                                            db 0x1C
                                            db 0x0C
BYTE_ram_7877:                              db 0x09
                                            db 0x0C
                                            db 0x05
                                            db 0x1D
                                            db 0x07
BYTE_ram_787c:                              db 0x05
                                            db 0x19
                                            db 0x0C
BYTE_ram_787f:                              db 0x05
                                            db 0x1E
                                            db 0x0E
BYTE_ram_7882:                              db 0x05
                                            db 0x1F
                                            db 0x05
                                            db 0x20
                                            db 0x0C
BYTE_ram_7887:                              db 0x05
                                            db 0x1F
                                            db 0x05
                                            db 0x21
                                            db 0x05
                                            db 0x1E
                                            db 0x0E
BYTE_ram_788e:                              db 0x05
                                            db 0x17
                                            db 0x07
BYTE_ram_7891:                              db 0x05
                                            db 0x12
                                            db 0x07
SOME_POINTER:                               dw BYTE_ram_78be 
                                            dw BYTE_ram_78c5 
                                            dw BYTE_ram_78c8 
                                            dw BYTE_ram_78cd 
                                            dw BYTE_ram_78d2 
                                            dw BYTE_ram_78d7 
                                            dw BYTE_ram_78da 
                                            dw BYTE_ram_78db 
                                            dw BYTE_ram_78e6 
                                            dw BYTE_ram_78f1 
                                            dw BYTE_ram_78fc 
                                            dw BYTE_ram_7907 
                                            dw BYTE_ram_790a 
                                            dw BYTE_ram_7911 
                                            dw BYTE_ram_7912 
                                            dw BYTE_ram_7915 
                                            dw BYTE_ram_791a 
                                            dw BYTE_ram_7921 
                                            dw BYTE_ram_7924 
                                            dw BYTE_ram_7927 
                                            dw BYTE_ram_7927 
BYTE_ram_78be:                              db 0x01
                                            db 0x03
                                            db 0x04
                                            db 0x02
                                            db 0x05
                                            db 0x01
                                            db 0xFF
BYTE_ram_78c5:                              db 0x04
                                            db 0x00
                                            db 0xFF
BYTE_ram_78c8:                              db 0x02
                                            db 0x07
                                            db 0x05
                                            db 0x00
                                            db 0xFF
BYTE_ram_78cd:                              db 0x03
                                            db 0x04
                                            db 0x05
                                            db 0x00
                                            db 0xFF
BYTE_ram_78d2:                              db 0x02
                                            db 0x03
                                            db 0x04
                                            db 0x05
                                            db 0xFF
BYTE_ram_78d7:                              db 0x02
                                            db 0x04
                                            db 0xFF
BYTE_ram_78da:                              db 0xFF
BYTE_ram_78db:                              db 0x01
                                            db 0x07
                                            db 0x02
                                            db 0x08
                                            db 0x03
                                            db 0x07
                                            db 0x04
                                            db 0x07
                                            db 0x05
                                            db 0x07
                                            db 0xFF
BYTE_ram_78e6:                              db 0x01
                                            db 0x07
                                            db 0x02
                                            db 0x07
                                            db 0x03
                                            db 0x09
                                            db 0x04
                                            db 0x07
                                            db 0x05
                                            db 0x07
                                            db 0xFF
BYTE_ram_78f1:                              db 0x01
                                            db 0x07
                                            db 0x02
                                            db 0x07
                                            db 0x03
                                            db 0x07
                                            db 0x04
                                            db 0x0A
                                            db 0x05
                                            db 0x07
                                            db 0xFF
BYTE_ram_78fc:                              db 0x01
                                            db 0x07
                                            db 0x02
                                            db 0x02
                                            db 0x03
                                            db 0x07
                                            db 0x04
                                            db 0x07
                                            db 0x05
                                            db 0x0B
                                            db 0xFF
BYTE_ram_7907:                              db 0x04
                                            db 0x07
                                            db 0xFF
BYTE_ram_790a:                              db 0x03
                                            db 0x0F
                                            db 0x04
                                            db 0x0D
                                            db 0x05
                                            db 0x13
                                            db 0xFF
BYTE_ram_7911:                              db 0xFF
BYTE_ram_7912:                              db 0x05
                                            db 0x0D
                                            db 0xFF
BYTE_ram_7915:                              db 0x04
                                            db 0x13
                                            db 0x05
                                            db 0x13
                                            db 0xFF
BYTE_ram_791a:                              db 0x02
                                            db 0x0F
                                            db 0x03
                                            db 0x13
                                            db 0x04
                                            db 0x11
                                            db 0xFF
BYTE_ram_7921:                              db 0x05
                                            db 0x10
                                            db 0xFF
BYTE_ram_7924:                              db 0x04
                                            db 0x10
                                            db 0xFF
BYTE_ram_7927:                              db 0xFF
ACTION_POINTER:                             dw IT_SHOWS_A_MAN_CLIMBING 
                                            dw HOW_I_CANT_REACH 
                                            dw IT_HAS_FALLEN_TO_THE_FLOOR 
                                            dw HOW 
                                            dw ITS_TOO_WIDE.I_FELL_AND_BROKE 
                                            dw UGH!_HE_IS_ALL_SLIMY 
                                            dw HE_VANISHED_IN_A_PUFF_OF_SMOKE 
                                            dw YOU_ALSO_BROKE_THE_MIRROR 
                                            dw COMPUTER_SAYS 
                                            dw IT_HAS_WEAKENED_IT 
                                            dw IT_HAD_NO_EFFECT 
                                            dw I_FELL_AND_KNOCKED_MYSELF_OUT 
                                            dw THE_BARS_LOOK_LOOSE 
                                            dw WHAT_WITH 
                                            dw I_SEE_A_GOLD_COIN 
                                            dw BRRR.THE_WATERS_TOO_COLD 
                                            dw THE_FUSE_HAS_JUST_BLOWN 
                                            dw THE_LIFT_HAS_BEEN_ACTIVATED 
                                            dw I_SEE_NOTHING_SPECIAL 
                                            dw KEEP_OFF_THE_MIDDLE_MEN 
                                            dw VANITY_WALTZ 
                                            dw TRY_HELP 
                                            dw POINTS_OF_COMPASS 
                                            dw TRY_LOOKING_AROUND 
                                            dw I_CAN_SEE_A_STEEP_SLOPE 
                                            dw AN_ALARM_SOUNDS 
                                            dw I_CAN_SEE_A_ROPE_HANGING_DOWN 
                                            dw I_AM_NOT_THAT_DAFT 
                                            dw THE_SPACE_SHIP_BLEW_UP 
                                            dw THE_SHIP_HAS_FLOWN 
                                            dw THE_LIFT_HAS_TAKEN_ME_UP 
                                            dw THE_LIFT_HAS_BECOME_ELECTRIFIED 
                                            dw I_HAVE_BEEN_ELECTROCUTED 
                                            dw IT_IS_A_GOOD_JOB_I_WAS_WEARING 
                                            dw I_WOULD_KILL_MYSELF_IF_I_DID 
                                            dw I_HAVE_TURNED_GREEN_AND_DROPPED 
                                            dw s_THE_GREEN_MAN_AWOKE_AND_THROTTLE_ram_7e50 
                                            dw s_THE_GUARD_WOKE_AND_SHOT_ME._ram_7e77 
                                            dw s_WHAT_AT?_ram_7e94 
                                            dw 0x0000
IT_SHOWS_A_MAN_CLIMBING:                    db "IT SHOWS A MAN CLIMBING DOWN A PIT USING A ROPE\r",0
HOW_I_CANT_REACH:                           db "HOW? I CANT REACH\r",0
IT_HAS_FALLEN_TO_THE_FLOOR:                 db "IT HAS FALLEN TO THE FLOOR\r",0
HOW:                                        db "HOW?\r",0
ITS_TOO_WIDE.I_FELL_AND_BROKE:              db "ITS TOO WIDE.I FELL AND BROKE MY NECK\r",0
UGH!_HE_IS_ALL_SLIMY:                       db "UGH! HE IS ALL SLIMY\r",0
HE_VANISHED_IN_A_PUFF_OF_SMOKE:             db "HE VANISHED IN A PUFF OF SMOKE\r",0
YOU_ALSO_BROKE_THE_MIRROR:                  db "YOU ALSO BROKE THE MIRROR\r",0
COMPUTER_SAYS:                              db "COMPUTER SAYS: 2 WEST,2 SOUTH FOR SPACE FLIGHT\r",0
IT_HAS_WEAKENED_IT:                         db "IT HAS WEAKENED IT\r",0
IT_HAD_NO_EFFECT:                           db "IT HAD NO EFFECT\r",0
I_FELL_AND_KNOCKED_MYSELF_OUT:              db "I FELL AND KNOCKED MYSELF OUT.\r",0
THE_BARS_LOOK_LOOSE:                        db "THE BARS LOOK LOOSE\r",0
WHAT_WITH:                                  db "WHAT WITH?\r",0
I_SEE_A_GOLD_COIN:                          db "I SEE A GOLD COIN\r",0
BRRR.THE_WATERS_TOO_COLD:                   db "BRRR.THE WATERS TOO COLD\r",0
THE_FUSE_HAS_JUST_BLOWN:                    db "THE FUSE HAS JUST BLOWN\r",0
THE_LIFT_HAS_BEEN_ACTIVATED:                db "THE LIFT HAS BEEN ACTIVATED\r",0
I_SEE_NOTHING_SPECIAL:                      db "I SEE NOTHING SPECIAL\r",0
KEEP_OFF_THE_MIDDLE_MEN:                    db "KEEP OFF THE MIDDLE MEN,ONE MAY BE SHOCKING!\r",0
VANITY_WALTZ:                               db "VANITY WALTZ!\r",0
TRY_HELP:                                   db "TRY HELP\r",0
POINTS_OF_COMPASS:                          db "POINTS OF COMPASS\r",0
TRY_LOOKING_AROUND:                         db "TRY LOOKING AROUND\r",0
I_CAN_SEE_A_STEEP_SLOPE:                    db "I CAN SEE A STEEP SLOPE\r",0
AN_ALARM_SOUNDS:                            db "AN ALARM SOUNDS.THE SECURITY GUARD SHOT ME FOR TRESPASSING.\r",0
I_CAN_SEE_A_ROPE_HANGING_DOWN:              db "I CAN SEE A ROPE HANGING DOWN THE CHIMNEY.\r",0
I_AM_NOT_THAT_DAFT:                         db "I AM NOT THAT DAFT.IT IS TOO DEEP.\r",0
THE_SPACE_SHIP_BLEW_UP:                     db "THE SPACE SHIP BLEW UP AND KILLED ME.\r",0
THE_SHIP_HAS_FLOWN:                         db "THE SHIP HAS FLOWN INTO THE LARGE LIFT AND IS HOVERING THERE.\rTHERE ARE FOUR BU"
                                            db "TTONS OUTSIDE THE WINDOW MARKED 1,2,3 AND 4\r",0
THE_LIFT_HAS_TAKEN_ME_UP:                   db "THE LIFT HAS TAKEN ME UP TO A PLATEAU.\rCONGRATULATIONS, YOU HAVE MANAGED TO COM"
                                            db "PLETE THIS ADVENTURE\rWITHOUT GETTING KILLED.\r",0
THE_LIFT_HAS_BECOME_ELECTRIFIED:            db "THE LIFT HAS BECOME ELECTRIFIED\r",0
I_HAVE_BEEN_ELECTROCUTED:                   db "I HAVE BEEN ELECTROCUTED\r",0
IT_IS_A_GOOD_JOB_I_WAS_WEARING:             db "IT IS A GOOD JOB I WAS WEARING RUBBER SOLED BOOTS.\r",0
I_WOULD_KILL_MYSELF_IF_I_DID:               db "I WOULD KILL MYSELF IF I DID.\r",0
I_HAVE_TURNED_GREEN_AND_DROPPED:            db "I HAVE TURNED GREEN AND DROPPED DEAD.\r",0
s_THE_GREEN_MAN_AWOKE_AND_THROTTLE_ram_7e50:db "THE GREEN MAN AWOKE AND THROTTLED ME.\r",0
s_THE_GUARD_WOKE_AND_SHOT_ME._ram_7e77:     db "THE GUARD WOKE AND SHOT ME.\r",0
s_WHAT_AT?_ram_7e94:                        db "WHAT AT?\r",0
NAV0:                              db 0x06
                                            db 0x05
                                            db 0x01
                                            db 0x05
                                            db 0x06
                                            db 0xFF
NAV1:                              db 0x06
                                            db 0x02
                                            db 0x01
                                            db 0x01
                                            db 0x10
                                            db 0xFF
NAV2:                              db 0x06
                                            db 0x02
                                            db 0x01
                                            db 0x01
                                            db 0x11
                                            db 0xFF
NAV3:                              db 0x06
                                            db 0x02
                                            db 0x01
                                            db 0x01
                                            db 0x17
                                            db 0xFF
NAV4:                              db 0x06
                                            db 0x02
                                            db 0x01
                                            db 0x01
                                            db 0x0E
                                            db 0xFF
NAV5:                              db 0xFF
NAV6:                              db 0x05
                                            db 0x23
                                            db 0x0C
NAV7:                              db 0x05
                                            db 0x24
                                            db 0x0C
NAV8:                              db 0x05
                                            db 0x25
                                            db 0x0C
NAV9:                              db 0x0B
                                            db 0x0E
NAV10:                              db 0x15
TABLE_SIX:                                  db 0xFF
                                            db 0xFF
                                            dw NAV0 
                                            dw NAV6 
                                            db 0xFF
                                            db 0xFF
                                            dw NAV1 
                                            dw NAV7 
                                            db 0xFF
                                            db 0xFF
                                            dw NAV2 
                                            dw NAV7 
                                            db 0xFF
                                            db 0xFF
                                            dw NAV3 
                                            dw NAV8 
                                            db 0xFF
                                            db 0xFF
                                            dw NAV4 
                                            dw NAV9 
                                            db 0xFF
                                            db 0xFF
                                            dw NAV5 
                                            dw NAV10 
                                            db 0x00
                                            db 0x52
                                            db 0x4F
                                            db 0x4C
                                            db 0x20
                                            db 0x52
                                            db 0x4F
END_OF_DATA:                                db 0x00
                                            endmodule

DEBUG_TEXT:                                 LD A, CLR_BLACK<<3 | CLR_GREEN 
                                            CALL SCREEN.CLEAR
                             
                                            LD HL,SCREEN.POS_Y
                                            LD (HL),23
                                            INC HL
                                             LD (HL),23

KEY_LOOP:                                   LD HL,KEYBOARD.LASTK ;getting key in A - capitalized 
                                            LD A,(HL)
                                            LD (HL),0x0
                                            CP 0
                                            JR Z,KEY_LOOP
                                            CALL SCREEN.PRINT_CHAR

                                            JP KEY_LOOP


BASIC_RUNNER                                LD HL,0x5C3b
                                            LD (HL),0xCC
                                            ; im2
                                            DI  
                                            LD A,0xBA
                                            LD I,A
                                            IM 2
                                            EI
                                            JP GAME.ENTRY_POINT
                                            ;JP DEBUG_TEXT

                                            ORG  0xBA00
                                            DEFS 257,0xBB

                                            ORG 0xBBBB
                                            DI
                                            PUSH AF                
                                            PUSH BC                                               
                                            PUSH DE                                               
                                            PUSH IX                                               
                                            PUSH IY                                              
                                            PUSH HL  

                                            call KEYBOARD.KEYBOARD

                                            ;XOR A
                                            ;LD (23560),A
                                            ;LD IY,#5C3A
                                            ;RST 56
                                            LD a,(23560) 
                                            LD (16385),A
                                            LD a,(KEYBOARD.LASTK) 
                                            LD (1638),A

                                            LD a,(16384)
                                            xor 255
                                            ld (16384),a

                                            POP HL 
                                            POP IY
                                            POP IX     
                                            POP DE
                                            POP BC                                                                                                                                        
                                            POP AF                                                                                                                                                                                                   
                                            EI
                                            RET

                                            include keyboard.asm
                                            include screen.asm
                                            include output.asm

                                            SAVESNA "adventurea.sna",BASIC_RUNNER
                                            SAVEBIN "adventurea.bin",23500, 9000