module input_control
#(parameter WORD_LENGHT = 8)
(
	input clk,
	input rst,
	input [WORD_LENGHT-1:0]data,
	input [1:0]opCode,
	input start,
	input load,
	
	output [WORD_LENGHT-1:0]operand_1,
	output sign_1_out,
	output [WORD_LENGHT-1:0]operand_2,
	output sign_2_out,
	output [1:0]opCode_R_out,
	output load_x_out,
	output load_y_out,
	output start_out,
	output error
	);
	//------------------------------One shot wires-------------------------------------
	bit one_shot_start_wire;
	bit one_shot_load_wire;
	//--------------------------Control signals struct---------------------------------
	 struct packed{
		bit load_1;
		bit load_2;
		bit start;
	}control;
	//--------------------------------a2 wires----------------------------------------
	bit data_sign_in_wire;
	bit [WORD_LENGHT-1:0]data_binary_wire;
	//-------------------------Control counter wires-----------------------------------
	bit state_counter_enable_wire;
	bit state_counter_load_value_wire;
	bit [1:0]state;
	
//---------------------------------One shot instances---------------------------------
	ONEshot					ONE_SHOT_START
	(
		 .in(start),
		 .clk(clk),
		 .reset(rst),
		 .out(one_shot_start_wire)
	);
	
	ONEshot					ONE_SHOT_LOAD
	(
		 .in(load),
		 .clk(clk),
		 .reset(rst),
		 .out(one_shot_load_wire)
	);

//-------------------------------A2 convertion-------------------------------------
 Complemento_a2
 #(.word_lenght(WORD_LENGHT))		A2_DATA
(	
	// Input Ports
	.word_in(data),

	// Output Ports
	.Word_out(data_binary_wire),
	.signo(data_sign_in_wire)
);

//--------------------------------Operand 1 register-------------------------------
	Register
	#(.Word_Length(WORD_LENGHT+1)) 	OPERAND_1_REGISTER
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input({data_binary_wire, data_sign_in_wire}),
		.enable(control.load_1),
		.sync_reset(1'b0),

		// Output Ports
		.Data_Output({operand_1, sign_1_out})
	);

//--------------------------------Operand 2 register-------------------------------
	Register
	#(.Word_Length(WORD_LENGHT+1)) 	OPERAND_2_REGISTER
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input({data_binary_wire, data_sign_in_wire}),
		.enable(control.load_2),
		.sync_reset(1'b0),

		// Output Ports
		.Data_Output({operand_2, sign_2_out})
	);
	
//--------------------------------OpCode register-------------------------------
	Register
	#(.Word_Length(2)) 	OPCODE_REGISTER
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input(opCode),
		.enable(one_shot_start_wire),
		.sync_reset(1'b0),

		// Output Ports
		.Data_Output(opCode_R_out)
	);
	
//-----------------------------Control State machine-----------------------------------------

assign state_counter_enable_wire = (one_shot_start_wire & &(~state)) | (one_shot_load_wire & ^state) | (&state);	//Revisar logica de start
assign state_counter_load_value_wire = opCode_R_out[0] & ~opCode_R_out[1] & ^state;

CounterWithLoad
#(	.Maximum_Value(3),    	.NBitsForCounter(2))      CURRENT_STATE_SELECTOR
(
	// Input Ports
	.clk(clk),
	.reset(rst),
	.enable(state_counter_enable_wire),
	.load_value(state_counter_load_value_wire),
	.value_to_load(2'b11),		//Loads counter value of strt state, to avoid saving the second operand on sqrt

	// Output Ports
	.Flag(),
	.Counting(state)
);

single_port_rom_input
#(.DATA_WIDTH(3), .ADDR_WIDTH(2))       ROM_INPUT_MACHINE
(
	.addr(state),
	.clk(clk),
	.q(control)
);

//	enum int unsigned { IDLE, OPERAND1, SAVE1, OPERAND2, SAVE2, START} state, next_state;
//	always_comb begin : next_state_logic
//		next_state = IDLE;
//		case(state)
//			IDLE: if(start == 1) next_state = OPERAND1; else next_state = IDLE;
//			OPERAND1: if(load == 1) next_state = OPERAND2; else if(opCode_R_out == 2'b01) next_state = START; else next_state = OPERAND1;
//			OPERAND2: if(load == 1) next_state = START; else next_state = OPERAND2;
//			START: next_state = IDLE;
//		endcase
//		end
//		
//	always_comb begin
//		case(state)
//			IDLE:    control = 3'b000;
//			OPERAND1:     control = 3'b100;
//			OPERAND2:     control = 3'b010;
//			START:     control = 3'b001;
//		endcase
//		end
//	
//	always_ff@(posedge clk or negedge rst) begin
//		if(~rst)
//			state <= IDLE;
//		else
//			state <= next_state;
//	end

//--------------------------Output assignments------------------------------
	assign  start_out = control.start;
	assign  error = ~opCode_R_out[1] & opCode_R_out[0] & sign_1_out | (~|operand_2 & ~opCode_R_out[1] & ~opCode_R_out[0]);
	assign  load_x_out = control.load_1;
	assign  load_y_out = control.load_2;
	
endmodule