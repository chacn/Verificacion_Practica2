// Quartus II Verilog Template
// Single Port ROM

module single_port_rom_input
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	bit [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	initial
	begin
		$readmemb("input_rom_values_init.txt", rom);
	end

	assign q = rom[addr];

endmodule