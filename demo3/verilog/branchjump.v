module branchjump(Instr, dest, alu_out, jump_type, sign_ext, taken, jump, pc_in, pc_2_w, IE_pc_2_w_out);

	input [15:0] Instr, alu_out, sign_ext, IE_pc_2_w_out;
	input [10:0] dest;
	input jump_type, taken, jump;
	output [15:0] pc_in, pc_2_w;
	
	wire [15:0] pc_2_dest_w;
	wire [15:0] jump_addr, branch_addr, branch_res;
	wire cout1, cout2, cout3, ofl1, ofl2, ofl3;
	
	cla16 pc_2_jmp(.a(Instr), .b(16'h0002), .cin(1'b0), .cout(cout1), .ofl(ofl1), .sign(1'b0), .sum(pc_2_w));
	cla16 pc_2_dest_jmp(.a(IE_pc_2_w_out), .b({{5{dest[10]}},dest[10:0]}), .cin(1'b0), .cout(cout2), .ofl(ofl2), .sign(1'b0), .sum(pc_2_dest_w));
	
	assign jump_addr = jump_type ? pc_2_dest_w : alu_out;
	
	cla16 pc_2_branch(.a(IE_pc_2_w_out), .b(sign_ext), .cin(1'b0), .cout(cout3), .ofl(ofl3), .sign(1'b0), .sum(branch_addr));
	
	assign branch_res = taken ? branch_addr : pc_2_w;
	
	assign pc_in = jump ? jump_addr : branch_res;
	
	
endmodule
