module sign_extend( Instr, instr5, instr8, instr_type, out);

	input [15:0] Instr;
	input [4:0] instr5;
	input [7:0] instr8;
	input [1:0] instr_type;
	output [15:0] out;

	wire is_zero_ext;

	//wire imm;
	//assign imm = (instr_type == 2'b10 || instr_type == 2'b01) ? 1'b1 : 1'b0;

	assign is_zero_ext = (Instr[15:11]==5'b0_1011) | (Instr[15:11]==5'b0_1010);

	assign out = is_zero_ext ? {{11{1'b0}}, instr5} :
			((instr_type == 2'b10)? {{8{instr8[7]}}, instr8} : {{11{instr5[4]}}, instr5});

endmodule

