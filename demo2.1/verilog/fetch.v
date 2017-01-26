module fetch(jumpType, ALU_res, sign_ext, BranchTaken, jmp, Instr, pc_2_w, clk, rst, stall, halt, PC_stall, PC_val, PC_next, IE_pc_2_w_out, IE_Instr_out);

	input jumpType, BranchTaken, jmp, clk, rst, stall, halt;
	input [15:0] ALU_res, sign_ext, PC_stall, IE_pc_2_w_out, IE_Instr_out;
	
	output [15:0] Instr, pc_2_w, PC_val, PC_next;

	wire err;

	//assign PCin = stall ? PC_stall: PC_next; 
	assign halt = (Instr[15:11] == 5'b00000) & !rst;

	branchjump branch_datapath(.Instr(PC_val), .dest(IE_Instr_out[10:0]), 
			.alu_out(ALU_res), .jump_type(jumpType), .sign_ext(sign_ext), 
			.taken(BranchTaken), .jump(jmp), .pc_in(PC_next), .pc_2_w(pc_2_w), .IE_pc_2_w_out(IE_pc_2_w_out));

	memory2c_align instrMem(.data_out(Instr), .data_in(16'h0000), .addr(PC_val), 
			.enable(1'b1), .wr(1'b0), .createdump(1'b1), .clk(clk), .rst(rst), .err(err));

	dff PC[15:0](.d(PC_stall), .q(PC_val), .clk(clk), .rst(rst));

endmodule
