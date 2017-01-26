module alu_control(Instr, instr_type, alu_op);

	input [15:0] Instr;
	input [1:0] instr_type;
	output reg [3:0] alu_op;
	
	always @ (*) begin
	
		alu_op = 4'b0000;
		
		casex({instr_type, Instr[15:11], Instr[1:0]})
			
			//J-format
			9'b00_xxxxx_xx: alu_op = 4'b0000;
			
			//I1-format
			//ADD			
			9'b01_01000_xx: alu_op = 4'b0000;

			//ST
			9'b01_10000_xx: alu_op = 4'b0000;

			//LD
			9'b01_10001_xx: alu_op = 4'b0000;

			//STU
			9'b01_10011_xx: alu_op = 4'b0000;

			// SUB
			9'b01_01001_xx: alu_op = 4'b0001;

			//XOR
			9'b01_01010_xx: alu_op = 4'b0010;

			// ANDN
			9'b01_01011_xx: alu_op = 4'b0011;

			// ROL
			9'b01_10100_xx: alu_op = 4'b0111;

			// SLL
			9'b01_10101_xx: alu_op = 4'b0100;
			
			// ROR
			9'b01_10110_xx: alu_op = 4'b0101;

			// SRL
			9'b01_10111_xx: alu_op = 4'b0110;		
			


			//I2-format
			// BEQZ
			9'b10_01100_xx: alu_op = 4'b1000;
	
			// BNEZ
			9'b10_01101_xx: alu_op = 4'b1001;

			// BLTZ
			9'b10_01110_xx: alu_op = 4'b1010; 

			// BGEZ
			9'b10_01111_xx: alu_op = 4'b1011;

			// JR
			9'b10_00101_xx: alu_op = 4'b0000;

			// JALR
			9'b10_00111_XX: alu_op = 4'b0000;
			
			//NO LBI, SLBI, BTR because they do not use the ALU


			
			//R-format
			// ADD
			9'b11_11011_00: alu_op = 4'b0000;

			// SUB
			9'b11_11011_01: alu_op = 4'b0001;

			// XOR
			9'b11_11011_10: alu_op = 4'b0010;

			// ANDN
			9'b11_11011_11: alu_op = 4'b0011;

			// ROL
			9'b11_11010_00: alu_op = 4'b0111;

			// SLL
			9'b11_11010_01: alu_op = 4'b0100;

			// ROR
			9'b11_11010_10: alu_op = 4'b0101;

			// SRL
			9'b11_11010_11: alu_op = 4'b0110;

			// SEQ
			9'b11_11100_xx: alu_op = 4'b1101;

			// SLT
			9'b11_11101_xx: alu_op = 4'b1110;

			// SLE
			9'b11_11110_xx: alu_op = 4'b1111;

			// SCO
			9'b11_11111_xx: alu_op = 4'b1100;
			
		endcase
	
	end
	
endmodule
