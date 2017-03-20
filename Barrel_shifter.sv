module Barrel_shifter
# (parameter WORD_LENGHT = 16)
(
	input [WORD_LENGHT-1:0]data_in,
	input clk,
	input reset,
	input shift_enable,
	input synch_reset,
	
	output [WORD_LENGHT-1:0]data_out
);

bit [WORD_LENGHT-1:0]counterOut2shift_wire;
bit [WORD_LENGHT-1:0]data_output_wire;

CounterParameter2
#(
	// Parameter Declarations
	.Maximum_Value(WORD_LENGHT/2)
)
Counter_data

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(shift_enable),
	.SyncReset(synch_reset),
	
	// Output Ports
	.Flag(),
	.Counting(counterOut2shift_wire) 
);


always_comb begin
  data_output_wire = data_in >> {counterOut2shift_wire[WORD_LENGHT-2:0], 1'b0};
end

assign data_out = data_output_wire;

endmodule