	
	module STORE
					; 04C2: THE 'SA-BYTES' SUBROUTINE
					; A	+00 (header block) or +FF (data block)
					; DE	Block length
					; IX	Start address

SAVE: ; input IX address DE length
                                            LD A,0xff
                                            SCF
                                            CALL 0x04c2
											RET
; 0556: THE 'LD-BYTES' SUBROUTINE
; A	+00 (header block) or +FF (data block)
;F	Carry flag set if loading, reset if verifying
; DE	Block length
; IX	Start address
LOAD: ; input IX address DE length
                                            LD A,0xff
                                            SCF
                                            CALL 0x0556
											RET
	
	endmodule
