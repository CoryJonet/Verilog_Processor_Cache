module fetch(jumpType, ALU_res, sign_ext, BranchTaken, jmp, Instr, pc_2_w, clk, rst, fetch_stall, halt, PC_stall, PC_val, PC_next, IE_pc_2_w_out, dest);

	input jumpType, BranchTaken, jmp, clk, rst;
	input [15:0] ALU_res, sign_ext, PC_stall, IE_pc_2_w_out;
	input [10:0] dest;
	
	output [15:0] Instr, pc_2_w, PC_val, PC_next;

	output fetch_stall, halt;
	
	wire err, Done, Stall, CacheHit;
	wire mem_stall, rst_out;
	
	dff rst_flop(.d(rst), .q(rst_out), .clk(clk), .rst(1'b0));

	//assign PCin = stall ? PC_stall: PC_next; 
	assign halt = (Instr[15:11] == 5'b00000) & ~rst_out & ~fetch_stall;
	assign fetch_stall = mem_stall | rst_out;

	branchjump branch_datapath(.Instr(PC_val), .dest(dest), 
			.alu_out(ALU_res), .jump_type(jumpType), .sign_ext(sign_ext), 
			.taken(BranchTaken), .jump(jmp), .pc_in(PC_next), .pc_2_w(pc_2_w), .IE_pc_2_w_out(IE_pc_2_w_out));

	mem_system instrMem(.DataOut(Instr), .DataIn(16'h0000), .Addr(PC_val), 
			.Wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst), 
			.Done(Done), .Stall(mem_stall), .CacheHit(CacheHit), .Rd(1'b1), .err(err));

	dff PC[15:0](.d(PC_stall), .q(PC_val), .clk(clk), .rst(rst));

endmodule
