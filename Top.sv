module Top(

	// Input Ports
	input clk,
	input rst,
	input start,
	input load,
	input push_in,
	input [15:0]data_in,
	input [1:0]opcode,

	// Output Ports
	output [15:0]result,
	output [15:0]residue,
	output signo,
	output error,
	output ready,
	output load_x,
	output load_y,
	output [6:0]unidades,
	output [6:0]decenas,
	output [6:0]centenass,
	output [6:0]millares,
	output [6:0]millones

);

bit [15:0]outputResult_wire;
bit [15:0]outputResidue_wire;
bit [15:0]out_MUX2BCD_wire;
bit new_clk_wire;

//--------------------------Clock divider--------------------------
Clk_Divider
#(.Freq_in(50000000), .Freq_out(10)
	
)
(
//Input ports
.clk_FPGA(clk),
.reset(rst),

//Output ports
.clk_signal(new_clk_wire)

);

//-----------------------MSD--------------------------------------
MSD
#(.WORD_LENGHT(16))
MSD_MODULE
(
  //Inputs
  .clk(new_clk_wire),
  .rst(rst),
  .start(~start),
  .load(~load),
  .opcode(opcode),
  .data(data_in),

  //Outputs
  .result(outputResult_wire),
  .residue(outputResidue_wire),
  .ready_flag(ready),
  .error_flag(error),
  .load_x(load_x),
  .load_y(load_y)
  );

 //-------------------MUX RESULTADO O RESIDUO-----------------------------
 Multiplexers
#(.WORD_LENGHT(16))     MUX_RESULT_RESIDUE

(
	// Input Ports
	.Selector(~push_in),
	.Data_0(outputResult_wire),
	.Data_1(outputResidue_wire),

	// Output Ports
	.Mux_Output_log(out_MUX2BCD_wire)

);

//----------------------------DISPLAY---------------------------------------

paldisplay Display
(
	// Input Ports
	.clk(new_clk_wire),
	.rst(rst),
	.data_in(out_MUX2BCD_wire),

	// Output Ports
	.unidades_out(unidades),
	.decenas_out(decenas),
	.centenass_out(centenass),
	.millares_out(millares),
	.millones_out(millones),
	.signo(signo)
);

assign result = outputResult_wire;
assign residue = outputResidue_wire;

endmodule
