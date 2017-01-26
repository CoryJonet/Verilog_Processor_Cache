module control(Instr, jumpType, regWrite, RegDst, isSTU, jmp, Branch, memWrite, memRead, memToReg, ALUSrc, instrType, noOp);

	input [15:0] Instr;
	output reg jumpType, regWrite, RegDst, isSTU, jmp, Branch, memWrite, memRead, memToReg, ALUSrc, noOp;
	output reg [1:0] instrType;
	
	always @(*) begin
			
		//LBI = 1'b0;
		jumpType = 1'b0;
		regWrite = 1'b0;
		RegDst = 1'b0;
		isSTU = 1'b0;
		jmp = 1'b0;
		Branch = 1'b0;
		memWrite = 1'b0;
		memRead = 1'b0;
		memToReg = 1'b0;
		ALUSrc = 1'b0;
		noOp = 1'b0;
		//SLBI = 1'b0;
		instrType = 2'b00;
			
		casex({Instr[15:11], Instr[1:0]})
			// BEGIN I-FORMAT 1: encoding 2'b01
			// ADDI
			7'b0_1000_xx: begin
			
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;					
			end
			
			//SUBI
			7'b0_1001_xx: begin
			
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;

			end
			
			//XORI
			7'b0_1010_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//ANDNI
			7'b0_1011_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end	

			//ROLI
			7'b1_0100_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end	

			//SLLI
			7'b1_0101_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end	

			//RORI
			7'b1_0110_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//SRLI
			7'b1_0111_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//ST
			7'b1_0000_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b1;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//LD
			7'b1_0001_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b1;
				memToReg = 1'b1;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//STU
			7'b1_0011_xx: begin
				instrType = 2'b01;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b1;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b1;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end
	
			
			//BEGIN R FORMAT: 2'b11
			//ADD
			7'b1_1011_00: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;	
			end

			//SUB
			7'b1_1011_01: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//XOR
			7'b1_1011_10: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//ANDN
			7'b1_1011_11: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

	


			//BEGIN R FORMAT: 2'b11
			//ROL
			7'b1_1010_00: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end
			
			//SLL
			7'b1_1010_01: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//ROR
			7'b1_1010_10: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//SRL
			7'b1_1010_11: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end
		
			//SEQ
			7'b1_1100_xx: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//SLT
			7'b1_1101_xx: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//SLE
			7'b1_1110_xx: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//SCO
			7'b1_1111_xx: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//BTR
			7'b1_1001_xx: begin
				instrType = 2'b11;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//BEGIN I-2 FORMAT: encoding 2'b10

			//LBI
			7'b1_1000_xx: begin
		
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b1;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//SLBI
			7'b1_0010_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b1;
				isSTU = 1'b1;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//BEQZ
			7'b0_1100_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b1;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//BNEZ
			7'b0_1101_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b1;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end	
			
			//BLTZ
			7'b0_1110_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b1;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end
		
			//BGEZ
			7'b0_1111_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b1;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//JALR
			7'b0_0111_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b1;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
				
			end

			//JR
			7'b0_0101_xx: begin
				instrType = 2'b10;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b1;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b1;
				noOp = 1'b0;
				//SLBI = 1'b0;
				
			end

			//BEGIN J-FORMAT: encoding 2'b00
			
			//J
			7'b0_0100_xx: begin
				instrType = 2'b00;
				//LBI = 1'b0;
				jumpType = 1'b1;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b1;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//JAL
			7'b0_0110_xx: begin
				instrType = 2'b00;
				//LBI = 1'b0;
				jumpType = 1'b1;
				regWrite = 1'b1;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b1;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

			//NOP
			7'b0_0001_xx: begin
				instrType = 2'b00;
				//LBI = 1'b0;
				jumpType = 1'b0;
				regWrite = 1'b0;
				RegDst = 1'b0;
				isSTU = 1'b0;
				jmp = 1'b0;
				Branch = 1'b0;
				memWrite = 1'b0;
				memRead = 1'b0;
				memToReg = 1'b0;
				ALUSrc = 1'b0;
				noOp = 1'b0;
				//SLBI = 1'b0;
			end

		endcase
		
	end

	
endmodule
