module execute(ALUSrc, Branch, sign_ext, read1data, read2data, Instr, instrType, ALU_res, BranchTaken);

	input ALUSrc, Branch;
	input [1:0] instrType;
	input [15:0] read1data, read2data, Instr, sign_ext;

	output BranchTaken;
	output [15:0] ALU_res;

	wire Eqz, Nez, Ltz, Gez, ALU_res_ctrl, Ofl;
	wire [3:0] alu_op;
	wire [15:0] ALU_out, non_ALU_res, alu_b;

	assign alu_b = Branch ? (16'h0000) :
			(ALUSrc ? sign_ext : read2data);

   	alu_control alu_ctrl(.Instr(Instr), .instr_type(instrType), .alu_op(alu_op));

	alu alu0(.A(read1data), .B(alu_b), .Op(alu_op), 
			.Out(ALU_out), .Ofl(Ofl), .Eqz(Eqz), .Nez(Nez), .Ltz(Ltz), .Gez(Gez));

	non_alu non_alu0(.read_data(read1data), .instr(Instr), .non_alu_res(non_ALU_res), .ALU_res_ctrl(ALU_res_ctrl));

	assign ALU_res = ALU_res_ctrl ? non_ALU_res : ALU_out;

	branch_control branch_control0(.eqz(Eqz), .neqz(Nez), .ltz(Ltz), .gez(Gez), .taken(BranchTaken), .instr(Instr[15:11]));

endmodule
