
                                            db COMMAND_ANY 
                                            db COMMAND_ANY 
                                            dw VALIDATOR0 
                                            dw ACTION_DIE_GREEN 
                                            db COMMAND_ANY
                                            db COMMAND_ANY
                                            dw VALIDATOR1 
                                            dw ACTION_DIE_THROTT 
                                            db COMMAND_ANY
                                            db COMMAND_ANY
                                            dw VALIDATOR2 
                                            dw ACTION_DIE_THROTT 
                                            db COMMAND_ANY
                                            db COMMAND_ANY
                                            dw VALIDATOR3 
                                            dw ACTION_DIE_SHOT 
                                            db COMMAND_ANY
                                            db COMMAND_ANY
                                            dw VALIDATOR4 
                                            dw ACTION_SWAP_ICE 
                                            db COMMAND_ANY
                                            db COMMAND_ANY
                                            dw VALIDATOR5 
                                            dw ACTION_TELL_ME 
                                            db 0x00

VALIDATOR0:                                 db 0x06 ; PROC6(5,1)
                                            db 0x05 ; IX+5
                                            db 0x01 ; ==1
                                            db 0x05 ; PROC5(6)
                                            db 0x06 ; IX+6!=0
                                            db 0xFF
VALIDATOR1:                                 db 0x06 ; PROC6(2,1)
                                            db 0x02 ; IX+2
                                            db 0x01 ; ==1
                                            db 0x01 ; PROC1(0x10) is item available
                                            db 0x10 ; OBJECT_A_SMALL_GREEN_MAN_SLEEPING
                                            db 0xFF
VALIDATOR2:                                 db 0x06 ; PROC6(2,1)
                                            db 0x02 ; IX+2
                                            db 0x01 ; ==1
                                            db 0x01 ; PROC1(0x11) is item available
                                            db 0x11 ; OBJECT_A_SLEEPING_GREEN_MAN
                                            db 0xFF
VALIDATOR3:                                 db 0x06 ; PROC6(2,1)
                                            db 0x02 ; IX+2
                                            db 0x01 ; ==1
                                            db 0x01 ; PROC1(0x17) is item available
                                            db 0x17 ; OBJECT_A_SLEEPING_SECURITY_MAN
                                            db 0xFF
VALIDATOR4:                                 db 0x06 ; PROC6(2,1)
                                            db 0x02 ; IX+2
                                            db 0x01 ; ==1
                                            db 0x01 ; PROC1(0x0e)
                                            db 0x0E ; OBJECT_A_BLOCK_OF_ICE
                                            db 0xFF
VALIDATOR5:                                 db 0xFF ; no validation
ACTION_DIE_GREEN:                           db 0x05 ; CMD_PRINT_ANSWER
                                            db 0x23 ; I_HAVE_TURNED_GREEN_AND_DROPPED
                                            db 0x0C ; CMD_END
ACTION_DIE_THROTT:                          db 0x05 ; CMD_PRINT_ANSWER
                                            db 0x24 ; s_THE_GREEN_MAN_AWOKE_AND_THROTTLE_ram_7e50
                                            db 0x0C ; CMD_END
ACTION_DIE_SHOT:                            db 0x05 ; CMD_PRINT_ANSWER
                                            db 0x25 ; s_THE_GUARD_WOKE_AND_SHOT_ME._ram_7e77
                                            db 0x0C ; CMD_END
ACTION_SWAP_ICE:                            db 0x0B ; CMD_SWAP_ITEM
                                            db 0x0E ; item number OBJECT_A_BLOCK_OF_ICE and OBJECT_A_POOL_OF_WATER
ACTION_TELL_ME:                             db 0x15 ; CMD_TELL_ME