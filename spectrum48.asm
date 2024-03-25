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