module forwarding (IE_Instr_out, IE_read1data_out, IE_read2data_out,
			M_regWrite_out, M_writereg_out, M_ALU_res_out,
			WB_regWrite_out, WB_writereg_out, memOut,
			forward_A_data, forward_B_data, memtoRegMux, M_memRead_out);

	// Forwarding: EX/MEM
	input M_regWrite_out, M_memRead_out;
	
	input [2:0] M_writereg_out;

	input [15:0] IE_Instr_out, M_ALU_res_out, memtoRegMux;

	wire [1:0] forward_A;

        // Forwarind: MEM/WB
	input WB_regWrite_out;

	input [2:0] WB_writereg_out;
	
	input [15:0] memOut;

	wire [1:0] forward_B;

	wire [15:0] forward_A_in, forward_B_in; 
	//No forwarding
	input [15:0] IE_read1data_out, IE_read2data_out;

	//outputs to EX stage
	output reg [15:0] forward_A_data, forward_B_data;

	//2'b10 for EX/MEM hazard, 2'b01 for MEM/WB hazard
	assign forward_A = M_regWrite_out && (M_writereg_out == IE_Instr_out[10:8]) ? 2'b10
			   : (WB_regWrite_out && !(M_regWrite_out && (M_writereg_out == IE_Instr_out[10:8])) && (WB_writereg_out == IE_Instr_out[10:8])) ? 2'b01 : 2'b00;
			   //M_regWrite_out && ((M_writereg_out != 3'b000) && (M_writereg_out == IE_Instr_out[10:8])) ? 2'b10 
			   //: (WB_regWrite_out && (WB_writereg_out != 3'b000) && !(M_regWrite_out && (M_writereg_out != 3'b000) && (M_writereg_out == IE_Instr_out[10:8])) && (WB_writereg_out == IE_Instr_out[10:8])) ? 2'b01 : 2'b00; 			   
			//: WB_regWrite_out && ((WB_writereg_out != 3'b000) && (M_writereg_out != IE_Instr_out[10:8]) && (WB_writereg_out == IE_Instr_out[10:8])) ? 2'b01 : 2'b00; 

	assign forward_B = M_regWrite_out && (M_writereg_out == IE_Instr_out[7:5]) ? 2'b10 
			   : (WB_regWrite_out && !(M_regWrite_out && (M_writereg_out == IE_Instr_out[7:5])) && (WB_writereg_out == IE_Instr_out[7:5])) ? 2'b01 : 2'b00;
			   //: WB_regWrite_out && ((WB_writereg_out != 3'b000) && (M_writereg_out != IE_Instr_out[7:5]) && (WB_writereg_out == IE_Instr_out[7:5])) ? 2'b01 : 2'b00; 
			   //: (WB_regWrite_out && (WB_writereg_out != 3'b000) && !(M_regWrite_out && (M_writereg_out != 3'b000) && (M_writereg_out == IE_Instr_out[7:5])) && (WB_writereg_out == IE_Instr_out[7:5])) ? 2'b01 : 2'b00;

	assign forward_A_in = M_memRead_out ? memtoRegMux : M_ALU_res_out;
	assign forward_B_in = M_memRead_out ? memtoRegMux : M_ALU_res_out;
	
	always @ (*) begin
		casex(forward_A)
			2'b10: forward_A_data = forward_A_in;//M_ALU_res_out;		
			2'b01: forward_A_data = memOut;
			default: forward_A_data = IE_read1data_out;
		endcase	
	end

	always @ (*) begin
		casex(forward_B)
			2'b10: forward_B_data = forward_B_in;//M_ALU_res_out;		
			2'b01: forward_B_data = memOut;
			default: forward_B_data = IE_read2data_out;
		endcase	
	end

endmodule
