                                            dw ROOM_00_NAV 
                                            dw ROOM_01_NAV 
                                            dw ROOM_02_NAV 
                                            dw ROOM_03_NAV 
                                            dw ROOM_04_NAV 
                                            dw ROOM_05_NAV 
                                            dw ROOM_06_NAV 
                                            dw ROOM_07_NAV 
                                            dw ROOM_08_NAV 
                                            dw ROOM_09_NAV 
                                            dw ROOM_10_NAV 
                                            dw ROOM_11_NAV 
                                            dw ROOM_12_NAV 
                                            dw ROOM_13_NAV 
                                            dw ROOM_14_NAV 
                                            dw ROOM_15_NAV 
                                            dw ROOM_16_NAV 
                                            dw ROOM_17_NAV 
                                            dw ROOM_18_NAV 
                                            dw ROOM_19_NAV 
                                            dw ROOM_19_NAV 
ROOM_00_NAV:                              db 0x01 ; cmd "DOWN"
                                            db 0x03 ; to room 3
                                            db 0x04 ; cmd "EAST"
                                            db 0x02 ; to room 2
                                            db 0x05 ; "WEST"
                                            db 0x01 ; to room 1
                                            db 0xFF
ROOM_01_NAV:                              db 0x04 ; cmd "EAST"
                                            db 0x00 ;  to room 0
                                            db 0xFF
ROOM_02_NAV:                              db 0x02
                                            db 0x07
                                            db 0x05
                                            db 0x00
                                            db 0xFF
ROOM_03_NAV:                              db 0x03
                                            db 0x04
                                            db 0x05
                                            db 0x00
                                            db 0xFF
ROOM_04_NAV:                              db 0x02
                                            db 0x03
                                            db 0x04
                                            db 0x05
                                            db 0xFF
ROOM_05_NAV:                              db 0x02
                                            db 0x04
                                            db 0xFF
ROOM_06_NAV:                              db 0xFF
ROOM_07_NAV:                              db 0x01
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
ROOM_08_NAV:                              db 0x01
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
ROOM_09_NAV:                              db 0x01
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
ROOM_10_NAV:                              db 0x01
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
ROOM_11_NAV:                              db 0x04
                                            db 0x07
                                            db 0xFF
ROOM_12_NAV:                              db 0x03
                                            db 0x0F
                                            db 0x04
                                            db 0x0D
                                            db 0x05
                                            db 0x13
                                            db 0xFF
ROOM_13_NAV:                              db 0xFF
ROOM_14_NAV:                              db 0x05
                                            db 0x0D
                                            db 0xFF
ROOM_15_NAV:                              db 0x04
                                            db 0x13
                                            db 0x05
                                            db 0x13
                                            db 0xFF
ROOM_16_NAV:                              db 0x02
                                            db 0x0F
                                            db 0x03
                                            db 0x13
                                            db 0x04
                                            db 0x11
                                            db 0xFF
ROOM_17_NAV:                              db 0x05
                                            db 0x10
                                            db 0xFF
ROOM_18_NAV:                              db 0x04
                                            db 0x10
                                            db 0xFF
ROOM_19_NAV:                              db 0xFF