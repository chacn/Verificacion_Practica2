 module paldisplay
(
	// Input Ports
	input clk,
	input rst,
	input [15:0]data_in,
	//input [Word_Length-1:0] Data_Input,

	// Output Ports
	output [6:0] unidades_out,
	output [6:0] decenas_out,
	output [6:0] centenass_out,
	output [6:0] millares_out,
	output [6:0] millones_out,
	output signo
);
parameter input_lenght = 16, nDisplays = 5;    //El tamaño de dato que usaremos en el módulo de BCD

//Outputs
logic [6:0] unidades_segmentos_wire;
logic [6:0] decenas_segmentos_wire;
logic [6:0] centenas_segmentos_wire;
logic [6:0] millares_segmentos_wire;
logic [6:0] millones_segmentos_wire;


bit [15:0] data2bdc_wire;

bit signo_2_BCD_wire;

bit [3:0] out_BCD_wire [nDisplays-1:0];    //Wire para conectar la salida del BCD a los segmentos


//--------------------Conversión a2 a binario-----------------
 Complemento_a2
 #(.word_lenght(input_lenght)) data_a2_2_binary
(
	// Input Ports
	.word_in(data_in),
	// Output Ports
	.Word_out(data2bdc_wire),
	.signo(signo_2_BCD_wire)
);



//-------------------------BCD y displays-------------------------------------------

//Instancia del módulo de BCD 
deco_bcd_v2  #(.input_lenght(input_lenght), .nDisplays(nDisplays)) binary_to_decimal 
(
	// Input Ports
	.binary_in(data2bdc_wire[input_lenght-1:0]) ,

	// Output Ports
	.out(out_BCD_wire)
);
//Instancia del display de 7 segmentos para las unidades
display display_unidades(
	 .num(out_BCD_wire[0][3:0]),
	 .segments(unidades_segmentos_wire)
 ); 
 //Instancia del display de 7 segmentos para las decenas
 display display_decenas(
	 .num(out_BCD_wire[1][3:0]),
	 .segments(decenas_segmentos_wire)
 ); 
 //Instancia del display de 7 segmentos para las centenas
 display display_centenas(
	 .num(out_BCD_wire[2][3:0]),
	 .segments(centenas_segmentos_wire)
 ); 
 //Instancia del display de 7 segmentos para las millares
  display display_millares(
	 .num(out_BCD_wire[3][3:0]),
	 .segments(millares_segmentos_wire)
 ); 
  //Instancia del display de 7 segmentos para las millones
  display display_millones(
	 .num(out_BCD_wire[4][3:0]),
	 .segments(millones_segmentos_wire)
 );
 
 //-------------------------Asignación de las salidas-----------------------------------
 assign unidades_out = unidades_segmentos_wire;
 assign decenas_out = decenas_segmentos_wire;
 assign centenass_out = centenas_segmentos_wire;
 assign millares_out = millares_segmentos_wire;
 assign millones_out = millones_segmentos_wire;
 assign signo = ~signo_2_BCD_wire;

endmodule
