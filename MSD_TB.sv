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

initial begin // operand generator
	#24 start = 1;
	#10 start = 0;
	#10 opcode = 2'b00;	    
	    operand = 16'b01111111111;
	    load = 1;
	#10 load=0;
	#15 operand = 35;
	    load = 1;
	#10 load=0;

	#150 start = 1;
	     opcode = 2'b10;
	#10 start = 0;
	#10 operand = 150;
	    load = 1;
	#10 load=0;
	#15 operand = 16'b01111111111;
	    load = 1;
	#10 load=0;

	#100 start = 1;
	     opcode = 2'b01;
	#10 start = 0;
	#10 operand = -150;
	    load = 1;
	#10 load=0;
  
end
//initial begin // reset generator
//	#0 start = 0;
//	#100 start = 1;
//      opcode = 0;
//  #4 start = 0;
//	#(WORD_LENGHT*10) start = 1;
//      opcode = 1;
//	#4 start = 0;
//  #(WORD_LENGHT*10) start = 1;
//      opcode = 2;
//  #4 start = 0;
//end

/*********************************************************/
// initial begin // enable
//     #0 start = 0;
//     #18 start = 1;
//     #6 start = 0;
//
//
//     #70 start = 1;
//     #6 start = 0;
// end

endmodule
