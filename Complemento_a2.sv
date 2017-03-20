 module Complemento_a2
 #(parameter word_lenght = 8)
(
	// Input Ports
	input [word_lenght-1:0]word_in,

	// Output Ports
	output [word_lenght-1:0] Word_out,
	output signo
);
	logic [word_lenght-1:0] Word_reg;


	always_comb 
	begin
		if(word_in[word_lenght-1])
			Word_reg = (~word_in)+1'b1;
		else
			Word_reg = word_in;
	end
	
	//Asignación de salidas
	assign signo = word_in[word_lenght-1];
	assign Word_out = Word_reg;
	
endmodule

