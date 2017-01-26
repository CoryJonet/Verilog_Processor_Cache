module shift_rotate_2(Out, In, Op, Cnt);

	input [15:0] In;
	input [3:0] Cnt;
	input [1:0] Op;
	
	output[15:0] Out;
	
	wire[15:0] op_res;
	
	assign op_res = Op[0] ? 
			//rotate left
			(Op[1] ? {In[13:0], In[15:14]} 
			///rotate right
			: {In[1:0], In[15:2]}) : 
			//shift right logical
			(Op[1] ? {{2{1'b0}}, In[15:2]} : 
			//shift left
			{In[13:0], {2{1'b0}}});
	
	assign Out = Cnt[1] ? op_res : In;

endmodule

