	define CLR_BLACK %000000
	define CLR_BLUE %000001
	define CLR_RED %000010
	define CLR_MAGENTA %000011
	define CLR_GREEN %000100
	define CLR_CYAN %000101
	define CLR_WHITE %000111

	define CLR_BRIGHT %1000000

  MACRO COLOR ink, paper
    LD A,(ink + paper<<3) 
  ENDM


