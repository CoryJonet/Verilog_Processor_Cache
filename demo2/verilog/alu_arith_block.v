module alu_arith_block(A, B, isAdd, isCompare, Ofl, Cout, Out, eq, neq, ge, lt);

	input [15:0] A, B;
	input isAdd, isCompare;
	
	output eq, neq, ge, lt;
	output [15:0] Out;
	output Ofl, Cout;
	
	wire [15:0] adder_out;
	
	
	addr16 add_or_sub (.A(A), .B(B), .Sub(~isAdd), .Ofl(Ofl), .Sign(1'b1), .Out(adder_out), .Cout(Cout));
	
	assign eq = isCompare? (adder_out == 0) : eq;
	assign neq = isCompare ? (adder_out != 0) : neq;
	assign ge = isCompare ? ~((adder_out[15] & ~A[15] & ~B[15]) | (adder_out[15] & A[15] & B[15]) | (A[15] & ~B[15])) : ge;
	assign lt = isCompare ? ( (adder_out[15] & ~A[15] & ~B[15]) | (adder_out[15] & A[15] & B[15]) | (A[15] & ~B[15])) : lt;
	
	assign Out = adder_out; 
	

endmodule
