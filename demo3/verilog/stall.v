module stall(
		ID_Instr_out, IE_Instr_out, 
		IE_memRead_out, 
		rst, clk, stall,

		//fetch
		PC_stall, PC_val, PC_next, 
		IF_Instr_in, Instr_stall, 
		IF_pc_2_w_in, ID_pc_2_w_out, pc_2_w_stall,
		IF_halt_in, ID_halt_out, halt_stall, 

		//inputs from stalling memories
		fetch_stall, mem_stall,

		// Decode stage			
		ID_IE_Instr_stall,
		IE_read2data_out, ID_IE_read2data_stall,
		IE_read1data_out, ID_IE_read1data_stall,
		IE_sign_ext_out, ID_IE_sign_ext_stall,
		IE_pc_2_w_out, ID_IE_pc_2_w_stall,
		IE_Branch_out, ID_IE_Branch_stall,
		IE_ALUsrc_out, ID_IE_ALUsrc_stall,
		IE_memWrite_out, ID_IE_memWrite_stall,
	   IE_memToReg_out, ID_IE_memToReg_stall,
		IE_noOp_out, ID_IE_noOp_stall,
		IE_jmp_out, ID_IE_jmp_stall,
		ID_IE_memRead_stall,
		IE_jumpType_out, ID_IE_jumpType_stall,
		IE_regWrite_out, ID_IE_regWrite_stall,
		IE_halt_out, ID_IE_halt_stall,
		IE_writereg_out, ID_IE_writereg_stall,
	   IE_instrType_out, ID_IE_instrType_stall,

		// Execute stage
		IE_ALU_res_in, M_ALU_res_out, IE_M_ALU_res_stall,
		IE_read2data_in, M_read2data_out, IE_M_read2data_stall, 
		IE_pc_2_w_in, M_pc_2_w_out, IE_M_pc_2_w_stall,
		IE_memWrite_in, M_memWrite_out, IE_M_memWrite_stall,
		IE_memToReg_in, M_memToReg_out, IE_M_memToReg_stall, 
		IE_noOp_in, M_noOp_out, IE_M_noOp_stall,
     	IE_jmp_in, M_jmp_out, IE_M_jmp_stall,
		IE_memRead_in, M_memRead_out, IE_M_memRead_stall, 
		IE_regWrite_in, M_regWrite_out, IE_M_regWrite_stall,
		IE_halt_in, M_halt_out, IE_M_halt_stall,
		IE_writereg_in, M_writereg_out, IE_M_writereg_stall,

		// Memory
		M_ALU_res_in, WB_ALU_res_out, M_WB_ALU_res_stall, 
		M_pc_2_w_in, WB_pc_2_w_out, M_WB_pc_2_w_stall, 
		M_memToRegMux_in, WB_memToRegMux_out, M_WB_memToRegMux_stall,
		M_memToReg_in, WB_memToReg_out, M_WB_memToReg_stall, 
		M_noOp_in, WB_noOp_out, M_WB_noOp_stall, 
		M_jmp_in, WB_jmp_out, M_WB_jmp_stall,
		M_regWrite_in, WB_regWrite_out, M_WB_regWrite_stall,
		M_halt_in, WB_halt_out, M_WB_halt_stall,
		M_writereg_in, WB_writereg_out, M_WB_writereg_stall,

		//bubbles
		ID_Branch_in, Branch_bubble,
		ID_ALUsrc_in, ALUsrc_bubble,
		ID_memWrite_in, memWrite_bubble,
		ID_memRead_in, memRead_bubble,
		ID_memToReg_in, memToReg_bubble,
		ID_noOp_in, noOp_bubble,
		ID_jmp_in, jmp_bubble,
		ID_jumpType_in, jumpType_bubble,
		ID_regWrite_in, regWrite_bubble,
		ID_halt_in, halt_bubble,
      ID_instrType_in, instrType_bubble,
		ID_Instr_in, Instr_bubble,
		ID_writereg_in, writereg_bubble,
		ID_read2data_in, read2data_bubble,
		ID_read1data_in, read1data_bubble,
		ID_pc_2_w_in, pc_2_w_bubble,
		ID_sign_ext_in, sign_ext_bubble);

	input rst, clk;

	// Input: Load word stall hazard
	input IE_memRead_out, IF_halt_in, ID_halt_out;

	// Input: Load word stall hazard
	input [15:0] IE_Instr_out, ID_Instr_out;

	// Input: Stall PC val for word stall hazard
	input [15:0] PC_val, PC_next;
	
	// Input: Stall Instr, pc_2_w, halt for word stall hazard
	input [15:0] IF_Instr_in, IF_pc_2_w_in, ID_pc_2_w_out;

	output stall, halt_stall;

	// Output: Stalled Instr, pc_2_w, halt for word stall hazard
	output [15:0] PC_stall, Instr_stall, pc_2_w_stall;
	
	//inputs from stalling memory
	input fetch_stall, mem_stall;

	//input decode
	input [15:0] IE_read2data_out, IE_read1data_out, IE_sign_ext_out, IE_pc_2_w_out;

	input IE_Branch_out, IE_ALUsrc_out, IE_memWrite_out, IE_memToReg_out, IE_noOp_out, IE_jmp_out,
			IE_jumpType_out, IE_regWrite_out, IE_halt_out;

	input [2:0] IE_writereg_out;
			
	input [1:0] IE_instrType_out;

	//output decode
	output [15:0] ID_IE_Instr_stall, ID_IE_read2data_stall, ID_IE_read1data_stall, ID_IE_sign_ext_stall, 
						ID_IE_pc_2_w_stall;

	output ID_IE_Branch_stall, ID_IE_ALUsrc_stall, ID_IE_memWrite_stall, ID_IE_memToReg_stall, ID_IE_noOp_stall, 
			 ID_IE_jmp_stall, ID_IE_memRead_stall, ID_IE_jumpType_stall, ID_IE_regWrite_stall, ID_IE_halt_stall;

	output [2:0] ID_IE_writereg_stall;

	output [1:0] ID_IE_instrType_stall;

	//input execute
	input [15:0] IE_ALU_res_in, M_ALU_res_out, IE_read2data_in, M_read2data_out, IE_pc_2_w_in, M_pc_2_w_out;

	input IE_memWrite_in, M_memWrite_out, IE_memToReg_in, M_memToReg_out, IE_noOp_in, M_noOp_out, IE_jmp_in, M_jmp_out, 
			IE_memRead_in, M_memRead_out, IE_regWrite_in, M_regWrite_out, IE_halt_in, M_halt_out;
	
	input [2:0] IE_writereg_in, M_writereg_out;

	//output execute
	output [15:0] IE_M_ALU_res_stall, IE_M_read2data_stall, IE_M_pc_2_w_stall;
	
	output IE_M_memWrite_stall, IE_M_memToReg_stall, IE_M_noOp_stall, IE_M_jmp_stall, IE_M_memRead_stall, 
				IE_M_regWrite_stall, IE_M_halt_stall;
				
	output [2:0] IE_M_writereg_stall;
	
	//input Memory
	input [15:0] M_ALU_res_in, WB_ALU_res_out, M_pc_2_w_in, WB_pc_2_w_out, M_memToRegMux_in, WB_memToRegMux_out;
	
	input M_memToReg_in, WB_memToReg_out, M_noOp_in, WB_noOp_out, M_jmp_in, 
			WB_jmp_out, M_regWrite_in, WB_regWrite_out, M_halt_in, WB_halt_out;
			
	input [2:0] M_writereg_in, WB_writereg_out;
	
	//output memory
	output [15:0] M_WB_memToRegMux_stall, M_WB_ALU_res_stall, M_WB_pc_2_w_stall;
	
	output M_WB_memToReg_stall, M_WB_noOp_stall, M_WB_jmp_stall, M_WB_regWrite_stall, 
			M_WB_halt_stall;
			
	output [2:0] M_WB_writereg_stall;

        // Input: Bubble
	input ID_Branch_in, ID_ALUsrc_in, ID_memWrite_in, ID_memRead_in, ID_memToReg_in,
	      ID_noOp_in, ID_jmp_in, ID_jumpType_in, ID_regWrite_in, ID_halt_in;

	input [1:0] ID_instrType_in;

	input [2:0] ID_writereg_in;

	input [15:0] ID_Instr_in, ID_read2data_in, ID_read1data_in, ID_sign_ext_in, ID_pc_2_w_in;

        // Output: Bubble
	output Branch_bubble, ALUsrc_bubble, memWrite_bubble, memRead_bubble, memToReg_bubble, 
	       noOp_bubble, jmp_bubble, jumpType_bubble, regWrite_bubble, halt_bubble;

	output [1:0] instrType_bubble;
	
	output [2:0] writereg_bubble;

	output [15:0] Instr_bubble, read2data_bubble, read1data_bubble, sign_ext_bubble, pc_2_w_bubble;

	//load use hazard stall
	wire old_fetch_stall, old_mem_stall, ld_st_hazard;
	
	dff negedge_f_stall(.d(fetch_stall), .q(old_fetch_stall), .clk(clk), .rst(rst));
	dff negedge_m_stall(.d(mem_stall), .q(old_mem_stall), .clk(clk), .rst(rst)); 
	
   assign ld_st_hazard = IE_memRead_out && ((IE_Instr_out[7:5] == ID_Instr_out[10:8]) || (IE_Instr_out[7:5] == ID_Instr_out[7:5]));
   
   assign stall = ld_st_hazard && ~old_fetch_stall && ~old_mem_stall;

	assign PC_stall = (stall || fetch_stall || mem_stall) ?  PC_val : PC_next;

	assign Instr_stall = (stall || mem_stall || fetch_stall) ?  ID_Instr_out :
									IF_Instr_in;

	assign pc_2_w_stall = (stall || mem_stall || fetch_stall) ? ID_pc_2_w_out : 
										IF_pc_2_w_in;

	assign halt_stall = (stall || mem_stall || fetch_stall) ? ID_halt_out : 
									IF_halt_in;

	//handle stalls for decode
	assign ID_IE_Instr_stall = (mem_stall || fetch_stall) ? IE_Instr_out : ID_Instr_in;
	
	assign ID_IE_read2data_stall = (mem_stall || fetch_stall) ? IE_read2data_out : ID_read2data_in;
	
	assign ID_IE_read1data_stall = (mem_stall || fetch_stall) ? IE_read1data_out : ID_read1data_in;
	
	assign ID_IE_sign_ext_stall = (mem_stall || fetch_stall) ? IE_sign_ext_out : ID_sign_ext_in;
	
	assign ID_IE_pc_2_w_stall = (mem_stall || fetch_stall) ? IE_pc_2_w_out : ID_pc_2_w_in;
	
	assign ID_IE_Branch_stall = (mem_stall || fetch_stall) ? IE_Branch_out : ID_Branch_in;
	
	assign ID_IE_ALUsrc_stall = (mem_stall || fetch_stall) ? IE_ALUsrc_out : ID_ALUsrc_in;
	
	assign ID_IE_memWrite_stall = (mem_stall || fetch_stall) ? IE_memWrite_out : ID_memWrite_in;
	
	assign ID_IE_memToReg_stall = (mem_stall || fetch_stall) ? IE_memToReg_out : ID_memToReg_in;
	
	assign ID_IE_noOp_stall = (mem_stall || fetch_stall) ? IE_noOp_out : ID_noOp_in;
	
	assign ID_IE_jmp_stall = (mem_stall || fetch_stall) ? IE_jmp_out : ID_jmp_in;
	
	assign ID_IE_memRead_stall = (mem_stall || fetch_stall) ? IE_memRead_out : ID_memRead_in;
	
	assign ID_IE_jumpType_stall = (mem_stall || fetch_stall) ? IE_jumpType_out : ID_jumpType_in;
	
	assign ID_IE_regWrite_stall = (mem_stall || fetch_stall) ? IE_regWrite_out : ID_regWrite_in;
	
	assign ID_IE_halt_stall = (mem_stall || fetch_stall) ? IE_halt_out : ID_halt_in;
	
	assign ID_IE_writereg_stall = (mem_stall || fetch_stall) ? IE_writereg_out : ID_writereg_in;
	
	assign ID_IE_instrType_stall = (mem_stall || fetch_stall) ? IE_instrType_out : ID_instrType_in;
	
	//handle stalls for execute
	assign IE_M_ALU_res_stall = (mem_stall || fetch_stall) ? M_ALU_res_out : IE_ALU_res_in;
	
	assign IE_M_read2data_stall = (mem_stall || fetch_stall) ? M_read2data_out : IE_read2data_in;
	
	assign IE_M_pc_2_w_stall = (mem_stall || fetch_stall) ? M_pc_2_w_out : IE_pc_2_w_in;
	
	assign IE_M_memWrite_stall = (mem_stall || fetch_stall) ? M_memWrite_out : IE_memWrite_in;
	
	assign IE_M_memToReg_stall = (mem_stall || fetch_stall) ? M_memToReg_out : IE_memToReg_in;
	
	assign IE_M_noOp_stall = (mem_stall || fetch_stall) ? M_noOp_out : IE_noOp_in;
	
	assign IE_M_jmp_stall = (mem_stall || fetch_stall) ? M_jmp_out : IE_jmp_in;
	
	assign IE_M_memRead_stall = (mem_stall || fetch_stall) ? M_memRead_out : IE_memRead_in;
	
	assign IE_M_regWrite_stall = (mem_stall || fetch_stall) ? M_regWrite_out : IE_regWrite_in;
	
	assign IE_M_halt_stall = (mem_stall || fetch_stall) ? M_halt_out : IE_halt_in;
	
	assign IE_M_writereg_stall = (mem_stall || fetch_stall) ? M_writereg_out : IE_writereg_in;

	//handle stalls for memory. Insert bubbles when mem is stalling
	assign M_WB_ALU_res_stall = (mem_stall || fetch_stall) ? WB_ALU_res_out : M_ALU_res_in;
	
	assign M_WB_pc_2_w_stall = (mem_stall || fetch_stall) ? WB_pc_2_w_out : M_pc_2_w_in;
	
	assign M_WB_memToRegMux_stall = (mem_stall || fetch_stall) ? WB_memToRegMux_out : M_memToRegMux_in; 
	
	assign M_WB_memToReg_stall = (mem_stall || fetch_stall) ? WB_memToReg_out : M_memToReg_in;
	
	assign M_WB_noOp_stall = (mem_stall || fetch_stall) ? WB_noOp_out : M_noOp_in; 
	
	assign M_WB_jmp_stall = (mem_stall || fetch_stall) ? WB_jmp_out : M_jmp_in;
	
	assign M_WB_regWrite_stall = (mem_stall || fetch_stall) ? WB_regWrite_out : M_regWrite_in; 
	
	assign M_WB_halt_stall = (mem_stall || fetch_stall) ? WB_halt_out : M_halt_in;
	
	assign M_WB_writereg_stall = (mem_stall || fetch_stall) ? WB_writereg_out : M_writereg_in;
	
   // Insert a "bubble": Set the control bits in the EX/MEM/WB control fields of the ID/EX pipline register to 0 (nop) 

	assign Instr_bubble = (mem_stall || fetch_stall) ? IE_Instr_out :
										stall ? 16'h0000 : 
											ID_Instr_in;

	assign Branch_bubble = (mem_stall || fetch_stall)? IE_Branch_out :
										stall ? 1'b0 : 
											ID_Branch_in; 

   assign instrType_bubble = (mem_stall || fetch_stall) ? IE_instrType_out :
   										stall ? 2'b00 : 
   											ID_instrType_in;

   assign ALUsrc_bubble = (mem_stall || fetch_stall) ? IE_ALUsrc_out : 
   									stall ? 1'b0 : 
   										ID_ALUsrc_in;  

   assign memWrite_bubble = (mem_stall || fetch_stall) ? IE_memWrite_out :
   									stall ? 1'b0 : ID_memWrite_in; 

   assign memRead_bubble = (mem_stall || fetch_stall) ? IE_memRead_out : 
   									stall ? 1'b0 : ID_memRead_in; 

   assign memToReg_bubble = (mem_stall || fetch_stall) ? IE_memToReg_out : 
   									stall ? 1'b0 : ID_memToReg_in; 

 	assign noOp_bubble = (mem_stall || fetch_stall) ? IE_noOp_out :
 									stall ? 1'b0 : ID_noOp_in; 

   assign jmp_bubble = (mem_stall || fetch_stall) ? IE_jmp_out :
   							stall ? 1'b0 : ID_jmp_in; 

   assign jumpType_bubble = (mem_stall || fetch_stall) ? IE_jumpType_out : 
   									stall ? 1'b0 : ID_jumpType_in; 

   assign regWrite_bubble = (mem_stall || fetch_stall) ? IE_regWrite_out : 
   									stall ? 1'b0 : ID_regWrite_in; 

   assign halt_bubble = (mem_stall || fetch_stall) ? IE_halt_out :
   								stall ? 1'b0 : ID_halt_in; 

	assign writereg_bubble = (mem_stall || fetch_stall) ? IE_writereg_out :
										stall ? 3'b000: ID_writereg_in;

   assign read2data_bubble = (mem_stall || fetch_stall) ? IE_read2data_out : 
   										stall ? 16'h0000 : ID_read2data_in;
	
	assign read1data_bubble = (mem_stall || fetch_stall) ? IE_read1data_out :
											stall ? 16'h0000 : ID_read1data_in;

   assign sign_ext_bubble = (mem_stall || fetch_stall) ? IE_sign_ext_out : 
   									stall ? 16'h0000 : ID_sign_ext_in;

   assign pc_2_w_bubble = (mem_stall || fetch_stall) ? IE_pc_2_w_out :
   									stall ? 16'h0000 : ID_pc_2_w_in;
	

endmodule

