module shift_rotate_4(Out, In, Op, Cnt);

	input [15:0] In;
	input [3:0] Cnt;
	input [1:0] Op;
	
	output[15:0] Out;
	
	wire[15:0] op_res;
	
	assign op_res = Op[0] ? 
			//rotate left
			(Op[1] ? {In[11:0], In[15:12]} 
			///rotate right
			: {In[3:0], In[15:4]}) : 
			//shift right logical
			(Op[1] ? {{4{1'b0}}, In[15:4]} : 
			//shift left
			{In[11:0], {4{1'b0}}});
	
	assign Out = Cnt[2] ? op_res : In;

endmodule

