import Definitions ::*;
module MSD
#(parameter WORD_LENGHT=16)
(
  //Inputs
  input clk,
  input rst,
  input start,
  input load,
  input [1:0]opcode,
  input [WORD_LENGHT-1:0]data,

  //Outputs
  output [WORD_LENGHT-1:0]result,
  output [WORD_LENGHT-1:0]residue,
  output ready_flag,
  output error_flag,
  output load_x,
  output load_y
  );
//-----------------------Type definitions-------------------------------------
typedef struct packed{
	bit [2*WORD_LENGHT:0]add1;
	bit [2*WORD_LENGHT:0]add2;
	bit sign;

} ADDER_INPUTS;


//---------------------------Input state machine wires--------------------------
	bit [WORD_LENGHT-1:0]input_operand_1_wire;
	bit [WORD_LENGHT-1:0]input_operand_2_wire;
	bit [1:0]input_opcode_wire;
	bit input_start_wire;
	bit input_error_wire;
	bit input_sign_1;
	bit input_sign_2;
	bit output_sign;
//---------------------------Control signal wires-------------------------------
  CONTROL_SIGNALS control;
//-----------------------Adder interconections wires----------------------------
  bit [2*WORD_LENGHT:0]adder_operand_1_wire;
  bit [2*WORD_LENGHT:0]adder_operand_2_wire;
  bit adder_sign_wire;
  bit [2*WORD_LENGHT:0] adder_result_wire;
//---------------------Multiplier interconections wires-------------------------
  ADDER_INPUTS multiplier_2_adder;
  bit [2*WORD_LENGHT-1:0]multiplier_result_wire;
//---------------------Divider interconection wires-----------------------------
  ADDER_INPUTS divider_2_adder;
  bit [WORD_LENGHT-1:0]divider_result_wire;
  bit [WORD_LENGHT-1:0]divider_residue_wire;
  //--------------------- SQRT interconection wires-------------------------------
  	ADDER_INPUTS sqrt_2_adder;
    bit [WORD_LENGHT-1:0]sqrt_result_wire;
    bit [WORD_LENGHT-1:0]sqrt_residue_wire;
//-----------------------------Mux adder input wires----------------------------
  ADDER_INPUTS mux_out_to_adder;
//-----------------------------Mux to result wires------------------------------
  bit [WORD_LENGHT-1:0]mux_result_out_wire;
//-----------------------------Mux to remainder wires---------------------------
  bit [WORD_LENGHT-1:0]mux_remainder_out_wire;
//-------------------------------a2 wires---------------------------------------
	bit [WORD_LENGHT-1:0]binary_2_a2_result_wire;
  
  
  
//--------------------------Input state machine---------------------------
 input_control
#(.WORD_LENGHT(WORD_LENGHT))			INPUT_CONTROL_MODULE
(
	.clk(clk),
	.rst(rst),
	.data(data),
	.opCode(opcode),
	.start(start),
	.load(load),
	
	.operand_1(input_operand_1_wire),
	.sign_1_out(input_sign_1),
	.operand_2(input_operand_2_wire),
	.sign_2_out(input_sign_2),
	.opCode_R_out(input_opcode_wire),
	.load_x_out(load_x),
	.load_y_out(load_y),
	.start_out(input_start_wire),
	.error(input_error_wire)
	);
	

//-------------------------Control unit----------------------------
  control
  #(.WORD_LENGHT(WORD_LENGHT))        CONTROL_MODULE
  (
    //Inputs
  	.clk(clk),
  	.rst(rst),
  	.start(input_start_wire | start),
	.sync_rst(input_error_wire | start),
    .opc_code(input_opcode_wire),
    //Outputs
  	.control(control)
  );
    
  
//--------------------------Multiplier unit--------------------------
  boot_multiplier
  #(.WORD_LENGHT(WORD_LENGHT))         MULTIPLIER_MODULE
  (
  	//Inputs
  	.clk(clk),
  	.rst(rst),
  	.control(control.multiplier),    //Señales de control provenientes de la máquina de estados
  	.m1_in(input_operand_1_wire),
  	.m2_in(input_operand_2_wire),
  	.AddResult_in(adder_result_wire),			//Revisar ancho el bus

  	//Outputs
  	.P_out(multiplier_result_wire),
  	.Add1_out(multiplier_2_adder.add1),
  	.Add2_out(multiplier_2_adder.add2),
  	.AddSign_out(multiplier_2_adder.sign)

  	);

