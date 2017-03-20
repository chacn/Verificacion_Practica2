module unsigned_adder_substracter
#(parameter WORD_LENGHT = 4)
(
  //Inputs
  input [WORD_LENGHT-1:0]operand_1_in,
  input [WORD_LENGHT-1:0]operand_2_in,
  input sign_in,
  //Outputs
  output [WORD_LENGHT-1:0]result
  );
  wire [WORD_LENGHT-1:0]new_operand;
  assign new_operand = ({WORD_LENGHT{~sign_in}} & operand_2_in) | ({WORD_LENGHT{sign_in}} & (~operand_2_in)+1'b1);

  assign result = operand_1_in + new_operand;

endmodule
