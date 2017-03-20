import Definitions ::*;
module control
#(parameter WORD_LENGHT = 4)
(
	input clk,
	input rst,
	input start,
	input sync_rst,
	input [1:0]opc_code,
	output CONTROL_SIGNALS control
);
localparam MAX_STATES = 2*WORD_LENGHT+10 + WORD_LENGHT/2;  //El numero máximo de estados a usar

//-------------Counter control signals-----------
bit [CeilLog2(MAX_STATES)-1:0]state_counter_wire;
bit state_counter_sync_reset_wire;
bit state_counter_enable_wire;
//-----------------------------------------------
bit [CeilLog2(MAX_STATES)-1:0]mux_out_address_to_load;
bit [1:0] mux_address_selector;



//------------------------------------ROM with control signals---------------------------------------
single_port_rom_multiplier
#(.DATA_WIDTH(MULTIPLIER_CONTROL_LENGHT), .ADDR_WIDTH(CeilLog2(MAX_STATES)) )       ROM_MULTIPLIER
(
	.addr(state_counter_wire),
	.clk(clk),
	.q(control.multiplier)
);

//---------------------------------MUX for operation address-----------------------------------------
	assign mux_address_selector = opc_code | {2{sync_rst}};
  	Multiplexers_4_to_1
	#(.WORD_LENGHT(CeilLog2(MAX_STATES))  )  MUX_ADDRESS_SELECT
	(
	// Input Ports
	.Selector(mux_address_selector),
	.Data_0(WORD_LENGHT+3),		//Divider control signals address
	.Data_1(2*WORD_LENGHT+6),
	.Data_2(1),		//multiplier control signals address
	.Data_3(0),
	// Output Ports
	.Mux_Output_log(mux_out_address_to_load)

	);

//-----------------------------Counter for current state---------------------------------------------
assign state_counter_sync_reset_wire = start;
assign state_counter_enable_wire = ~control.multiplier.ctrl_stop | start;
CounterWithLoad
#(	.Maximum_Value(MAX_STATES),    	.NBitsForCounter(CeilLog2(MAX_STATES)) )      CURRENT_STATE_SELECTOR
(
	// Input Ports
	.clk(clk),
	.reset(rst),
	.enable(state_counter_enable_wire),
	.load_value(state_counter_sync_reset_wire),
	.value_to_load(mux_out_address_to_load),

	// Output Ports
	.Flag(),
	.Counting(state_counter_wire)
);

//---------------------------------Output assigns-----------------------------------------
assign control.divider = control.multiplier;
assign control.sqrt = control.multiplier;

/*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/

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

/*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/






	endmodule
