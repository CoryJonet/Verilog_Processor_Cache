module alu(A, B, Op, Out, Ofl, Eqz, Nez, Ltz, Gez);

	input [15:0] A, B;
	input [3:0] Op;
	
	output reg [15:0] Out;
	output Ofl, Eqz, Nez, Ltz, Gez; 
	
	reg isAdd, isCompare, eq, neq, ge, lt;
	wire [15:0] arith_out, shift_out;
	wire Cout;
	reg [15:0] tmp_A, tmp_B;
	
	alu_arith_block arith_block(.A(tmp_A), .B(tmp_B), .isAdd(isAdd), .isCompare(isCompare), .Ofl(Ofl), .Cout(Cout), .Out(arith_out), .eq(Eqz), .neq(Nez), .ge(Gez), .lt(Ltz));
	shift_rotate shifter(.In(A), .Cnt(B[3:0]), .Op(Op[1:0]), .Out(shift_out));
	
	always @ (*) begin
		isAdd = 1'b0;
		isCompare = 1'b0;
		eq = 1'b0;
		neq = 1'b0;
		ge = 1'b0;
		lt = 1'b0;
		Out = 16'hxxxx;
		tmp_A = A;
		tmp_B = B;
		
		casex(Op)
			// ADD
			4'b0000: begin
			
				isAdd = 1'b1;
				Out = arith_out;
			
			end
			
			// SUB
			4'b0001: begin
			
				isAdd = 1'b0;
				Out = arith_out;
				tmp_A = B;
				tmp_B = A;
			
			end
			
			//XOR
			4'b0010: begin
			
				isAdd = 1'b0;
				Out = A^B;
			
			end
			
			//ANDN
			4'b0011: begin
			
				isAdd = 1'b0;
				Out = A & ~B;
			
			end
			
			//SLL
			4'b0100: begin
				Out = shift_out;
			end
			
			//ROR
			4'b0101: begin
				Out = shift_out;			
			end
			
			//SRL
			4'b0110: begin
				Out = shift_out;
			end
			
			//ROL
			4'b0111: begin
				Out = shift_out;
			end
			
			//BEQZ		
			4'b1000: begin
				isAdd = 1'b0;
				isCompare = 1'b1; 
			end
			
			//BNEZ
			4'b1001: begin
				isAdd = 1'b0;
				isCompare = 1'b1;
			end
			
			//BLTZ
			4'b1010: begin
				isAdd = 1'b0;
				isCompare = 1'b1;
			end
			
			//BGEZ
			4'b1011: begin
				isAdd = 1'b0;
				isCompare = 1'b1;
			end
			
			//SCO
			4'b1100: begin
				isAdd = 1'b1;
				Out = {{15{1'b0}}, Cout};
			
			end
			
			//SEQ
			4'b1101: begin
				isAdd = 1'b0;
				isCompare = 1'b1;
				
				Out = {{15{1'b0}}, Eqz};
			end
			
			//SLT
			4'b1110: begin
				isAdd = 1'b0;
				isCompare = 1'b1;
				
				Out = {{15{1'b0}}, Ltz};			
			end
			
			//SLE
			4'b1111: begin
				isAdd = 1'b0;
				isCompare = 1'b1;
				
				Out = {{15{1'b0}}, (Eqz | Ltz)};
			end
		endcase
	end
	
endmodule
