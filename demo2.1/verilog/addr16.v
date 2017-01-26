module addr16(A, B, Sub, Ofl, Sign, Out, Cout);

	input [15:0] A, B;
	input Sub, Sign;
	
	output [15:0] Out;
	output Ofl, Cout;
	
	wire [15:0] b_sub;
	
	//assign Sign = 1'b1;	
	assign b_sub = Sub ? ~B : B;
	
	cla16 adder(.a(A), .b(b_sub), .cin(Sub), .sum(Out), .cout(Cout), 
		    .ofl(Ofl), .sign(Sign));
		    
endmodule
