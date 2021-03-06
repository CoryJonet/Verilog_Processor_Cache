module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here */
  assign err = 1'b0;

  wire jumpType, BranchTaken, jmp, stall;

   // Stalling: load word hazard
   wire IF_halt_sf;

   wire [15:0] ALU_res, memOut, sign_ext;
   
   // Stalling: load word hazard
   wire [15:0] IF_PC_sf, PC_val, PC_next, IF_Instr_sf, IF_pc_2_w_sf;

   // Stalling: bubble
	wire ID_Branch_sf, ID_ALUsrc_sf, ID_memWrite_sf, ID_memRead_sf, ID_memToReg_sf, 
	       ID_noOp_sf, ID_jmp_sf, ID_jumpType_sf, ID_regWrite_sf, ID_halt_sf;

	wire [1:0] ID_instrType_sf;
	
	wire [2:0] ID_writereg_sf;

	wire [15:0] ID_Instr_sf, ID_read2data_sf, ID_read1data_sf, 
		ID_sign_ext_sf, ID_pc_2_w_sf;
		
	//Stall signals from instruction and data memories
	wire fetch_stall, mem_stall;
	
	//wires for saving branching logic when instruction memory stalls.
	/*wire [15:0] alu_out_sb, sign_ext_sb, IE_pc_2_w_out_sb;
	wire [10:0] dest_sb;
	wire jump_type_sb, taken_sb, jump_sb;*/

