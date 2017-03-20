package Definitions;

typedef struct packed{
	bit load;
	bit enable;
	bit sync_rst; //sin uso
	bit ready;
	bit ctrl_stop;
	
} MULTIPLIER_CONTROL_SIGNALS;

typedef struct packed{
	bit load;
	bit shift;
	bit sync_rst;
	bit ready;
	bit ctrl_stop;
	
} DIVIDER_CONTROL_SIGNALS;

typedef struct packed{
	bit enable;
	bit controlEND;
	bit synch;
	bit ready;
	bit ctrl_stop;
	
} SQRT_CONTROL_SIGNALS;

typedef struct packed{
	MULTIPLIER_CONTROL_SIGNALS multiplier;
	DIVIDER_CONTROL_SIGNALS divider;
	SQRT_CONTROL_SIGNALS sqrt;
	
} CONTROL_SIGNALS;



localparam MULTIPLIER_CONTROL_LENGHT = 5;
localparam DIVIDER_CONTROL_LENGHT = 5;

// typedef bit [8:0] AdderWithCarry;
// enum {ZERO, ONE,TWO, THREE} Cases;
endpackage