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
	//PC
	wire[15:0] PCin;

	//INSTRUCTION MEMORY
	wire [15:0] Instr, PC_val;

	//REGISTER FILE
	wire [2:0] read1regsel, read2regsel, writeregsel;
	wire [15:0] read1data, read2data;//, memOut_1;

	wire [2:0] regDstMux, isStuMux, jmpMux;
	wire reg_err;

	//ALU
	wire [15:0] ALU_res, ALU_out, non_ALU_res;
	wire [3:0] alu_op;
	wire [15:0] alu_b;
	wire Ofl, Eqz, Nez, Ltz, Gez, ALU_res_ctrl;

	//SIGN_EXTEND
	wire [15:0] sign_ext;

	//CONTROL
	wire jumpType, regWrite, RegDst, isSTU, jmp, Branch, memWrite, memRead, memToReg, ALUSrc, noOp, alu_cout;
	wire [1:0] instrType;

	//BRANCH CONTROL
	wire BranchTaken;
	wire[15:0] pc_2_w;

	//DATA MEMORY
	wire [15:0] memOut, memtoRegMux;

	//HALT
	wire halt;
	

	
//***************************** START PC ***************************************
	branchjump branch_datapath(.Instr(PC_val), .dest(Instr[10:0]), 
			.alu_out(ALU_res), .jump_type(jumpType), .sign_ext(sign_ext), 
			.taken(BranchTaken), .jump(jmp), .pc_in(PCin), .pc_2_w(pc_2_w));

	dff PC[15:0](.q(PC_val), .d(PCin), .clk(clk), .rst(rst));
//***************************** END PC ***************************************
 



//***************************** START CONTROL ***************************************

   control superHugeCaseStament(.Instr(Instr), .jumpType(jumpType), .regWrite(regWrite), 
					.RegDst(RegDst), .isSTU(isSTU), .jmp(jmp), 
					.Branch(Branch), .memWrite(memWrite), 
					.memRead(memRead), .memToReg(memToReg), .ALUSrc(ALUSrc), 
					.instrType(instrType), .noOp(noOp));

//***************************** END CONTROL ***************************************



//***************************** START BRANCH CONTROL ***************************************
	branch_control branch_control0(.eqz(Eqz), .neqz(Nez), .ltz(Ltz), .gez(Gez), .taken(BranchTaken), .instr(Instr[15:11]));
//***************************** END BRANCH CONTROL ***************************************



//***************************** START INSTRUCTION MEMORY ***************************************

   memory2c instrMem(.data_out(Instr), .data_in(16'h0000), .addr(PC_val), 
			.enable(1'b1), .wr(1'b0), .createdump(1'b1), .clk(clk), .rst(rst));

//***************************** END INSTRUCTION MEMORY ***************************************


	assign halt = (Instr[15:11] == 5'b0_0000);


//***************************** START REGISTER FILE ***************************************
	assign read1regsel = Instr[10:8];
	assign read2regsel = Instr[7:5];


	assign writeregsel = jmp ? (3'b111) :
				(isSTU ? Instr[10:8] :
				(RegDst ? Instr[4:2] : Instr[7:5])); 

	//dff mem_out_flop[15:0] (.q(memOut), .d(memOut_1), .clk(clk), .rst(rst));

   rf reg_file(.read1data(read1data), .read2data(read2data), 
			.read2regsel(read2regsel),.read1regsel(read1regsel), .writeregsel(writeregsel), 
			.writedata(memOut), .write(regWrite), .clk(clk), .rst(rst) , .err(reg_err));

//***************************** END REGISTER FILE ***************************************


//***************************** START SIGN EXTEND ***************************************
	sign_extend sign_extend0( .Instr(Instr), .instr5(Instr[4:0]), .instr8(Instr[7:0]), .instr_type(instrType), .out(sign_ext));
//***************************** END SIGN EXTEND ***************************************


//***************************** START ALU ***************************************

	assign alu_b = Branch ? (16'h0000) :
			(ALUSrc ? sign_ext : read2data);

   	alu_control alu_ctrl(.Instr(Instr), .instr_type(instrType), .alu_op(alu_op));

	alu alu0(.A(read1data), .B(alu_b), .Cout(alu_cout), .Op(alu_op), 
			.Out(ALU_out), .Ofl(Ofl), .Eqz(Eqz), .Nez(Nez), .Ltz(Ltz), .Gez(Gez));

	non_alu non_alu0(.read_data(read1data), .instr(Instr), .non_alu_res(non_ALU_res), .ALU_res_ctrl(ALU_res_ctrl));

	assign ALU_res = ALU_res_ctrl ? non_ALU_res : ALU_out;

//***************************** END ALU ***************************************



//***************************** START DATA MEMORY ***************************************
	assign memOut = jmp ? pc_2_w :
				(noOp ? 16'h0000 : (
				memToReg ? memtoRegMux : ALU_res));
		
	memory2c dataMem(.data_out(memtoRegMux), .data_in(read2data), .addr(ALU_res), 
			.enable(1'b1), .wr(memWrite), .createdump(1'b1), .clk(clk), .rst(rst));

//***************************** END DATA MEMORY ***************************************


endmodule // proc
