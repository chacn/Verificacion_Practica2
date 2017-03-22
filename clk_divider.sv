module Clk_Divider
#(
	parameter Freq_in = 50000000, Freq_out = 100
	
)
(
//Input ports
input clk_FPGA,
input reset,

//Output ports
output clk_signal

);

parameter frequency = Freq_in/Freq_out;
logic [CeilLog2(frequency)-1:0] counter_reg;
logic clk_signal_wire;

always_ff @(posedge clk_FPGA, negedge reset)
begin

	if (reset == 1'b0)
		counter_reg <= 1'b0;
	
	else begin

		if(counter_reg == frequency-1)
			counter_reg <= 1'b0;
		else
			counter_reg <= counter_reg + 1;
	
	end

end

always_comb 
begin
		
		if(counter_reg < frequency/2)
			clk_signal_wire = 1;
		
		else
			clk_signal_wire = 0;
		

end

assign clk_signal = clk_signal_wire;

/*Log Function*/
     function integer CeilLog2;
       input integer data;
       integer i,result;
       begin
          for(i=0; 2**i < data; i=i+1)
             result = i + 1;
          CeilLog2 = result;
       end
    endfunction


endmodule 