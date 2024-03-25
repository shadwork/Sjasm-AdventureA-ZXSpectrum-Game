                                            define COMMAND_DOWN 0x01
                                            define COMMAND_NORT 0x02
                                            define COMMAND_SOUT 0x03
                                            define COMMAND_EAST 0x04
                                            define COMMAND_WEST 0x05
                                            define COMMAND_GET 0x0D
                                            define COMMAND_PUT 0x0E
                                            define COMMAND_FIRE 0x0F
			                                define COMMAND_BOOT 0x10 
			                                define COMMAND_STAR 0x11 
			                                define COMMAND_KEY 0x12 
			                                define COMMAND_GUN 0x13 
                                            define COMMAND_USED 0x14 
                                            define COMMAND_BAR 0x15    
                                            define COMMAND_COIN 0x16 
                                            define COMMAND_MIRR 0x17
                                            define COMMAND_BROK 0x18
                                            define COMMAND_GLOV 0x19
                                            define COMMAND_ROPE 0x1A
                                            define COMMAND_FLOO 0x1B 
                                            define COMMAND_STAL 0x1C
                                            define COMMAND_ICE 0x1D  
                                            define COMMAND_WATE 0x1E     
                                            define COMMAND_MAN 0x1F                                                                                                                                                                                                                       
                                            define COMMAND_DOOR 0x20 
                                            define COMMAND_OPEN 0x21 
                                            define COMMAND_WIND 0x22 
                                            define COMMAND_SHIP 0x23 
                                            define COMMAND_SECU 0x24
                                            define COMMAND_FLIN 0x25
                                            define COMMAND_STON 0x26
                                            define COMMAND_DRAW 0x27    
                                            define COMMAND_HELP 0x28                                             
                                            define COMMAND_INVE 0x29 
                                            define COMMAND_STOP 0x2A
                                            define COMMAND_YES 0x2B                                            
                                            define COMMAND_NO 0x2C 
                                            define COMMAND_KEYB 0x2D 
                                            define COMMAND_TYPE 0x2E 
                                            define COMMAND_TURN 0x2F  
                                            define COMMAND_HAND 0x30                                                                                        
                                            define COMMAND_KILL 0x31  
                                            define COMMAND_DANC 0x32 
                                            define COMMAND_REMO 0x33     
                                            define COMMAND_HIT 0x34                                             
                                            define COMMAND_BRIB 0x35
                                            define COMMAND_USE 0x36
                                            define COMMAND_PUSH 0x37
                                            define COMMAND_3 0x38
                                            define COMMAND_2 0x39
                                            define COMMAND_1 0x3A
                                            define COMMAND_FIX 0x3B
                                            define COMMAND_4 0x3C
                                            define COMMAND_LOOK 0x3D
                                            define COMMAND_STAN 0x3E
                                            define COMMAND_TREE 0x3F
                                            define COMMAND_CUT 0x40
                                            define COMMAND_WEAR 0x41
                                            define COMMAND_CROS 0x42
                                            define COMMAND_JUMP 0x43
                                            define COMMAND_RAVI 0x44
                                            define COMMAND_UP 0x45
                                            define COMMAND_FUSE 0x46
                                            define COMMAND_REDE 0x47
                                            define COMMAND_MAIN 0x48
                                            define COMMAND_AUX 0x49
                                            define COMMAND_FIEL 0x4A
                                            define COMMAND_ANY 0xFF                           	

											db "DOWN"
                                            db COMMAND_DOWN
                                            db "D   "
                                            db COMMAND_DOWN
                                            db "NORT"
                                            db COMMAND_NORT
                                            db "N   "
                                            db COMMAND_NORT
                                            db "SOUT"
                                            db COMMAND_SOUT
                                            db "S   "
                                            db COMMAND_SOUT
                                            db "EAST"
                                            db COMMAND_EAST
                                            db "E   "
                                            db COMMAND_EAST
                                            db "WEST"
                                            db COMMAND_WEST
                                            db "W   "
                                            db COMMAND_WEST
                                            db "GET "
                                            db COMMAND_GET
                                            db "PICK"
                                            db COMMAND_GET
                                            db "DROP"
                                            db COMMAND_PUT
                                            db "PUT "
                                            db COMMAND_PUT
                                            db "FIRE"
                                            db COMMAND_FIRE
                                            db "SHOO"
                                            db COMMAND_FIRE
                                            db "BOOT"
                                            db COMMAND_BOOT
                                            db "STAR"
                                            db COMMAND_STAR
                                            db "MOTO"
                                            db COMMAND_STAR
                                            db "KEY "
                                            db COMMAND_KEY
                                            db "LASE"
                                            db COMMAND_GUN
                                            db "GUN "
                                            db COMMAND_GUN
                                            db "USED"
                                            db COMMAND_USED
                                            db "BAR "
                                            db COMMAND_BAR
                                            db "BARS"
                                            db COMMAND_BAR
                                            db "GOLD"
                                            db COMMAND_COIN
                                            db "COIN"
                                            db COMMAND_COIN
                                            db "MIRR"
                                            db COMMAND_MIRR
                                            db "BROK"
                                            db COMMAND_BROK
                                            db "GLOV"
                                            db COMMAND_GLOV
                                            db "ROPE"
                                            db COMMAND_ROPE
                                            db "FLOO"
                                            db COMMAND_FLOO
                                            db "BOAR"
                                            db COMMAND_FLOO
                                            db "PLAN"
                                            db COMMAND_FLOO
                                            db "STAL"
                                            db COMMAND_STAL
                                            db "BLOC"
                                            db COMMAND_ICE
                                            db "ICE "
                                            db COMMAND_ICE
                                            db "POOL"
                                            db COMMAND_WATE
                                            db "WATE"
                                            db COMMAND_WATE
                                            db "LAKE"
                                            db COMMAND_WATE
                                            db "SLEE"
                                            db COMMAND_MAN
                                            db "GREE"
                                            db COMMAND_MAN
                                            db "MAN "
                                            db COMMAND_MAN
                                            db "DOOR"
                                            db COMMAND_DOOR
                                            db "OPEN"
                                            db COMMAND_OPEN
                                            db "UNLO"
                                            db COMMAND_OPEN
                                            db "WIND"
                                            db COMMAND_WIND
                                            db "SMAL"
                                            db COMMAND_SHIP
                                            db "SPAC"
                                            db COMMAND_SHIP
                                            db "SHIP"
                                            db COMMAND_SHIP
                                            db "SECU"
                                            db COMMAND_SECU
                                            db "FLIN"
                                            db COMMAND_FLIN
                                            db "STON"
                                            db COMMAND_STON
                                            db "DRAW"
                                            db COMMAND_DRAW
                                            db "HELP"
                                            db COMMAND_HELP
                                            db "INVE"
                                            db COMMAND_INVE
                                            db "I   "
                                            db COMMAND_INVE
                                            db "QUIT"
                                            db COMMAND_STOP
                                            db "STOP"
                                            db COMMAND_STOP
                                            db "ABOR"
                                            db COMMAND_STOP
                                            db "YES "
                                            db COMMAND_YES
                                            db "Y   "
                                            db COMMAND_YES
                                            db "NO  "
                                            db COMMAND_NO
                                            db "COMP"
                                            db COMMAND_KEYB
                                            db "KEYB"
                                            db COMMAND_KEYB
                                            db "TYPE"
                                            db COMMAND_TYPE
                                            db "TURN"
                                            db COMMAND_TURN
                                            db "HAND"
                                            db COMMAND_HAND
                                            db "KILL"
                                            db COMMAND_KILL
                                            db "DANC"
                                            db COMMAND_DANC
                                            db "WALT"
                                            db COMMAND_DANC
                                            db "REMO"
                                            db COMMAND_REMO
                                            db "KICK"
                                            db COMMAND_HIT
                                            db "BREA"
                                            db COMMAND_HIT
                                            db "HIT "
                                            db COMMAND_HIT
                                            db "BANG"
                                            db COMMAND_HIT
                                            db "BRIB"
                                            db COMMAND_BRIB
                                            db "USE "
                                            db COMMAND_USE
                                            db "WITH"
                                            db COMMAND_USE
                                            db "PUSH"
                                            db COMMAND_PUSH
                                            db "THRE"
                                            db COMMAND_3
                                            db "3   "
                                            db COMMAND_3
                                            db "TWO "
                                            db COMMAND_2
                                            db "2   "
                                            db COMMAND_2
                                            db "ONE "
                                            db COMMAND_1
                                            db "1   "
                                            db COMMAND_1
                                            db "MEND"
                                            db COMMAND_FIX
                                            db "FIX "
                                            db COMMAND_FIX
                                            db "REPA"
                                            db COMMAND_FIX
                                            db "FOUR"
                                            db COMMAND_4
                                            db "4   "
                                            db COMMAND_4
                                            db "LOOK"
                                            db COMMAND_LOOK
                                            db "STAN"
                                            db COMMAND_STAN
                                            db "TREE"
                                            db COMMAND_TREE
                                            db "CUT "
                                            db COMMAND_CUT
                                            db "SAW "
                                            db COMMAND_CUT
                                            db "WEAR"
                                            db COMMAND_WEAR
                                            db "CROS"
                                            db COMMAND_CROS
                                            db "JUMP"
                                            db COMMAND_JUMP
                                            db "RAVI"
                                            db COMMAND_RAVI
                                            db "UP  "
                                            db COMMAND_UP
                                            db "U   "
                                            db COMMAND_UP
                                            db "CLIM"
                                            db COMMAND_UP
                                            db "FUSE"
                                            db COMMAND_FUSE
                                            db "REDE"
                                            db COMMAND_REDE
                                            db "R   "
                                            db COMMAND_REDE
                                            db "MAIN"
                                            db COMMAND_MAIN
                                            db "AUX "
                                            db COMMAND_AUX
                                            db "FIEL"
                                            db COMMAND_FIEL
                                            db "SHIE"
                                            db COMMAND_FIEL
                                            db 0xFF