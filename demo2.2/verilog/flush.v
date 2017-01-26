module flush(	BranchTaken, jmp,
		//Stage one: IF/ID		
		IF_Instr_in, IF_Instr_flush,
		IF_pc_2_w_in, IF_pc_2_w_flush, 
		IF_halt_in, IF_halt_flush,
		
		//Stage two: ID/IE
		ID_Instr_in, ID_Instr_flush,
		ID_read2data_in, ID_read2data_flush,
		ID_read1data_in, ID_read1data_flush,
		ID_sign_ext_in, ID_sign_ext_flush,
		ID_Branch_in, ID_Branch_flush,
		ID_instrType_in, ID_instrType_flush,
		ID_ALUsrc_in, ID_ALUsrc_flush,
		ID_memWrite_in, ID_memWrite_flush,
		ID_memRead_in, ID_memRead_flush,
		ID_memToReg_in, ID_memToReg_flush,
		ID_noOp_in, ID_noOp_flush,
		ID_jmp_in, ID_jmp_flush,
		ID_pc_2_w_in, ID_pc_2_w_flush,
		ID_jumpType_in, ID_jumpType_flush,
		ID_regWrite_in, ID_regWrite_flush,
		ID_writereg_in, ID_writereg_flush,
		ID_halt_in, ID_halt_flush,

		branch_or_jmp);

	///TODO place read2data and read1data in stall module.

	//Control signals to determine flushing
	input BranchTaken, jmp;	
	
	// Stage One: IF/ID
	input [15:0] IF_Instr_in, IF_pc_2_w_in; 
	
	input IF_halt_in;

	output [15:0] IF_Instr_flush, IF_pc_2_w_flush;
	
	output IF_halt_flush;

	// Stage Two: ID/IE
	input [15:0] ID_Instr_in, ID_read2data_in, ID_read1data_in,ID_sign_ext_in, ID_pc_2_w_in;

	input ID_Branch_in, ID_ALUsrc_in, ID_memWrite_in, ID_memRead_in, ID_memToReg_in, ID_noOp_in, ID_jmp_in, ID_jumpType_in, ID_regWrite_in, ID_halt_in;

	input [1:0] ID_instrType_in;

	input [2:0] ID_writereg_in;

	output [15:0] ID_Instr_flush, ID_read2data_flush, ID_read1data_flush,ID_sign_ext_flush, ID_pc_2_w_flush;

	output ID_Branch_flush, ID_ALUsrc_flush, ID_memWrite_flush, ID_memRead_flush, ID_memToReg_flush, ID_noOp_flush, ID_jmp_flush, ID_jumpType_flush, ID_regWrite_flush, ID_halt_flush;

	output [1:0] ID_instrType_flush;

	output [2:0] ID_writereg_flush;

	output branch_or_jmp;
	
	assign branch_or_jmp = BranchTaken | jmp;

	assign IF_Instr_flush = branch_or_jmp ? 16'h0000 : IF_Instr_in;
	assign IF_pc_2_w_flush = branch_or_jmp ? 16'h0000 : IF_pc_2_w_in;
	assign IF_halt_flush = branch_or_jmp ? 1'b0 : IF_halt_in;

	assign ID_Instr_flush = branch_or_jmp ? 16'h0000 : ID_Instr_in;
	assign ID_read2data_flush = branch_or_jmp ? 16'h0000 : ID_read2data_in;
	assign ID_read1data_flush = branch_or_jmp ? 16'h0000: ID_read1data_in;
	assign ID_sign_ext_flush = branch_or_jmp ? 16'h0000 : ID_sign_ext_in;
	assign ID_pc_2_w_flush = branch_or_jmp ? 16'h0000: ID_pc_2_w_in;

	assign ID_Branch_flush = branch_or_jmp ? 1'b0 : ID_Branch_in;
	assign ID_ALUsrc_flush = branch_or_jmp ? 1'b0 : ID_ALUsrc_in;
	assign ID_memWrite_flush = branch_or_jmp ? 1'b0 : ID_memWrite_in;
	assign ID_memRead_flush = branch_or_jmp ? 1'b0 : ID_memRead_in;
	assign ID_memToReg_flush = branch_or_jmp ? 1'b0 : ID_memToReg_in;
	assign ID_noOp_flush = branch_or_jmp ? 1'b0 : ID_noOp_in;
	assign ID_jmp_flush = branch_or_jmp ? 1'b0 : ID_jmp_in;
	assign ID_jumpType_flush = branch_or_jmp ? 1'b0 : ID_jumpType_in;
	assign ID_regWrite_flush = branch_or_jmp ? 1'b0 : ID_regWrite_in;
	assign ID_halt_flush = branch_or_jmp ? 1'b0 : ID_halt_in;

	assign ID_instrType_flush = branch_or_jmp ? 2'b00 : ID_instrType_in;
	assign ID_writereg_flush = branch_or_jmp ? 3'b000 : ID_writereg_in;	

endmodule