//------------------------------Divider unit--------------------------------
	divider
	#(.WORD_LENGHT(WORD_LENGHT))				DIVIDER_MODULE
	(
	  //Inputs
	  .clk(clk),
	  .rst(rst),
	  .control(control.divider),    //Señales de control provenientes de la máquina de estados
	  .divider(input_operand_2_wire),
	  .dividend(input_operand_1_wire),
	  .AddResult_in(adder_result_wire[WORD_LENGHT-1:0]),

	  //Outputs
	  .Result(divider_result_wire),
	  .Residue(divider_residue_wire),
	  .Add1_out(divider_2_adder.add1[WORD_LENGHT-1:0]),
	  .Add2_out(divider_2_adder.add2[WORD_LENGHT-1:0]),
	  .AddSign_out(divider_2_adder.sign)
	  );
//------------------------------- SQRT unit----------------------------------
     SQRT
    #(.WORD_LENGHT(WORD_LENGHT))        SQRT_MODULE
    (
    	//Input Ports.
    	.input_D(input_operand_1_wire),
    	.clk(clk),
    	.reset(rst),
    	.control_signal(control.sqrt), //Definitions
    	.Add_result(adder_result_wire[WORD_LENGHT-1:0]),

    	//Output ports.
    	.out_R(sqrt_residue_wire),
    	.out_Q(sqrt_result_wire),
    	.add1_value(sqrt_2_adder.add1[WORD_LENGHT-1:0]),
    	.add2_value(sqrt_2_adder.add2[WORD_LENGHT-1:0]),
    	.sign(sqrt_2_adder.sign)

    );
//--------------------------Multiplexer to adder-----------------------------
  	Multiplexers_4_to_1
	#(.WORD_LENGHT(4*WORD_LENGHT+3))    MUX_BEFORE_ADDER
	(
	// Input Ports
	.Selector(input_opcode_wire),
	.Data_0(divider_2_adder),
	.Data_1(sqrt_2_adder),
	.Data_2(multiplier_2_adder),
	.Data_3(0),
	// Output Ports
	.Mux_Output_log(mux_out_to_adder)

	);
//-----------------------------Adder unit-----------------------------------
    unsigned_adder_substracter
    #(.WORD_LENGHT(2*WORD_LENGHT+1))       ADDER_MODULE
    (
      //Inputs
      .operand_1_in(mux_out_to_adder.add1),
      .operand_2_in(mux_out_to_adder.add2),
      .sign_in(mux_out_to_adder.sign),
      //Outputs
      .result(adder_result_wire)
      );

//--------------------------Multiplexer to result-----------------------------

  	Multiplexers_4_to_1
	#(.WORD_LENGHT(WORD_LENGHT))    MUX_TO_RESULT_REGISTER
	(
	// Input Ports
	.Selector(input_opcode_wire),
	.Data_0(divider_result_wire),
	.Data_1(sqrt_result_wire),
	.Data_2(multiplier_result_wire),
	.Data_3(0),
	// Output Ports
	.Mux_Output_log(mux_result_out_wire)

	);
//-------------------------Result binary to a2---------------------------------
	assign output_sign = input_sign_1 ^ input_sign_2;
 binary_2_a2
 #(.word_lenght(WORD_LENGHT))        BINARY_2_A2_RESULT
(
	// Input Ports
	.word_in(mux_result_out_wire),
	.signo(output_sign),

	// Output Ports
	.Word_out(binary_2_a2_result_wire)
);
//----------------------------Result Register----------------------------------
	 Register
	#(.Word_Length(WORD_LENGHT)) RESULT_REGISTER
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input(binary_2_a2_result_wire),
		.enable(control.multiplier.ready),
		.sync_reset(input_error_wire),

		// Output Ports
		.Data_Output(result)
	);

//--------------------------Multiplexer to remainder-----------------------------
	Multiplexers
	#(.WORD_LENGHT(WORD_LENGHT))    MUX_TO_REMAINDER_REGISTER
	(
		// Input Ports
		.Selector(input_opcode_wire[0]),		
		.Data_0(divider_residue_wire),
		.Data_1(sqrt_residue_wire),

		// Output Ports
		.Mux_Output_log(mux_remainder_out_wire)

	);

//----------------------------Remainder Register----------------------------------
	 Register
	#(.Word_Length(WORD_LENGHT)) REMAINDER_REGISTER
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input(mux_remainder_out_wire),
		.enable(control.multiplier.ready),
		.sync_reset(input_error_wire),

		// Output Ports
		.Data_Output(residue)
	);
	
//----------------------------Ready flag Register----------------------------------
	 Register
	#(.Word_Length(1)) READY_FLAG_REGISTER
	(
		// Input Ports
		.clk(clk),
		.reset(rst),
		.Data_Input(control.multiplier.ready),
		.enable(1'b1),
		.sync_reset(1'b0),

		// Output Ports
		.Data_Output(ready_flag)
	);
//---------------------------Outputs--------------------------------------
		assign error_flag = input_error_wire;
endmodule
