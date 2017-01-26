module computewritereg(Instr, RegDst, isSTU, jmp, writereg);

	input [15:0] Instr;
	input RegDst, isSTU, jmp;

	output [2:0] writereg;
	assign writereg = jmp ? 3'b111 : (isSTU ? Instr[10:8] : (RegDst ? Instr[4:2] : Instr[7:5]));

endmodule