/*   wire Branch_bubble, ALUsrc_bubble, memWrite_bubble, memRead_bubble, memToReg_bubble, 
	        noOp_bubble, jmp_bubble, jumpType_bubble, regWrite_bubble, halt_bubble;
	
   wire [1:0] instrType_bubble;

   wire [2:0] writereg_bubble;

   wire [15:0] Instr_bubble;*/

   // Forwarding
   wire [15:0] forward_A_data, forward_B_data;

   //***************************** INSTRUCTION FETCH to INSTRUCTION DECODE *************************************
   wire [15:0] IF_Instr_in, ID_Instr_out, IF_pc_2_w_in, ID_pc_2_w_out;
  
   wire IF_halt_in, ID_halt_out, IF_fetch_stall_in, ID_fetch_stall_out;
   
   assign IF_fetch_stall_in = fetch_stall; 

   dff IF_ID_Instr [15:0](.d(IF_Instr_sf), .q(ID_Instr_out), .clk(clk), .rst(rst));

   dff IF_ID_pc_2_w [15:0] (.d(IF_pc_2_w_sf), .q(ID_pc_2_w_out), .clk(clk), .rst(rst));

   dff IF_ID_halt (.d(IF_halt_sf), .q(ID_halt_out), .clk(clk), .rst(rst));
   
   dff IF_ID_fetch_stall (.d(IF_fetch_stall_in), .q(ID_fetch_stall_out), .clk(clk), .rst(rst));


   //***************************** INSTRUCTION DECODE to INSTRUCTION EXECUTE ************************************
   wire [15:0] ID_Instr_in, IE_Instr_out, ID_read2data_in, IE_read2data_out, ID_read1data_in, IE_read1data_out, 
	       ID_sign_ext_in, IE_sign_ext_out, ID_pc_2_w_in, IE_pc_2_w_out;

   wire ID_Branch_in, IE_Branch_out, ID_ALUsrc_in, IE_ALUsrc_out, ID_memWrite_in, IE_memWrite_out,
	ID_memToReg_in, IE_memToReg_out, ID_noOp_in, IE_noOp_out, ID_jmp_in, IE_jmp_out, ID_memRead_in, IE_memRead_out,
	ID_jumpType_in, IE_jumpType_out, ID_regWrite_in, IE_regWrite_out, ID_halt_in, IE_halt_out;//, IE_BranchTaken_out;
	
   wire [2:0] ID_writereg_in, IE_writereg_out;

   wire [1:0] ID_instrType_in, IE_instrType_out;
   
   wire ID_fetch_stall_in, IE_fetch_stall_out;

   assign ID_pc_2_w_in = ID_pc_2_w_out;
   assign ID_Instr_in = ID_Instr_out;
   //assign ID_read1data_in = IE_read1data_out;
   //assign ID_read2data_in = IE_read2data_out;
   assign ID_halt_in = ID_halt_out;
   assign ID_fetch_stall_in = ID_fetch_stall_out;

   dff ID_IE_Instr [15:0] (.d(ID_Instr_sf), .q(IE_Instr_out), .clk(clk), .rst(rst));

   dff ID_IE_read2data [15:0] (.d(ID_read2data_sf), .q(IE_read2data_out), .clk(clk), .rst(rst));

   dff ID_IE_read1data [15:0] (.d(ID_read1data_sf), .q(IE_read1data_out), .clk(clk), .rst(rst));

   dff ID_IE_sign_ext [15:0] (.d(ID_sign_ext_sf), .q(IE_sign_ext_out), .clk(clk), .rst(rst));

   dff ID_IE_Branch (.d(ID_Branch_sf), .q(IE_Branch_out), .clk(clk), .rst(rst));

   dff ID_IE_instrType [1:0] (.d(ID_instrType_sf), .q(IE_instrType_out), .clk(clk), .rst(rst));

   dff ID_IE_ALUsrc (.d(ID_ALUsrc_sf), .q(IE_ALUsrc_out), .clk(clk), .rst(rst));

   dff ID_IE_regWrite (.d(ID_regWrite_sf), .q(IE_regWrite_out), .clk(clk), .rst(rst));

   dff ID_IE_writereg [2:0] (.d(ID_writereg_sf), .q(IE_writereg_out), .clk(clk), .rst(rst));

   dff ID_IE_halt (.d(ID_halt_sf), .q(IE_halt_out), .clk(clk), .rst(rst));
   
   dff ID_IE_fetch_stall(.d(ID_fetch_stall_in), .q(IE_fetch_stall_out), .clk(clk), .rst(rst));

   	// FROM MEMORY:

   dff ID_IE_memWrite (.d(ID_memWrite_sf), .q(IE_memWrite_out), .clk(clk), .rst(rst));

   dff ID_IE_pc_2_w [15:0] (.d(ID_pc_2_w_sf), .q(IE_pc_2_w_out), .clk(clk), .rst(rst));

   dff ID_IE_memToReg (.d(ID_memToReg_sf), .q(IE_memToReg_out), .clk(clk), .rst(rst));

   dff ID_IE_noOp (.d(ID_noOp_sf), .q(IE_noOp_out), .clk(clk), .rst(rst));

   dff ID_IE_jmp (.d(ID_jmp_sf), .q(IE_jmp_out), .clk(clk), .rst(rst));

   dff ID_IE_memRead (.d(ID_memRead_sf), .q(IE_memRead_out), .clk(clk), .rst(rst));

	// Branch logic

   dff ID_IE_jumpType (.d(ID_jumpType_sf), .q(IE_jumpType_out), .clk(clk), .rst(rst));

   //***************************** INSTRUCTION EXECUTE to MEMORY *****************************************
   wire [15:0] IE_ALU_res_in, M_ALU_res_out, IE_read2data_in, M_read2data_out, IE_pc_2_w_in, M_pc_2_w_out;

   wire IE_memWrite_in, M_memWrite_out, IE_memToReg_in, M_memToReg_out, IE_noOp_in, M_noOp_out,
			IE_jmp_in, M_jmp_out, IE_memRead_in, M_memRead_out, IE_regWrite_in, M_regWrite_out,
			IE_halt_in, M_halt_out, IE_fetch_stall_in, M_fetch_stall_out;
	
   wire [2:0] IE_writereg_in, M_writereg_out;
   
   wire [15:0] IE_M_ALU_res_stall, IE_M_read2data_stall, IE_M_pc_2_w_stall;
	
	wire IE_M_memWrite_stall, IE_M_memToReg_stall, IE_M_noOp_stall, IE_M_jmp_stall, IE_M_memRead_stall, 
				IE_M_regWrite_stall, IE_M_halt_stall;
				
	wire [2:0] IE_M_writereg_stall;

   assign IE_read2data_in = forward_B_data;//IE_read2data_out;
   assign IE_memWrite_in = IE_memWrite_out;
   assign IE_memToReg_in = IE_memToReg_out;
   assign IE_noOp_in = IE_noOp_out;
   assign IE_jmp_in = IE_jmp_out;
   assign IE_pc_2_w_in = IE_pc_2_w_out;
   assign IE_regWrite_in = IE_regWrite_out;
   assign IE_writereg_in = IE_writereg_out;
   assign IE_halt_in = IE_halt_out;
   assign IE_memRead_in = IE_memRead_out;
   assign IE_fetch_stall_in = IE_fetch_stall_out;

   dff IE_M_ALU_res [15:0] (.d(IE_M_ALU_res_stall), .q(M_ALU_res_out), .clk(clk), .rst(rst));
   
   dff IE_M_read2data [15:0] (.d(IE_M_read2data_stall), .q(M_read2data_out), .clk(clk), .rst(rst));

   dff IE_M_memWrite (.d(IE_M_memWrite_stall), .q(M_memWrite_out), .clk(clk), .rst(rst));

   dff IE_M_regWrite (.d(IE_M_regWrite_stall), .q(M_regWrite_out), .clk(clk), .rst(rst));

   dff IE_M_writereg [2:0] (.d(IE_M_writereg_stall), .q(M_writereg_out), .clk(clk), .rst(rst));

   dff IE_M_halt (.d(IE_M_halt_stall), .q(M_halt_out), .clk(clk), .rst(rst));

   dff IE_M_memRead (.d(IE_M_memRead_stall), .q(M_memRead_out), .clk(clk), .rst(rst));
   
   dff IE_M_fetch_stall (.d(IE_fetch_stall_in), .q(M_fetch_stall_out), .clk(clk), .rst(rst));

   	// FROM WRITEBACK:

   dff IE_M_pc_2_w [15:0] (.d(IE_M_pc_2_w_stall), .q(M_pc_2_w_out), .clk(clk), .rst(rst));

   dff IE_M_memToReg (.d(IE_M_memToReg_stall), .q(M_memToReg_out), .clk(clk), .rst(rst));

   dff IE_M_noOp (.d(IE_M_noOp_stall), .q(M_noOp_out), .clk(clk), .rst(rst));

   dff IE_M_jmp (.d(IE_M_jmp_stall), .q(M_jmp_out), .clk(clk), .rst(rst));

   //***************************** MEMORY to WRITEBACK ******************************************************
   wire [15:0] M_WB_memToRegMux_stall, M_ALU_res_in, WB_ALU_res_out, M_pc_2_w_in, 
   				WB_pc_2_w_out, M_memToRegMux_in, WB_memToRegMux_out;
   
   wire M_memToReg_in, WB_memToReg_out, M_noOp_in, WB_noOp_out, M_jmp_in, WB_jmp_out,
	M_regWrite_in, WB_regWrite_out, M_halt_in, WB_halt_out, M_fetch_stall_in, WB_fetch_stall_out, WB_mem_stall_out;
	
   wire [2:0] M_writereg_in, WB_writereg_out;
   
   wire [15:0] M_WB_ALU_res_stall, M_WB_pc_2_w_stall;
	
	wire M_WB_memToReg_stall, M_WB_noOp_stall, M_WB_jmp_stall, M_WB_regWrite_stall, 
			M_WB_halt_stall;
			
	wire [2:0] M_WB_writereg_stall;

   assign M_ALU_res_in = M_ALU_res_out;
   assign M_pc_2_w_in = M_pc_2_w_out;
   assign M_memToReg_in = M_memToReg_out;
   assign M_noOp_in = M_noOp_out;
   assign M_jmp_in = M_jmp_out;
   assign M_regWrite_in = M_regWrite_out;
   assign M_writereg_in = M_writereg_out;
   assign M_halt_in = M_halt_out;
   assign M_fetch_stall_in = M_fetch_stall_out;

   dff M_WB_ALU_res [15:0] (.d(M_WB_ALU_res_stall), .q(WB_ALU_res_out), .clk(clk), .rst(rst));

   dff M_WB_pc_2_w [15:0] (.d(M_WB_pc_2_w_stall), .q(WB_pc_2_w_out), .clk(clk), .rst(rst));

   dff M_WB_memToReg (.d(M_WB_memToReg_stall), .q(WB_memToReg_out), .clk(clk), .rst(rst));

   dff M_WB_noOp (.d(M_WB_noOp_stall), .q(WB_noOp_out), .clk(clk), .rst(rst));

   dff M_WB_jmp (.d(M_WB_jmp_stall), .q(WB_jmp_out), .clk(clk), .rst(rst));

   dff M_WB_memToRegMux [15:0] (.d(M_WB_memToRegMux_stall), .q(WB_memToRegMux_out), .clk(clk), .rst(rst));

   dff M_WB_regWrite (.d(M_WB_regWrite_stall), .q(WB_regWrite_out), .clk(clk), .rst(rst));

   dff M_WB_writereg [2:0] (.d(M_WB_writereg_stall), .q(WB_writereg_out), .clk(clk), .rst(rst));

   dff M_WB_halt (.d(M_WB_halt_stall), .q(WB_halt_out), .clk(clk), .rst(rst));
   
   dff M_WB_fetch_stall (.d(M_fetch_stall_in), .q(WB_fetch_stall_out), .clk(clk), .rst(rst));
   
   dff M_WB_mem_stall (.d(mem_stall), .q(WB_mem_stall_out), .clk(clk), .rst(rst));

   	// Branch logic
   assign ALU_res = IE_ALU_res_in;
   assign jumpType = IE_jumpType_out;
   assign sign_ext = IE_sign_ext_out;
   assign jmp = IE_jmp_out;

	//halting stuff
	wire proc_halt;
	assign proc_halt = WB_halt_out || (IE_memWrite_in && M_halt_in);
   /*stall_flush stall_module(.ID_Instr_out(ID_Instr_out), .IE_Instr_out(IE_Instr_out), .IE_memRead_out(IE_memRead_out), 
		.rst(rst), .clk(clk), .stall(stall), 
		.PC_stall(PC_stall), .PC_val(PC_val), .PC_next(PC_next), 
		.IF_Instr_in(IF_Instr_in), .Instr_stall(Instr_stall), 
		.IF_pc_2_w_in(IF_pc_2_w_in), .ID_pc_2_w_out(ID_pc_2_w_out), .pc_2_w_stall(pc_2_w_stall),
		.IF_halt_in(IF_halt_in), .ID_halt_out(ID_halt_out), .halt_stall(halt_stall), 
		.ID_Branch_in(ID_Branch_in), .ID_ALUsrc_in(ID_ALUsrc_in), .ID_memWrite_in(ID_memWrite_in), 
	        .ID_memRead_in(ID_memRead_in), .ID_memToReg_in(ID_memToReg_in),
	        .ID_noOp_in(ID_noOp_in), .ID_jmp_in(ID_jmp_in), .ID_jumpType_in(ID_jumpType_in), 
		.ID_regWrite_in(ID_regWrite_in), .ID_halt_in(ID_halt_in), .ID_instrType_in(ID_instrType_in), 
		.ID_Instr_in(ID_Instr_in), .ID_writereg_in(ID_writereg_in), .ID_read2data_in(ID_read2data_in), 
		.ID_read1data_in(ID_read1data_in), .ID_pc_2_w_in(ID_pc_2_w_in), .ID_sign_ext_in(ID_sign_ext_in),
		.Branch_bubble(Branch_bubble), .ALUsrc_bubble(ALUsrc_bubble), .memWrite_bubble(memWrite_bubble), 
		.memRead_bubble(memRead_bubble), .memToReg_bubble(memToReg_bubble), 
	        .noOp_bubble(noOp_bubble), .jmp_bubble(jmp_bubble), .jumpType_bubble(jumpType_bubble), 
		.regWrite_bubble(regWrite_bubble), .halt_bubble(halt_bubble),
		.instrType_bubble(instrType_bubble), .Instr_bubble(Instr_bubble), .writereg_bubble(writereg_bubble), 
		.read2data_bubble(read2data_bubble), .read1data_bubble(read1data_bubble), 
		.sign_ext_bubble(sign_ext_bubble), .pc_2_w_bubble(pc_2_w_bubble));*/

	stall_flush stall_flush0(
		//stalling netlist		
		.ID_Instr_out(ID_Instr_out), .IE_Instr_out(IE_Instr_out), 
		.IE_memRead_out(IE_memRead_out),
		 
		.rst(rst), .clk(clk), .stall(stall), 
		.fetch_stall(fetch_stall), .mem_stall(mem_stall),
		.IF_PC_sf(IF_PC_sf), .PC_val(PC_val), 
		.PC_next(PC_next), .IF_Instr_in(IF_Instr_in), 
		.IF_Instr_sf(IF_Instr_sf), .IF_pc_2_w_in(IF_pc_2_w_in), 
		.ID_pc_2_w_out(ID_pc_2_w_out), .IF_pc_2_w_sf(IF_pc_2_w_sf),
		.IF_halt_in(IF_halt_in), .ID_halt_out(ID_halt_out), 
		.IF_halt_sf(IF_halt_sf), .ID_Branch_in(ID_Branch_in), 
		.ID_ALUsrc_in(ID_ALUsrc_in), .ID_memWrite_in(ID_memWrite_in), 
		.ID_memRead_in(ID_memRead_in), .ID_memToReg_in(ID_memToReg_in),
	   .ID_noOp_in(ID_noOp_in), .ID_jmp_in(ID_jmp_in), 
	   .ID_jumpType_in(ID_jumpType_in), .ID_regWrite_in(ID_regWrite_in), 
	   .ID_halt_in(ID_halt_in), .ID_instrType_in(ID_instrType_in), 
	   .ID_Instr_in(ID_Instr_in), .ID_writereg_in(ID_writereg_in), 
	   .ID_read2data_in(ID_read2data_in), .ID_read1data_in(ID_read1data_in), 
	   .ID_pc_2_w_in(ID_pc_2_w_in), .ID_sign_ext_in(ID_sign_ext_in),
		.ID_Branch_sf(ID_Branch_sf), .ID_ALUsrc_sf(ID_ALUsrc_sf), 
		.ID_memWrite_sf(ID_memWrite_sf), .ID_memRead_sf(ID_memRead_sf), 
		.ID_memToReg_sf(ID_memToReg_sf), .ID_noOp_sf(ID_noOp_sf), 
		.ID_jmp_sf(ID_jmp_sf), .ID_jumpType_sf(ID_jumpType_sf), 
		.ID_regWrite_sf(ID_regWrite_sf), .ID_halt_sf(ID_halt_sf),
		.ID_instrType_sf(ID_instrType_sf), .ID_Instr_sf(ID_Instr_sf), 
		.ID_writereg_sf(ID_writereg_sf), .ID_read2data_sf(ID_read2data_sf), 
		.ID_read1data_sf(ID_read1data_sf), .ID_sign_ext_sf(ID_sign_ext_sf), 
		.ID_pc_2_w_sf(ID_pc_2_w_sf),
		
		//decode
		.IE_read2data_out(IE_read2data_out), .IE_read1data_out(IE_read1data_out), 
		.IE_sign_ext_out(IE_sign_ext_out), .IE_pc_2_w_out(IE_pc_2_w_out),
		.IE_Branch_out(IE_Branch_out), .IE_ALUsrc_out(IE_ALUsrc_out), 
		.IE_memWrite_out(IE_memWrite_out), .IE_memToReg_out(IE_memToReg_out), 
		.IE_noOp_out(IE_noOp_out), 
		.IE_jumpType_out(IE_jumpType_out), .IE_regWrite_out(IE_regWrite_out), 
		.IE_halt_out(IE_halt_out), .IE_writereg_out(IE_writereg_out), 
		.IE_instrType_out(IE_instrType_out),
		
		//execute
		.IE_ALU_res_in(IE_ALU_res_in), .M_ALU_res_out(M_ALU_res_out), 
		.IE_read2data_in(IE_read2data_in), .M_read2data_out(M_read2data_out), 
		.IE_pc_2_w_in(IE_pc_2_w_in), .M_pc_2_w_out(M_pc_2_w_out),
		.IE_memWrite_in(IE_memWrite_in), .M_memWrite_out(M_memWrite_out), 
		.IE_memToReg_in(IE_memToReg_in), .M_memToReg_out(M_memToReg_out), 
		.IE_noOp_in(IE_noOp_in), .M_noOp_out(M_noOp_out), .IE_jmp_in(IE_jmp_in), 
		.M_jmp_out(M_jmp_out), .IE_memRead_in(IE_memRead_in), 
		.M_memRead_out(M_memRead_out), .IE_regWrite_in(IE_regWrite_in), 
		.M_regWrite_out(M_regWrite_out), .IE_halt_in(IE_halt_in), 
		.M_halt_out(M_halt_out), .IE_writereg_in(IE_writereg_in), 
		.M_writereg_out(M_writereg_out),
		
		.IE_M_ALU_res_stall(IE_M_ALU_res_stall), .IE_M_read2data_stall(IE_M_read2data_stall), 
		.IE_M_pc_2_w_stall(IE_M_pc_2_w_stall), .IE_M_memWrite_stall(IE_M_memWrite_stall), 
		.IE_M_memToReg_stall(IE_M_memToReg_stall), 
		.IE_M_noOp_stall(IE_M_noOp_stall), .IE_M_jmp_stall(IE_M_jmp_stall), 
		.IE_M_memRead_stall(IE_M_memRead_stall), .IE_M_regWrite_stall(IE_M_regWrite_stall), 
		.IE_M_halt_stall(IE_M_halt_stall),
		.IE_M_writereg_stall(IE_M_writereg_stall),
		
		//memory
		.M_ALU_res_in(M_ALU_res_in), .WB_ALU_res_out(WB_ALU_res_out), 
		.M_pc_2_w_in(M_pc_2_w_in), .WB_pc_2_w_out(WB_pc_2_w_out), 
		.M_memToRegMux_in(M_memToRegMux_in), .WB_memToRegMux_out(WB_memToRegMux_out), 
		.M_memToReg_in(M_memToReg_in), 
		.WB_memToReg_out(WB_memToReg_out), .M_noOp_in(M_noOp_in), 
		.WB_noOp_out(WB_noOp_out), .M_jmp_in(M_jmp_in), .WB_jmp_out(WB_jmp_out), 
		.M_regWrite_in(M_regWrite_in), .WB_regWrite_out(WB_regWrite_out), 
		.M_halt_in(M_halt_in), .WB_halt_out(WB_halt_out), .M_writereg_in(M_writereg_in), 
		.WB_writereg_out(WB_writereg_out),
		
		.M_WB_ALU_res_stall(M_WB_ALU_res_stall), .M_WB_pc_2_w_stall(M_WB_pc_2_w_stall), 
		.M_WB_memToRegMux_stall(M_WB_memToRegMux_stall), .M_WB_memToReg_stall(M_WB_memToReg_stall), 
		.M_WB_noOp_stall(M_WB_noOp_stall), 
		.M_WB_jmp_stall(M_WB_jmp_stall), .M_WB_regWrite_stall(M_WB_regWrite_stall), 
		.M_WB_halt_stall(M_WB_halt_stall), .M_WB_writereg_stall(M_WB_writereg_stall),		

		//flushing netlist
		.IE_BranchTaken_out(BranchTaken), .IE_jmp_out(IE_jmp_out));
		
		/*stall_branch stall_branch0 (.alu_out(IE_ALU_res_in), .sign_ext(IE_sign_ext_out), .IE_pc_2_w_out(IE_pc_2_w_out),
			.dest(IE_Instr_out[10:0]), .jump_type(IE_jumpType_out), .taken(BranchTaken), .jump(IE_jmp_out), .clk(clk), 
			.rst(rst), .fetch_stall(fetch_stall),
			
			.alu_out_sb(alu_out_sb), .sign_ext_sb(sign_ext_sb), .IE_pc_2_w_out_sb(IE_pc_2_w_out_sb),
			.dest_sb(dest_sb), .jump_type_sb(jump_type_sb), .taken_sb(taken_sb), .jump_sb(jump_sb));*/


   forwarding forward_module(.IE_Instr_out(IE_Instr_out), .IE_read1data_out(IE_read1data_out), .IE_read2data_out(IE_read2data_out),
			.M_regWrite_out(M_regWrite_out), .M_writereg_out(M_writereg_out), .M_ALU_res_out(M_ALU_res_out),
			.WB_regWrite_out(WB_regWrite_out), .WB_writereg_out(WB_writereg_out), .memOut(memOut),
			.forward_A_data(forward_A_data), .forward_B_data(forward_B_data), .memtoRegMux(M_memToRegMux_in), 
			.M_memRead_out(M_memRead_out));

		
	fetch fetch0(.jumpType(IE_jumpType_out), .ALU_res(IE_ALU_res_in), .sign_ext(IE_sign_ext_out), .BranchTaken(BranchTaken), 
			.jmp(IE_jmp_out), .Instr(IF_Instr_in), .pc_2_w(IF_pc_2_w_in), .clk(clk), .rst(rst), .fetch_stall(fetch_stall), 
			.halt(IF_halt_in), .PC_stall(IF_PC_sf), .PC_val(PC_val), .PC_next(PC_next), .IE_pc_2_w_out(IE_pc_2_w_out), 
			.dest(IE_Instr_out[10:0]));


   decode decode0(.Instr(ID_Instr_out), .memOut(memOut), .clk(clk), .rst(rst), 
		  .regWrite_in(WB_regWrite_out), .WBwriteReg(WB_writereg_out), 
		  .sign_ext(ID_sign_ext_in), .read1data(ID_read1data_in), .read2data(ID_read2data_in), 
		  .jumpType(ID_jumpType_in), .jmp(ID_jmp_in), .Branch(ID_Branch_in), .memWrite(ID_memWrite_in), 
		  .memRead(ID_memRead_in), .memToReg(ID_memToReg_in), .ALUSrc(ID_ALUsrc_in), .noOp(ID_noOp_in), 
		  .instrType(ID_instrType_in), .regWrite_out(ID_regWrite_in), .writereg(ID_writereg_in));


   execute execute0(.ALUSrc(IE_ALUsrc_out), .Branch(IE_Branch_out), .sign_ext(IE_sign_ext_out), .read1data(forward_A_data), 
		    .read2data(forward_B_data), .Instr(IE_Instr_out), .instrType(IE_instrType_out), 
		    .ALU_res(IE_ALU_res_in), .BranchTaken(BranchTaken));


	memory memory0(.ALU_res(M_ALU_res_out), .memWrite(M_memWrite_out), .read2data(M_read2data_out), 
						.clk(clk), .rst(rst), .memtoRegMux(M_memToRegMux_in), .mem_stall(mem_stall), .memRead(M_memRead_out),
						.IF_pc_2_w_in(IF_pc_2_w_in));

   writeback writeback0(.memToReg(WB_memToReg_out), .ALU_res(WB_ALU_res_out), .noOp(WB_noOp_out), .jmp(WB_jmp_out), 
			.pc_2_w(WB_pc_2_w_out), .memToRegMux(WB_memToRegMux_out), .memOut(memOut));
   
endmodule // proc
