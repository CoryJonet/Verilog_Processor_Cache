module stall_flush(
		//stalling netlist		
		ID_Instr_out, IE_Instr_out, IE_memRead_out, 
		rst, clk, stall, fetch_stall, mem_stall, 
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
		
		//decode
		IE_read2data_out, IE_read1data_out, IE_sign_ext_out, IE_pc_2_w_out,
		IE_Branch_out, IE_ALUsrc_out, IE_memWrite_out, IE_memToReg_out, IE_noOp_out, 
		IE_jumpType_out, IE_regWrite_out, IE_halt_out, IE_writereg_out, 
		IE_instrType_out,
		
		//execute
		IE_ALU_res_in, M_ALU_res_out, IE_read2data_in, M_read2data_out, IE_pc_2_w_in, M_pc_2_w_out,
		IE_memWrite_in, M_memWrite_out, IE_memToReg_in, M_memToReg_out, IE_noOp_in, M_noOp_out, IE_jmp_in, M_jmp_out, 
		IE_memRead_in, M_memRead_out, IE_regWrite_in, M_regWrite_out, IE_halt_in, M_halt_out, 
		IE_writereg_in, M_writereg_out,
		
		IE_M_ALU_res_stall, IE_M_read2data_stall, IE_M_pc_2_w_stall, IE_M_memWrite_stall, IE_M_memToReg_stall, 
		IE_M_noOp_stall, IE_M_jmp_stall, IE_M_memRead_stall, IE_M_regWrite_stall, IE_M_halt_stall,
		IE_M_writereg_stall,
		
		//memory
		M_ALU_res_in, WB_ALU_res_out, M_pc_2_w_in, WB_pc_2_w_out, M_memToRegMux_in, WB_memToRegMux_out, M_memToReg_in, 
		WB_memToReg_out, M_noOp_in, WB_noOp_out, M_jmp_in, WB_jmp_out, M_regWrite_in, WB_regWrite_out, 
		M_halt_in, WB_halt_out, M_writereg_in, WB_writereg_out,
		
		M_WB_ALU_res_stall, M_WB_pc_2_w_stall, M_WB_memToRegMux_stall, M_WB_memToReg_stall, M_WB_noOp_stall, 
		M_WB_jmp_stall, M_WB_regWrite_stall, M_WB_halt_stall, M_WB_writereg_stall,		

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
	input fetch_stall, mem_stall;
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
		
		
	// decode
	input [15:0] IE_read2data_out, IE_read1data_out, IE_sign_ext_out, IE_pc_2_w_out;

	input IE_Branch_out, IE_ALUsrc_out, IE_memWrite_out, IE_memToReg_out, IE_noOp_out, IE_jmp_out,
			IE_jumpType_out, IE_regWrite_out, IE_halt_out;

	input [2:0] IE_writereg_out;
			
	input [1:0] IE_instrType_out;
	
	wire [15:0] ID_IE_Instr_stall, ID_IE_read2data_stall, ID_IE_read1data_stall, ID_IE_sign_ext_stall, 
						ID_IE_pc_2_w_stall;

	wire ID_IE_Branch_stall, ID_IE_ALUsrc_stall, ID_IE_memWrite_stall, ID_IE_memToReg_stall, ID_IE_noOp_stall, 
			 ID_IE_jmp_stall, ID_IE_memRead_stall, ID_IE_jumpType_stall, ID_IE_regWrite_stall, ID_IE_halt_stall;

	wire [2:0] ID_IE_writereg_stall;

	wire [1:0] ID_IE_instrType_stall;
	
	// execute
	input [15:0] IE_ALU_res_in, M_ALU_res_out, IE_read2data_in, M_read2data_out, IE_pc_2_w_in, M_pc_2_w_out;

	input IE_memWrite_in, M_memWrite_out, IE_memToReg_in, M_memToReg_out, IE_noOp_in, M_noOp_out, IE_jmp_in, M_jmp_out, 
			IE_memRead_in, M_memRead_out, IE_regWrite_in, M_regWrite_out, IE_halt_in, M_halt_out;
	
	input [2:0] IE_writereg_in, M_writereg_out;
	
	output [15:0] IE_M_ALU_res_stall, IE_M_read2data_stall, IE_M_pc_2_w_stall;
	
	output IE_M_memWrite_stall, IE_M_memToReg_stall, IE_M_noOp_stall, IE_M_jmp_stall, IE_M_memRead_stall, 
				IE_M_regWrite_stall, IE_M_halt_stall;
				
	output [2:0] IE_M_writereg_stall;

	// memory
	input [15:0] M_ALU_res_in, WB_ALU_res_out, M_pc_2_w_in, WB_pc_2_w_out, M_memToRegMux_in, WB_memToRegMux_out;
	
	input M_memToReg_in, WB_memToReg_out, M_noOp_in, WB_noOp_out, M_jmp_in, 
			WB_jmp_out, M_regWrite_in, WB_regWrite_out, M_halt_in, WB_halt_out;
			
	input [2:0] M_writereg_in, WB_writereg_out;
	
	output [15:0] M_WB_memToRegMux_stall, M_WB_ALU_res_stall, M_WB_pc_2_w_stall;
	
	output M_WB_memToReg_stall, M_WB_noOp_stall, M_WB_jmp_stall, M_WB_regWrite_stall, 
			M_WB_halt_stall;
			
	output [2:0] M_WB_writereg_stall;

        stall stall0(.ID_Instr_out(ID_Instr_out), .IE_Instr_out(IE_Instr_out), 
			.IE_memRead_out(IE_memRead_out), 
			.rst(rst), .clk(clk), 
			
			.stall(stall), 
			.PC_stall(PC_stall), .PC_val(PC_val), .PC_next(PC_next), 
			.IF_Instr_in(IF_Instr_in), .Instr_stall(Instr_stall), 
			.IF_pc_2_w_in(IF_pc_2_w_in), .ID_pc_2_w_out(ID_pc_2_w_out), .pc_2_w_stall(pc_2_w_stall),
			.IF_halt_in(IF_halt_in), .ID_halt_out(ID_halt_out), .halt_stall(halt_stall),
			
			//inputs from stalling memories
			.fetch_stall(fetch_stall), .mem_stall(mem_stall),

			// Decode stage			
			.ID_IE_Instr_stall(ID_IE_Instr_stall),
			.IE_read2data_out(IE_read2data_out), .ID_IE_read2data_stall(ID_IE_read2data_stall),
			.IE_read1data_out(IE_read1data_out), .ID_IE_read1data_stall(ID_IE_read1data_stall),
			.IE_sign_ext_out(IE_sign_ext_out), .ID_IE_sign_ext_stall(ID_IE_sign_ext_stall),
			.IE_pc_2_w_out(IE_pc_2_w_out), .ID_IE_pc_2_w_stall(ID_IE_pc_2_w_stall),
			.IE_Branch_out(IE_Branch_out), .ID_IE_Branch_stall(ID_IE_Branch_stall),
			.IE_ALUsrc_out(IE_ALUsrc_out), .ID_IE_ALUsrc_stall(ID_IE_ALUsrc_stall),
			.IE_memWrite_out(IE_memWrite_out), .ID_IE_memWrite_stall(ID_IE_memWrite_stall),
		   .IE_memToReg_out(IE_memToReg_out), .ID_IE_memToReg_stall(ID_IE_memToReg_stall),
			.IE_noOp_out(IE_noOp_out), .ID_IE_noOp_stall(ID_IE_noOp_stall),
			.IE_jmp_out(IE_jmp_out), .ID_IE_jmp_stall(ID_IE_jmp_stall),
			.ID_IE_memRead_stall(ID_IE_memRead_stall),
			.IE_jumpType_out(IE_jumpType_out), .ID_IE_jumpType_stall(ID_IE_jumpType_stall),
			.IE_regWrite_out(IE_regWrite_out), .ID_IE_regWrite_stall(ID_IE_regWrite_stall),
			.IE_halt_out(IE_halt_out), .ID_IE_halt_stall(ID_IE_halt_stall),
			.IE_writereg_out(IE_writereg_out), .ID_IE_writereg_stall(ID_IE_writereg_stall),
		   .IE_instrType_out(IE_instrType_out), .ID_IE_instrType_stall(ID_IE_instrType_stall),

			// Execute stage
			.IE_ALU_res_in(IE_ALU_res_in), .M_ALU_res_out(M_ALU_res_out), .IE_M_ALU_res_stall(IE_M_ALU_res_stall),
			.IE_read2data_in(IE_read2data_in), .M_read2data_out(M_read2data_out), .IE_M_read2data_stall(IE_M_read2data_stall), 
			.IE_pc_2_w_in(IE_pc_2_w_in), .M_pc_2_w_out(M_pc_2_w_out), .IE_M_pc_2_w_stall(IE_M_pc_2_w_stall),
			.IE_memWrite_in(IE_memWrite_in), .M_memWrite_out(M_memWrite_out), .IE_M_memWrite_stall(IE_M_memWrite_stall),
			.IE_memToReg_in(IE_memToReg_in), .M_memToReg_out(M_memToReg_out), .IE_M_memToReg_stall(IE_M_memToReg_stall), 
			.IE_noOp_in(IE_noOp_in), .M_noOp_out(M_noOp_out), .IE_M_noOp_stall(IE_M_noOp_stall),
        	.IE_jmp_in(IE_jmp_in), .M_jmp_out(M_jmp_out), .IE_M_jmp_stall(IE_M_jmp_stall),
			.IE_memRead_in(IE_memRead_in), .M_memRead_out(M_memRead_out), .IE_M_memRead_stall(IE_M_memRead_stall), 
			.IE_regWrite_in(IE_regWrite_in), .M_regWrite_out(M_regWrite_out), .IE_M_regWrite_stall(IE_M_regWrite_stall),
			.IE_halt_in(IE_halt_in), .M_halt_out(M_halt_out), .IE_M_halt_stall(IE_M_halt_stall),
			.IE_writereg_in(IE_writereg_in), .M_writereg_out(M_writereg_out), .IE_M_writereg_stall(IE_M_writereg_stall),

			// Memory
			.M_ALU_res_in(M_ALU_res_in), .WB_ALU_res_out(WB_ALU_res_out), .M_WB_ALU_res_stall(M_WB_ALU_res_stall), 
			.M_pc_2_w_in(M_pc_2_w_in), .WB_pc_2_w_out(WB_pc_2_w_out), .M_WB_pc_2_w_stall(M_WB_pc_2_w_stall), 
			.M_memToRegMux_in(M_memToRegMux_in), .WB_memToRegMux_out(WB_memToRegMux_out), .M_WB_memToRegMux_stall(M_WB_memToRegMux_stall),
   		.M_memToReg_in(M_memToReg_in), .WB_memToReg_out(WB_memToReg_out), .M_WB_memToReg_stall(M_WB_memToReg_stall), 
			.M_noOp_in(M_noOp_in), .WB_noOp_out(WB_noOp_out), .M_WB_noOp_stall(M_WB_noOp_stall), 
			.M_jmp_in(M_jmp_in), .WB_jmp_out(WB_jmp_out), .M_WB_jmp_stall(M_WB_jmp_stall),
			.M_regWrite_in(M_regWrite_in), .WB_regWrite_out(WB_regWrite_out), .M_WB_regWrite_stall(M_WB_regWrite_stall),
			.M_halt_in(M_halt_in), .WB_halt_out(WB_halt_out), .M_WB_halt_stall(M_WB_halt_stall),
   		.M_writereg_in(M_writereg_in), .WB_writereg_out(WB_writereg_out), .M_WB_writereg_stall(M_WB_writereg_stall),
			 

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
	input IE_BranchTaken_out;	
	
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


	assign IF_halt_sf = (fetch_stall || mem_stall) ? halt_stall :
								branch_or_jmp ? IF_halt_flush : 
									stall ? halt_stall : 
										IF_halt_in;

	assign IF_PC_sf = PC_stall;

	
	assign IF_Instr_sf = (fetch_stall || mem_stall) ? Instr_stall :
									branch_or_jmp ? IF_Instr_flush :
										stall ? Instr_stall :
											IF_Instr_in;

	assign IF_pc_2_w_sf = (fetch_stall || mem_stall) ? pc_2_w_stall :
									branch_or_jmp ? IF_pc_2_w_flush :
										stall ? pc_2_w_stall :
											IF_pc_2_w_in;

	assign ID_Branch_sf = (fetch_stall || mem_stall) ? ID_IE_Branch_stall :
									branch_or_jmp ? ID_Branch_flush :
										stall ? Branch_bubble :
											ID_Branch_in;
	
	assign ID_ALUsrc_sf = (fetch_stall || mem_stall) ? ID_IE_ALUsrc_stall :
									branch_or_jmp ? ID_ALUsrc_flush :
										stall ? ALUsrc_bubble :
											ID_ALUsrc_in;

	assign ID_memWrite_sf = (fetch_stall || mem_stall) ? ID_IE_memWrite_stall :
										branch_or_jmp ? ID_memWrite_flush :
											stall ? memWrite_bubble :
												ID_memWrite_in;

	assign ID_memRead_sf = (fetch_stall || mem_stall) ? ID_IE_memRead_stall :
										branch_or_jmp ? ID_memRead_flush :
											stall ? memRead_bubble :
												ID_memRead_in;
	
	assign ID_memToReg_sf = (fetch_stall || mem_stall) ? ID_IE_memToReg_stall :
										branch_or_jmp ? ID_memToReg_flush :
											stall ? memToReg_bubble :
												ID_memToReg_in;

	assign ID_noOp_sf = (fetch_stall || mem_stall) ? ID_IE_noOp_stall :
									branch_or_jmp ? ID_noOp_flush :
										stall ? noOp_bubble :
											ID_noOp_in;

	assign ID_jmp_sf = (fetch_stall || mem_stall) ? ID_IE_jmp_stall :
								branch_or_jmp ? ID_jmp_flush :
									stall ? jmp_bubble :
										ID_jmp_in;

	assign ID_jumpType_sf = (fetch_stall || mem_stall) ? ID_IE_jumpType_stall :
										branch_or_jmp ? ID_jumpType_flush :
											stall ? jumpType_bubble :
												ID_jumpType_in;

	assign ID_regWrite_sf = (fetch_stall || mem_stall) ? ID_IE_regWrite_stall :
										branch_or_jmp ? ID_regWrite_flush :
											stall ? regWrite_bubble :
												ID_regWrite_in;

	assign ID_halt_sf = (fetch_stall || mem_stall) ? ID_IE_halt_stall : 
									branch_or_jmp ? ID_halt_flush :
										stall ? halt_bubble :
											ID_halt_in;

	assign ID_instrType_sf = (fetch_stall || mem_stall) ? ID_IE_instrType_stall :
											branch_or_jmp ? ID_instrType_flush :
												stall ? instrType_bubble :
													ID_instrType_in;

	assign ID_writereg_sf = (fetch_stall || mem_stall) ? ID_IE_writereg_stall :
										branch_or_jmp ? ID_writereg_flush :
											stall ? writereg_bubble :
												ID_writereg_in;

	assign ID_Instr_sf = (fetch_stall || mem_stall) ? ID_IE_Instr_stall :
									branch_or_jmp ? ID_Instr_flush :
										stall ? Instr_bubble :
											ID_Instr_in;

	assign ID_read2data_sf = (fetch_stall || mem_stall) ? ID_IE_read2data_stall :
											branch_or_jmp ? ID_read2data_flush :
												stall ? read2data_bubble :
													ID_read2data_in;

	assign ID_read1data_sf = (fetch_stall || mem_stall) ? ID_IE_read1data_stall :
											branch_or_jmp ? ID_read1data_flush :
												stall ? read1data_bubble :
													ID_read1data_in;

	assign ID_sign_ext_sf = (fetch_stall || mem_stall) ? ID_IE_sign_ext_stall :
											branch_or_jmp ? ID_sign_ext_flush :
												stall ? sign_ext_bubble :
													ID_sign_ext_in;

	assign ID_pc_2_w_sf = (fetch_stall || mem_stall) ? ID_IE_pc_2_w_stall :
										branch_or_jmp ? ID_pc_2_w_flush :
											stall ? pc_2_w_bubble :
												ID_pc_2_w_in;
												
	
	/*
	//execute
	assign IE_ALU_res_sf = IE_M_ALU_res_stall;
	assign IE_read2data_sf = IE_M_read2data_stall;
	assign IE_pc_2_w_sf = IE_M_pc_2_w_stall;
	assign IE_memWrite_sf = IE_M_memWrite_stall;
	assign IE_memToReg_sf = IE_M_memToReg_stall;
	assign IE_noOp_sf = IE_M_noOp_stall;
	assign IE_jmp_sf = IE_M_ALU_jmp_stall;
	assign IE_memRead_sf = IE_M_memRead_stall;
	assign IE_regWrite_sf = IE_M_regWrite_stall;
	assign IE_halt_sf = IE_M_halt_stall;
	assign IE_writereg_sf = IE_M_writereg_stall;
	
	// memory
   assign M_ALU_res_sf = M_WB_ALU_res_stall;
   assign M_pc_2_w_sf = M_WB_pc_2_w_stall;
   assign M_memToRegMux_sf = M_WB_memToRegMux_stall;
   assign M_memToReg_sf = M_WB_memToReg_stall;
   assign M_noOp_sf = M_WB_noOp_stall;
   assign M_jmp_sf = M_WB_jmp_stall;
   assign M_regWrite_sf = M_WB_regWrite_stall;
   assign M_halt_sf = M_WB_halt_stall;
   assign M_writereg_sf = M_WB_writereg_stall;
	*/

endmodule
