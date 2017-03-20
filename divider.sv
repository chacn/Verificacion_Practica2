import Definitions ::*;
module divider
#(parameter WORD_LENGHT = 4)
(
  //Inputs
  input clk,
  input rst,
  input DIVIDER_CONTROL_SIGNALS control,    //Señales de control provenientes de la máquina de estados
  input [WORD_LENGHT-1:0]divider,
  input [WORD_LENGHT-1:0]dividend,
  input [WORD_LENGHT-1:0]AddResult_in,

  //Outputs
  output [WORD_LENGHT-1:0]Result,
  output [WORD_LENGHT-1:0]Residue,
  output [WORD_LENGHT-1:0]Add1_out,
  output [WORD_LENGHT-1:0]Add2_out,
  output AddSign_out
  );
  //------------==========---Wires declarations---------------------------------
  bit [WORD_LENGHT-1:0]shift_left_dividend_out_wire;

  bit [WORD_LENGHT-1:0]temporal_dividend_out_wire;

  bit [WORD_LENGHT-1:0]mux_data1_in_wire;
  bit [WORD_LENGHT-1:0]mux_data0_in_wire;
  bit [WORD_LENGHT-1:0]mux_out_2_dividend_wire;

  bit [WORD_LENGHT-1:0]result_register_data_in_wire;
  bit [WORD_LENGHT-1:0]result_register_data_out_wire;



  //-----------------------Original dividend shift left----------------------------------
  Shift_Register_left
	#( .Word_Length(WORD_LENGHT))       SHIFT_LEFT_DIVIDEND
	(
	 // Input Ports
	 .clk(clk),
	 .reset(rst),
	 .Data_Input(dividend),
	 .load(control.load),
	 .shift(control.shift),
	 .sync_rst(1'b0),

	 // Output Ports
	 .Data_Output(shift_left_dividend_out_wire)
	);

	//-------------------Multiplexer substractor to register------------------------
	assign mux_data0_in_wire = {AddResult_in[WORD_LENGHT-2:0], shift_left_dividend_out_wire[WORD_LENGHT-1]};   //Shift left with lsb=msb_dividend
	assign mux_data1_in_wire = {temporal_dividend_out_wire[WORD_LENGHT-2:0], shift_left_dividend_out_wire[WORD_LENGHT-1]};   //Shift left with lsb=msb_dividend
	Multiplexers
	#(.WORD_LENGHT(WORD_LENGHT))    MUX_SUBSTRACT_2_REGISTER
	(
	// Input Ports
	.Selector(AddResult_in[WORD_LENGHT-1]),		
	.Data_0(mux_data0_in_wire),
	.Data_1(mux_data1_in_wire),

	// Output Ports
	.Mux_Output_log(mux_out_2_dividend_wire)

	);


	//-----------------------Temporal Dividend register-----------------------------
	Register
	#(.Word_Length(WORD_LENGHT))        TEMPORAL_DIVIDEND_REGISTER
	(
	 // Input Ports
	 .clk(clk),
	 .reset(rst),
	 .Data_Input(mux_out_2_dividend_wire),
	 .enable(control.shift),
	 .sync_reset(control.sync_rst),

	 // Output Ports
	 .Data_Output(temporal_dividend_out_wire)
	);

	//-----------------------Result register-----------------------------
	assign result_register_data_in_wire = {result_register_data_out_wire[WORD_LENGHT-2:0], ~AddResult_in[WORD_LENGHT-1]};
	Register
	#(.Word_Length(WORD_LENGHT))        RESULT_REGISTER
	(
	 // Input Ports
	 .clk(clk),
	 .reset(rst),
	 .Data_Input(result_register_data_in_wire),
	 .enable(control.shift),
	 .sync_reset(control.sync_rst),

	 // Output Ports
	 .Data_Output(result_register_data_out_wire)
	);

	//---------------------------Outputs assignment---------------------------------
	assign AddSign_out = 1'b1;
	assign Residue = {1'b0,temporal_dividend_out_wire[WORD_LENGHT-1:1]};
	assign Result = result_register_data_out_wire;
	assign Add1_out = temporal_dividend_out_wire;
	assign Add2_out = divider;
endmodule
