module stall(ID_Instr_out, IE_Instr_out, IE_memRead_out, 
		rst, clk, stall, 
		PC_stall, PC_val, PC_next, 
		IF_Instr_in, Instr_stall, 
		IF_pc_2_w_in, ID_pc_2_w_out, pc_2_w_stall,
		IF_halt_in, ID_halt_out, halt_stall, 
		ID_Branch_in, ID_ALUsrc_in, ID_memWrite_in, ID_memRead_in, ID_memToReg_in,
	        ID_noOp_in, ID_jmp_in, ID_jumpType_in, ID_regWrite_in, ID_halt_in,
                ID_instrType_in, ID_Instr_in,
		ID_writereg_in, ID_read2data_in, ID_read1data_in, ID_pc_2_w_in, ID_sign_ext_in,
		Branch_bubble, ALUsrc_bubble, memWrite_bubble, memRead_bubble, memToReg_bubble, 
	        noOp_bubble, jmp_bubble, jumpType_bubble, regWrite_bubble, halt_bubble,
		instrType_bubble, Instr_bubble, writereg_bubble, read2data_bubble, read1data_bubble, 
		sign_ext_bubble, pc_2_w_bubble);

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

        assign stall = IE_memRead_out && ((IE_Instr_out[7:5] == ID_Instr_out[10:8]) || (IE_Instr_out[7:5] == ID_Instr_out[7:5]));

	assign PC_stall = stall ?  PC_val : PC_next;

	assign Instr_stall = stall ?  ID_Instr_out : IF_Instr_in;

	assign pc_2_w_stall = stall ? ID_pc_2_w_out : IF_pc_2_w_in;

	assign halt_stall = stall ? ID_halt_out : IF_halt_in;

        // Insert a "bubble": Set the control bits in the EX/MEM/WB control fields of the ID/EX pipline register to 0 (nop)

	assign Instr_bubble = stall ? 16'h0000 : ID_Instr_in;

	assign Branch_bubble = stall ? 1'b0 : ID_Branch_in; 

        assign instrType_bubble = stall ? 2'b00 : ID_instrType_in;

        assign ALUsrc_bubble = stall ? 1'b0 : ID_ALUsrc_in;  

        assign memWrite_bubble = stall ? 1'b0 : ID_memWrite_in; 

        assign memRead_bubble = stall ? 1'b0 : ID_memRead_in; 

        assign memToReg_bubble = stall ? 1'b0 : ID_memToReg_in; 

 	assign noOp_bubble = stall ? 1'b0 : ID_noOp_in; 

        assign jmp_bubble = stall ? 1'b0 : ID_jmp_in; 

        assign jumpType_bubble = stall ? 1'b0 : ID_jumpType_in; 

        assign regWrite_bubble = stall ? 1'b0 : ID_regWrite_in; 

        assign halt_bubble = stall ? 1'b0 : ID_halt_in; 

	assign writereg_bubble = stall ? 3'b000: ID_writereg_in;

        assign read2data_bubble = stall ? 16'h0000 : ID_read2data_in;
	
	assign read1data_bubble = stall ? 16'h0000 : ID_read1data_in;

        assign sign_ext_bubble = stall ? 16'h0000 : ID_sign_ext_in;

        assign pc_2_w_bubble = stall ? 16'h0000 : ID_pc_2_w_in;
	

endmodule

