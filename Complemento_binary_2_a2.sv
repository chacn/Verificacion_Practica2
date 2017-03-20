 module binary_2_a2
 #(parameter word_lenght = 8)
(
	// Input Ports
	input [word_lenght-1:0]word_in,
	input signo,

	// Output Ports
	output [word_lenght-1:0] Word_out
);
	bit [word_lenght-1:0] Word_reg;


	always_comb 
	begin
		if(signo)
			Word_reg = (~word_in)+1'b1;
		else
			Word_reg = word_in;
	end
	
	//Asignación de salidas
	assign Word_out = Word_reg;
	
endmodule

