module decode(Instr, memOut, clk, rst, regWrite_in, WBwriteReg, sign_ext, read1data, read2data, 
		jumpType, jmp, Branch, memWrite, memRead, memToReg, ALUSrc, noOp, instrType, regWrite_out, writereg);

	input [15:0] Instr, memOut;
	input [2:0] WBwriteReg;
	input clk, rst, regWrite_in;

	output jumpType, jmp, Branch, memWrite, memRead, memToReg, ALUSrc, noOp, regWrite_out;
	output [1:0] instrType;
	output [2:0] writereg;
	output [15:0] sign_ext, read1data, read2data;

	wire [2:0] read2regsel, read1regsel;
	wire RegDst, isSTU;

	//assign halt = (Instr[15:11] == 5'b0_0000) && !rst;
	assign read1regsel = Instr[10:8];
	assign read2regsel = Instr[7:5];

  	rf_bypass reg_file(.read1data(read1data), .read2data(read2data), 
			.read2regsel(read2regsel),.read1regsel(read1regsel), .writeregsel(WBwriteReg), 
			.writedata(memOut), .write(regWrite_in), .clk(clk), .rst(rst) , .err(reg_err));

	control superHugeCaseStament(.Instr(Instr), .jumpType(jumpType), .regWrite(regWrite_out), 
					.RegDst(RegDst), .isSTU(isSTU), .jmp(jmp), 
					.Branch(Branch), .memWrite(memWrite), 
					.memRead(memRead), .memToReg(memToReg), .ALUSrc(ALUSrc), 
					.instrType(instrType), .noOp(noOp));
	
	sign_extend sign_extend0( .Instr(Instr), .instr5(Instr[4:0]), .instr8(Instr[7:0]), .instr_type(instrType), .out(sign_ext));

	computewritereg computeregwrite0(.Instr(Instr), .RegDst(RegDst), .isSTU(isSTU), .jmp(jmp), .writereg(writereg));

endmodule

