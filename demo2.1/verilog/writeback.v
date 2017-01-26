module writeback(memToReg, ALU_res, noOp, jmp, pc_2_w, memToRegMux, memOut);

	input memToReg, noOp, jmp;
	input [15:0] ALU_res, pc_2_w, memToRegMux;

	output [15:0] memOut;

	assign memOut = jmp ? pc_2_w :
				(noOp ? 16'h0000 : (
				memToReg ? memToRegMux : ALU_res));
		

endmodule
