module input_control_TB;
 // Input Ports
reg clk = 0;
reg reset;
reg start;
reg [7:0]operand = 3;
reg [1:0]opcode = 2'b01;
reg load = 0;


input_control #(.WORD_LENGHT(8))
DUT
(
  .clk(clk),
  .rst(reset),
  .data(operand),
  .opCode(opcode),
  .start(start),
  .load(load)
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

initial begin // reset generator
	#0 start = 0;
	#12 start = 1;
  #4 start = 0;
	#120 start = 1;
	#4 start = 0;
end

initial begin // operand generator
	#24 operand = 3;
	    load = 1;
	#10 load=0;
	#48 operand = 12;
	    load = 1;
	#10 load=0;
  
end

initial begin
	#50 start = 1;
	#20 start = 0;
end
/*********************************************************/
// initial begin // enable
//     #0 start = 0;
//     #18 start = 1;
//     #15 start = 0;
//
//
//     #70 start = 1;
//     #20 start = 0;
// end

endmodule