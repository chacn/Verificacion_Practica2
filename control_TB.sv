import Definitions ::*;
module control_TB;
 // Input Ports
reg clk = 0;
reg reset;
reg start;


  // Output Ports
CONTROL_SIGNALS control;


control
DUT
(

	.clk(clk),
	.rst(reset),
	.start(start),
  .opc_code(2'b0),
	.control(control)
);


/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#0 reset = 1;
        #6 reset = 0;
	#6 reset = 1;
end

initial begin // reset generator
	#15 start = 1;
  #6 start = 0;
	#30 start = 1;
	#6 start = 0;
end

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
