module shift_rotate(In, Cnt, Op, Out);

	input [15:0] In;
	input [3:0]  Cnt;
	input [1:0]  Op;
	output [15:0] Out;
	
	wire [15:0] s0_s2, s2_s4, s4_s8;
	
	shift_rotate_0 s0(.Out(s0_s2), .In(In), .Op(Op), .Cnt(Cnt));
	shift_rotate_2 s2(.Out(s2_s4), .In(s0_s2), .Op(Op), .Cnt(Cnt));
	shift_rotate_4 s4(.Out(s4_s8), .In(s2_s4), .Op(Op), .Cnt(Cnt));
	shift_rotate_8 s8(.Out(Out), .In(s4_s8), .Op(Op), .Cnt(Cnt));
	
	
endmodule