import Definitions::*;

module SQRT
#(parameter WORD_LENGHT = 16)
(
	//Input Ports.
	input [WORD_LENGHT-1:0]input_D,
	input clk,
	input reset,
	input SQRT_CONTROL_SIGNALS control_signal, //Definitions
	input [WORD_LENGHT-1:0] Add_result,
	//Output ports.
	output [WORD_LENGHT-1:0]out_R,
	output [WORD_LENGHT-1:0]out_Q,
	output [WORD_LENGHT-1:0]add1_value,
	output [WORD_LENGHT-1:0]add2_value,
	output sign

);

//WIRES.
bit [WORD_LENGHT-1:0] BSout2orMUXinput_wire;

bit [WORD_LENGHT-1:0] RoutRegister2Rshift_wire;
bit [WORD_LENGHT-1:0] QoutRegister_wire;

Barrel_shifter 
# ( .WORD_LENGHT(WORD_LENGHT)
)
BS_module
(
	//Input Ports.
	.data_in(input_D),
	.clk(clk),
	.reset(reset),
	.shift_enable(control_signal.enable),
	.synch_reset(control_signal.synch),
	
	//Output ports.
	.data_out(BSout2orMUXinput_wire)
);
//-----------------------MUX SUM1------------------------
bit [WORD_LENGHT-1:0] OROut_BS2MUX_wire;

assign OROut_BS2MUX_wire= {RoutRegister2Rshift_wire [WORD_LENGHT-3:0], BSout2orMUXinput_wire[1:0]};
Multiplexers 
#(.WORD_LENGHT(WORD_LENGHT)
)
MUX1
(
	// Input Ports
	.Selector(control_signal.controlEND),
	.Data_0(OROut_BS2MUX_wire),
	.Data_1(RoutRegister2Rshift_wire),
	
	// Output Ports
	.Mux_Output_log(add1_value)

);

//----------------- MUX sign------------------------------
Multiplexers 
#(.WORD_LENGHT(1'b1)
)
MUX_sign
(
	// Input Ports
	.Selector(control_signal.controlEND),
	.Data_0(~RoutRegister2Rshift_wire[WORD_LENGHT-1]),
	.Data_1(1'b0),
	
	// Output Ports
	.Mux_Output_log(sign)

);
//---------------- MUX 2.1--------------------------
bit [WORD_LENGHT-1:0] data0_value_wire;
bit [WORD_LENGHT-1:0] data1_value_wire;

assign data0_value_wire = {QoutRegister_wire[WORD_LENGHT-3:0], 2'b01};
assign data1_value_wire = {QoutRegister_wire[WORD_LENGHT-3:0], 2'b11};

bit [WORD_LENGHT-1:0] MUXout21MUXadd22_wire;

Multiplexers 
#( .WORD_LENGHT(WORD_LENGHT)
)
MUX21
(
	// Input Ports
	.Selector(RoutRegister2Rshift_wire[WORD_LENGHT-1]),
	.Data_0(data0_value_wire),
	.Data_1(data1_value_wire),
	
	// Output Ports
	.Mux_Output_log(MUXout21MUXadd22_wire)
);
//----------------------------MUX 2.2-----------------	
bit[WORD_LENGHT-1:0] data1_wire_add;
assign data1_wire_add = {QoutRegister_wire[WORD_LENGHT-2:0],1'b1};

Multiplexers 
#(.WORD_LENGHT(WORD_LENGHT)
)
MUX22
(
	// Input Ports
	.Selector(control_signal.controlEND),
	.Data_0(MUXout21MUXadd22_wire),
	.Data_1(data1_wire_add),
	
	// Output Ports
	.Mux_Output_log(add2_value)
);

//---------------------------MUX 2 RegQ-----------------

bit [WORD_LENGHT-1:0] MUXout2REGQ_wire;
bit [WORD_LENGHT-1:0] data1_MUXQ_wire;
bit [WORD_LENGHT-1:0] data0_MUXQ_wire;
assign data0_MUXQ_wire = {QoutRegister_wire [WORD_LENGHT-2:0],1'b1};
assign data1_MUXQ_wire = QoutRegister_wire << 1;


Multiplexers 
#(.WORD_LENGHT(WORD_LENGHT)
)
MUX2RegQ
(
	// Input Ports
	.Selector(Add_result[WORD_LENGHT-1]),
	.Data_0(data0_MUXQ_wire),
	.Data_1(data1_MUXQ_wire),
	
	// Output Ports
	.Mux_Output_log(MUXout2REGQ_wire)
);

//---------------------------- REGISTER Q-------------------
Register 
#(
	.Word_Length(WORD_LENGHT)
)
REGQ
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.Data_Input(MUXout2REGQ_wire),
	.enable(control_signal.enable),
	.sync_reset(control_signal.synch),

	// Output Ports
	.Data_Output(QoutRegister_wire)
);
//-----------------------------MUX 2 REG R---------------------
bit [WORD_LENGHT-1:0] MUXout2REGR_wire;
bit  selector_mux2reg_wire;

assign selector_mux2reg_wire = control_signal.controlEND & (~RoutRegister2Rshift_wire[WORD_LENGHT-1]);

Multiplexers 
#(.WORD_LENGHT(WORD_LENGHT)
)
MUX2RegR
(
	// Input Ports
	.Selector(selector_mux2reg_wire),
	.Data_0(Add_result),
	.Data_1(RoutRegister2Rshift_wire),
	
	// Output Ports
	.Mux_Output_log(MUXout2REGR_wire)
);
//--------------------------- REGISTER R--------------------------
bit enable_regR;
assign enable_regR = ((control_signal.controlEND) & (RoutRegister2Rshift_wire[WORD_LENGHT-1])) | control_signal.enable;

Register 
#(
	.Word_Length(WORD_LENGHT)
)
REGR
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.Data_Input(MUXout2REGR_wire),
	.enable(enable_regR),
	.sync_reset(control_signal.synch),

	// Output Ports
	.Data_Output(RoutRegister2Rshift_wire)
);

assign out_R = RoutRegister2Rshift_wire;
assign out_Q = QoutRegister_wire;
	
endmodule