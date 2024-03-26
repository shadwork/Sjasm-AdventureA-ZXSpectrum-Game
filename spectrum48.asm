                                            DEVICE ZXSPECTRUM48

                                            org 0x5d40
                                            include adventurea.asm
BASIC_RUNNER                                LD HL,0x5C3b
                                            LD (HL),0xCC
                                            ; im2
                                            DI  
                                            LD A,0xBA
                                            LD I,A
                                            IM 2
                                            EI
                                            JP GAME.ENTRY_POINT

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

                                            CALL INPUT.KEYBOARD
                                            CALL OUTPUT.CURSOR_BLINKS

                                            ;XOR A
                                            ;LD (23560),A
                                            ;LD IY,#5C3A
                                            ;RST 56
                                            LD a,(23560) 
                                            LD (16385),A
                                            LD a,(INPUT.LASTK) 
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

                                            include input48.asm
                                            include output48.asm

                                            SAVESNA "adventurea.sna",BASIC_RUNNER