module MSD_TB;
localparam  WORD_LENGHT = 16;
 // Input Ports
reg clk = 0;
reg reset;
reg start;
reg [WORD_LENGHT-1:0]operand = 2000;
wire [WORD_LENGHT-1:0]result;
reg [1:0]opcode = 2'b00;
reg load;



MSD #(.WORD_LENGHT(WORD_LENGHT))
DUT
(
	//Inputs
  .clk(clk),
  .rst(reset),
  .start(start),
  .load(load),
  .opcode(opcode),
  .data(operand),

  //Outputs
  .result(),
  .residue(),
  .ready_flag(),
  .error_flag(),
  .load_x(),
  .load_y()
);

/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#0 reset = 1;
        #4 reset = 0;
	#4 reset = 1;
end


initial begin // Raiz
	#24 start = 1;
      opcode = 2'b01;
	#10 start = 0;
	#10 operand = 270;
	    load = 1;
	#10 load=0;

	#150 start = 1;
	     opcode = 2'b01;
	#10 start = 0;
	#10 operand = -270;
	    load = 1;
	#10 load=0;
end

// initial begin // Multiplicacion
// 	#24 start = 1;
//       opcode = 2'b10;
// 	#10 start = 0;
// 	#10 operand = 270;
// 	    load = 1;
// 	#10 load=0;
// 	#15 operand = 50;
// 	    load = 1;
// 	#10 load=0;
//
// 	#150 start = 1;
// 	     opcode = 2'b10;
// 	#10 start = 0;
// 	#10 operand = -270;
// 	    load = 1;
// 	#10 load=0;
// 	#15 operand = 50;
// 	    load = 1;
// 	#10 load=0;
//
// 	#100 start = 1;
// 	     opcode = 2'b10;
// 	#10 start = 0;
//   #10 operand = -270;
// 	    load = 1;
// 	#10 load=0;
// 	#15 operand = -50;
// 	    load = 1;
// 	#10 load=0;
//
//   #100 start = 1;
//        opcode = 2'b10;
//   #10 start = 0;
//   #10 operand = 500;
//       load = 1;
//   #10 load=0;
//   #15 operand = 200;
//       load = 1;
//   #10 load=0;
//
// end
endmodule
