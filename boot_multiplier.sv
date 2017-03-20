import Definitions ::*;
module boot_multiplier
#(parameter WORD_LENGHT = 4)
(
	//Inputs
	input clk,
	input rst,
	input MULTIPLIER_CONTROL_SIGNALS control,    //Señales de control provenientes de la máquina de estados
	input [WORD_LENGHT-1:0]m1_in,
	input [WORD_LENGHT-1:0]m2_in,
	input [2*WORD_LENGHT:0]AddResult_in,			

	//Outputs
	output [2*WORD_LENGHT-1:0]P_out,
	output [2*WORD_LENGHT:0]Add1_out,
	output [2*WORD_LENGHT:0]Add2_out,
	output AddSign_out

	);
	bit [2*WORD_LENGHT:0]A_wire, Pp_wire;   //Valores iniciales

	bit [2*WORD_LENGHT:0]Add_2_mux_wire;
	bit [2*WORD_LENGHT:0]Mux_2_Preg_wire;
	bit register_enable_wire;
	bit [2*WORD_LENGHT:0]P_out_temp;

	//Asignaciones directas
	assign A_wire = {m1_in, {(WORD_LENGHT+1){1'b0}}};
	assign Pp_wire = {{(WORD_LENGHT){1'b0}}, m2_in, 1'b0};
	assign AddSign_out = P_out_temp[1];
	assign Add1_out = P_out_temp;


	Multiplexers
	#(.WORD_LENGHT(2*WORD_LENGHT+1))    MUX_S_A

	(
		// Input Ports
		.Selector(P_out_temp[0] ^ P_out_temp[1]),
		.Data_0({2*WORD_LENGHT+1{1'b0}}),
		.Data_1(A_wire),

		// Output Ports
		.Mux_Output_log(Add2_out)

	);

	assign Add_2_mux_wire = {AddResult_in[2*WORD_LENGHT], AddResult_in[2*WORD_LENGHT:1]};


		Multiplexers
	#(.WORD_LENGHT(2*WORD_LENGHT+1))    MUX_Shift_2_register
	(
		// Input Ports
		.Selector(control.load),		//--------------------------------Señal de control, falta crearla
		.Data_0(Add_2_mux_wire),
		.Data_1(Pp_wire),

		// Output Ports
		.Mux_Output_log(Mux_2_Preg_wire)

	);

	assign register_enable_wire = control.enable;

	 Register
	#(.Word_Length(2*WORD_LENGHT+1)) P_output_register
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input(Mux_2_Preg_wire),
		.enable(register_enable_wire),
		.sync_reset(1'b0),

		// Output Ports
		.Data_Output(P_out_temp)
	);
	assign P_out = P_out_temp[2*WORD_LENGHT:1];
endmodule
