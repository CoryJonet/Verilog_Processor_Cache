module non_alu(read_data, instr, non_alu_res, ALU_res_ctrl);

	input [15:0] read_data;
	input [15:0] instr;
	output reg [15:0] non_alu_res;
	output ALU_res_ctrl;

	assign ALU_res_ctrl = (instr[15:11] == 5'b11001) || (instr[15:11] == 5'b11000) || (instr[15:11] == 5'b10010);
	
	always @ (*) begin
	
		non_alu_res = 16'h0000;
	
		casex(instr[15:11])
			
			// BTR
			5'b11001: begin
				non_alu_res = {read_data[0], read_data[1], read_data[2], read_data[3], 
						read_data[4], read_data[5], read_data[6], read_data[7], 
						read_data[8], read_data[9], read_data[10], read_data[11], 
						read_data[12], read_data[13], read_data[14], read_data[15]}	;
			end
			
			//LBI
			5'b11000: begin
				non_alu_res = {{8{instr[7]}}, instr[7:0]};
			end
			
			//SLBI
			5'b10010: begin
				non_alu_res = {read_data[7:0], {8{1'b0}}} | {{8{1'b0}}, instr[7:0]};
			end
			
		endcase
	end
	
endmodule 
