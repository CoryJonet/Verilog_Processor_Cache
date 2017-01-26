module shift_rotate_8(Out, In, Op, Cnt);

	input [15:0] In;
	input [3:0] Cnt;
	input [1:0] Op;
	
	output[15:0] Out;
	
	wire[15:0] op_res;
	
	assign op_res = Op[0] ? 
			//rotate left
			(Op[1] ? {In[7:0], In[15:8]} 
			///rotate right
			: {In[7:0], In[15:8]}) : 
			//shift right logical
			(Op[1] ? {{8{1'b0}}, In[15:8]} : 
			//shift left
			{In[7:0], {8{1'b0}}});
	
	assign Out = Cnt[3] ? op_res : In;

endmodule

