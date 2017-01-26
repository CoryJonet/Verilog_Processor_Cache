module stall_flush(
		//stalling netlist		
		ID_Instr_out, IE_Instr_out, IE_memRead_out, 
		rst, clk, stall, 
		IF_PC_sf, PC_val, PC_next, 
		IF_Instr_in, IF_Instr_sf, 
		IF_pc_2_w_in, ID_pc_2_w_out, IF_pc_2_w_sf,
		IF_halt_in, ID_halt_out, IF_halt_sf, 
		ID_Branch_in, ID_ALUsrc_in, ID_memWrite_in, ID_memRead_in, ID_memToReg_in,
	        ID_noOp_in, ID_jmp_in, ID_jumpType_in, ID_regWrite_in, ID_halt_in,
                ID_instrType_in, ID_Instr_in,
		ID_writereg_in, ID_read2data_in, ID_read1data_in, ID_pc_2_w_in, ID_sign_ext_in,
		ID_Branch_sf, ID_ALUsrc_sf, ID_memWrite_sf, ID_memRead_sf, ID_memToReg_sf, 
	        ID_noOp_sf, ID_jmp_sf, ID_jumpType_sf, ID_regWrite_sf, ID_halt_sf,
		ID_instrType_sf, ID_Instr_sf, ID_writereg_sf, ID_read2data_sf, ID_read1data_sf, 
		ID_sign_ext_sf, ID_pc_2_w_sf,

		//flushing netlist
		IE_BranchTaken_out, IE_jmp_out);

        input rst, clk;

	// Input: Load word stall hazard
	input IE_memRead_out, IF_halt_in, ID_halt_out;

	// Input: Load word stall hazard
	input [15:0] IE_Instr_out, ID_Instr_out;

	// Input: Stall PC val for word stall hazard
	input [15:0] PC_val, PC_next;
	
	// Input: Stall Instr, pc_2_w, halt for word stall hazard
	input [15:0] IF_Instr_in, IF_pc_2_w_in, ID_pc_2_w_out;

	output stall;
	wire halt_stall;

	// Output: Stalled Instr, pc_2_w, halt for word stall hazard
	wire [15:0] PC_stall, Instr_stall, pc_2_w_stall;

        // Input: Bubble
	input ID_Branch_in, ID_ALUsrc_in, ID_memWrite_in, ID_memRead_in, ID_memToReg_in,
	      ID_noOp_in, ID_jmp_in, ID_jumpType_in, ID_regWrite_in, ID_halt_in;

	input [1:0] ID_instrType_in;

	input [2:0] ID_writereg_in;

	input [15:0] ID_Instr_in, ID_read2data_in, ID_read1data_in, ID_pc_2_w_in, ID_sign_ext_in;

	wire Branch_bubble, ALUsrc_bubble, memWrite_bubble, memRead_bubble, memToReg_bubble, 
	       noOp_bubble, jmp_bubble, jumpType_bubble, regWrite_bubble, halt_bubble;

	wire [1:0] instrType_bubble;
	
	wire [2:0] writereg_bubble;

	wire [15:0] Instr_bubble, read2data_bubble, read1data_bubble, 
		sign_ext_bubble, pc_2_w_bubble;


        stall stall0(.ID_Instr_out(ID_Instr_out), .IE_Instr_out(IE_Instr_out), 
			.IE_memRead_out(IE_memRead_out), 
			.rst(rst), .clk(clk), 
			
			.stall(stall), 
			.PC_stall(PC_stall), .PC_val(PC_val), .PC_next(PC_next), 
			.IF_Instr_in(IF_Instr_in), .Instr_stall(Instr_stall), 
			.IF_pc_2_w_in(IF_pc_2_w_in), .ID_pc_2_w_out(ID_pc_2_w_out), .pc_2_w_stall(pc_2_w_stall),
			.IF_halt_in(IF_halt_in), .ID_halt_out(ID_halt_out), .halt_stall(halt_stall), 

			//bubbles
			.ID_Branch_in(ID_Branch_in), .Branch_bubble(Branch_bubble),
			.ID_ALUsrc_in(ID_ALUsrc_in), .ALUsrc_bubble(ALUsrc_bubble),
			.ID_memWrite_in(ID_memWrite_in), .memWrite_bubble(memWrite_bubble),
	        	.ID_memRead_in(ID_memRead_in), .memRead_bubble(memRead_bubble),
			.ID_memToReg_in(ID_memToReg_in), .memToReg_bubble(memToReg_bubble),
			.ID_noOp_in(ID_noOp_in), .noOp_bubble(noOp_bubble),
			.ID_jmp_in(ID_jmp_in), .jmp_bubble(jmp_bubble),
			.ID_jumpType_in(ID_jumpType_in), .jumpType_bubble(jumpType_bubble),
			.ID_regWrite_in(ID_regWrite_in), .regWrite_bubble(regWrite_bubble),
			.ID_halt_in(ID_halt_in), .halt_bubble(halt_bubble), 
			.ID_instrType_in(ID_instrType_in), .instrType_bubble(instrType_bubble),
			.ID_Instr_in(ID_Instr_in), .Instr_bubble(Instr_bubble),
			.ID_writereg_in(ID_writereg_in), .writereg_bubble(writereg_bubble),
			.ID_read2data_in(ID_read2data_in), .read2data_bubble(read2data_bubble),
			.ID_read1data_in(ID_read1data_in), .read1data_bubble(read1data_bubble),
			.ID_pc_2_w_in(ID_pc_2_w_in), .pc_2_w_bubble(pc_2_w_bubble),
			.ID_sign_ext_in(ID_sign_ext_in), .sign_ext_bubble(sign_ext_bubble));

	//*******************************FLUSHING***************************************
	//Control signals to determine flushing
	input IE_BranchTaken_out, IE_jmp_out;	
	
	// Stage One: IF/ID
	wire [15:0] IF_Instr_flush, IF_pc_2_w_flush;
	
	wire IF_halt_flush;

	// Stage Two: ID/IE
	//input ID_Branch_in, ID_ALUsrc_in, ID_memWrite_in, ID_memRead_in, ID_memToReg_in, ID_noOp_in, ID_jmp_in, ID_jumpType_in, ID_regWrite_in, ID_halt_in;

	//input [1:0] ID_instrType_in;

	//input [2:0] ID_writereg_in;

	wire [15:0] ID_Instr_flush, ID_read2data_flush, ID_read1data_flush, ID_sign_ext_flush, ID_pc_2_w_flush;

	wire ID_Branch_flush, ID_ALUsrc_flush, ID_memWrite_flush, ID_memRead_flush, ID_memToReg_flush, ID_noOp_flush, ID_jmp_flush, ID_jumpType_flush, ID_regWrite_flush, ID_halt_flush;

	wire [1:0] ID_instrType_flush;

	wire [2:0] ID_writereg_flush;

	wire branch_or_jmp;

	flush flush0(	.BranchTaken(IE_BranchTaken_out), .jmp(IE_jmp_out),
		//Stage one: IF/ID		
		.IF_Instr_in(IF_Instr_in), .IF_Instr_flush(IF_Instr_flush),
		.IF_pc_2_w_in(IF_pc_2_w_in), .IF_pc_2_w_flush(IF_pc_2_w_flush), 
		.IF_halt_in(IF_halt_in), .IF_halt_flush(IF_halt_flush),
		
		//Stage two: ID/IE
		.ID_Instr_in(ID_Instr_in), .ID_Instr_flush(ID_Instr_flush),
		.ID_read2data_in(ID_read2data_in), .ID_read2data_flush(ID_read2data_flush),
		.ID_read1data_in(ID_read1data_in), .ID_read1data_flush(ID_read1data_flush),
		.ID_sign_ext_in(ID_sign_ext_in), .ID_sign_ext_flush(ID_sign_ext_flush),
		.ID_Branch_in(ID_Branch_in), .ID_Branch_flush(ID_Branch_flush),
		.ID_instrType_in(ID_instrType_in), .ID_instrType_flush(ID_instrType_flush),
		.ID_ALUsrc_in(ID_ALUsrc_in), .ID_ALUsrc_flush(ID_ALUsrc_flush),
		.ID_memWrite_in(ID_memWrite_in), .ID_memWrite_flush(ID_memWrite_flush),
		.ID_memRead_in(ID_memRead_in), .ID_memRead_flush(ID_memRead_flush),
		.ID_memToReg_in(ID_memToReg_in), .ID_memToReg_flush(ID_memToReg_flush),
		.ID_noOp_in(ID_noOp_in), .ID_noOp_flush(ID_noOp_flush),
		.ID_jmp_in(ID_jmp_in), .ID_jmp_flush(ID_jmp_flush),
		.ID_pc_2_w_in(ID_pc_2_w_in), .ID_pc_2_w_flush(ID_pc_2_w_flush),
		.ID_jumpType_in(ID_jumpType_in), .ID_jumpType_flush(ID_jumpType_flush),
		.ID_regWrite_in(ID_regWrite_in), .ID_regWrite_flush(ID_regWrite_flush),
		.ID_writereg_in(ID_writereg_in), .ID_writereg_flush(ID_writereg_flush),
		.ID_halt_in(ID_halt_in), .ID_halt_flush(ID_halt_flush),

		.branch_or_jmp(branch_or_jmp));


	//Top most level
	output IF_halt_sf;

	// Output: Stalled Instr, pc_2_w, halt for word stall hazard
	output [15:0] IF_PC_sf, IF_Instr_sf, IF_pc_2_w_sf;

	//bubbles or stalls;
	output ID_Branch_sf, ID_ALUsrc_sf, ID_memWrite_sf, ID_memRead_sf, ID_memToReg_sf, 
	       ID_noOp_sf, ID_jmp_sf, ID_jumpType_sf, ID_regWrite_sf, ID_halt_sf;

	output [1:0] ID_instrType_sf;
	
	output [2:0] ID_writereg_sf;

	output [15:0] ID_Instr_sf, ID_read2data_sf, ID_read1data_sf, 
		ID_sign_ext_sf, ID_pc_2_w_sf;


	assign IF_halt_sf = branch_or_jmp ? IF_halt_flush : 
				stall ? halt_stall : 
				IF_halt_in;

	assign IF_PC_sf = PC_stall;

	
	assign IF_Instr_sf = branch_or_jmp ? IF_Instr_flush :
				stall ? Instr_stall :
				IF_Instr_in;

	assign IF_pc_2_w_sf = branch_or_jmp ? IF_pc_2_w_flush :
				stall ? pc_2_w_stall :
				IF_pc_2_w_in;

	assign ID_Branch_sf = branch_or_jmp ? ID_Branch_flush :
				stall ? Branch_bubble :
				ID_Branch_in;
	
	assign ID_ALUsrc_sf = branch_or_jmp ? ID_ALUsrc_flush :
				stall ? ALUsrc_bubble :
				ID_ALUsrc_in;

	assign ID_memWrite_sf = branch_or_jmp ? ID_memWrite_flush :
				stall ? memWrite_bubble :
				ID_memWrite_in;

	assign ID_memRead_sf = branch_or_jmp ? ID_memRead_flush :
				stall ? memRead_bubble :
				ID_memRead_in;
	
	assign ID_memToReg_sf = branch_or_jmp ? ID_memToReg_flush :
				stall ? memToReg_bubble :
				ID_memToReg_in;

	assign ID_noOp_sf = branch_or_jmp ? ID_noOp_flush :
				stall ? noOp_bubble :
				ID_noOp_in;

	assign ID_jmp_sf = branch_or_jmp ? ID_jmp_flush :
				stall ? jmp_bubble :
				ID_jmp_in;

	assign ID_jumpType_sf = branch_or_jmp ? ID_jumpType_flush :
				stall ? jumpType_bubble :
				ID_jumpType_in;

	assign ID_regWrite_sf = branch_or_jmp ? ID_regWrite_flush :
				stall ? regWrite_bubble :
				ID_regWrite_in;

	assign ID_halt_sf = branch_or_jmp ? ID_halt_flush :
				stall ? halt_bubble :
				ID_halt_in;

	assign ID_instrType_sf = branch_or_jmp ? ID_instrType_flush :
				stall ? instrType_bubble :
				ID_instrType_in;

	assign ID_writereg_sf = branch_or_jmp ? ID_writereg_flush :
				stall ? writereg_bubble :
				ID_writereg_in;

	assign ID_Instr_sf = branch_or_jmp ? ID_Instr_flush :
				stall ? Instr_bubble :
				ID_Instr_in;

	assign ID_read2data_sf = branch_or_jmp ? ID_read2data_flush :
				stall ? read2data_bubble :
				ID_read2data_in;

	assign ID_read1data_sf = branch_or_jmp ? ID_read1data_flush :
				stall ? read1data_bubble :
				ID_read1data_in;

	assign ID_sign_ext_sf = branch_or_jmp ? ID_sign_ext_flush :
				stall ? sign_ext_bubble :
				ID_sign_ext_in;

	assign ID_pc_2_w_sf = branch_or_jmp ? ID_pc_2_w_flush :
				stall ? pc_2_w_bubble :
				ID_pc_2_w_in;


endmodule
