module stall_branch(
			input [15:0] alu_out, sign_ext, IE_pc_2_w_out,
			input [10:0] dest,
			input jump_type, taken, jump, clk, rst, fetch_stall,
			
			output [15:0] alu_out_sb, sign_ext_sb, IE_pc_2_w_out_sb,
			output [10:0] dest_sb,
			output jump_type_sb, taken_sb, jump_sb);
	
	wire [15:0] alu_out_next, sign_ext_next, IE_pc_2_w_out_next;
	wire [10:0] dest_next;
	wire jump_type_next, jump_next, taken_next;
	
	
	wire [15:0] alu_out_hold, sign_ext_hold, IE_pc_2_w_out_hold;
	wire [10:0] dest_hold;
	wire jump_type_hold, jump_hold;
	reg taken_hold;
	
	/*wire [15:0] alu_out_out, sign_ext_out, IE_pc_2_w_out_out;
	wire [10:0] dest_out;
	wire jump_type_out, taken_out, jump_out;*/
	
	wire posedge_inter, posedge_post, posedge_taken;
	
	dff posedge_taken1 (.d(taken), .q(posedge_inter), .clk(clk), .rst(rst));
	dff posedge_taken2 (.d(posedge_inter), .q(posedge_post), .clk(clk), .rst(rst));
	
	assign posedge_taken = (~posedge_post & posedge_inter);
	
	dff alu_out_sb_flop [15:0] (.d(alu_out), .q(alu_out_next), .clk(clk), .rst(rst));
	dff sign_ext_sb_flop [15:0] (.d(sign_ext), .q(sign_ext_next), .clk(clk), .rst(rst));
	dff IE_pc_2_w_out_sb_flop [15:0] (.d(IE_pc_2_w_out), .q(IE_pc_2_w_out_next), .clk(clk), .rst(rst));
	dff dest_sb_flop [10:0] (.d(dest), .q(dest_next), .clk(clk), .rst(rst));
	dff jump_type_sb_flop (.d(jump_type), .q(jump_type_next), .clk(clk), .rst(rst));
	dff taken_sb_flop [0:0](.d(taken), .q(taken_next), .clk(clk), .rst(rst));
	dff jump_sb_flop (.d(jump), .q(jump_next), .clk(clk), .rst(rst));
	
	assign alu_out_hold = rst ? 16'h0000 :
									posedge_taken ? alu_out_next : alu_out_hold;
									 
	assign sign_ext_hold = rst ? 16'h0000 :
										posedge_taken ? sign_ext_next : sign_ext_hold; 
										
	assign IE_pc_2_w_out_hold = rst ? 16'h0000 :
											posedge_taken ? IE_pc_2_w_out_next : IE_pc_2_w_out_hold; 
											
	assign dest_hold = rst ? 11'b0000_0000_000 :
								posedge_taken ? dest_next : dest_hold; 
								
	assign jump_type_hold = rst ? 1'b0 :
										posedge_taken ? jump_type_next : jump_type_hold; 
										
	//assign taken_hold = rst ? 1'b0 :
									//posedge_taken ? taken_next : taken_hold; 
									
	assign jump_hold = rst ? 1'b0 :
								posedge_taken ? jump_next : jump_hold; 
								
	always @ (*) begin
		taken_hold = taken_hold;
		
		casex({rst, posedge_taken})
			2'b1x: taken_hold = 1'b0;
			2'b01: taken_hold = taken_next;
		endcase
		
	end
	
	assign alu_out_sb = fetch_stall ? alu_out_hold : alu_out; 
	assign sign_ext_sb = fetch_stall ? sign_ext_hold : sign_ext; 
	assign IE_pc_2_w_out_sb = fetch_stall ? IE_pc_2_w_out_hold : IE_pc_2_w_out; 
	assign dest_sb = fetch_stall ? dest_hold : dest; 
	assign jump_type_sb = fetch_stall ? jump_type_hold : jump_type; 
	assign taken_sb = fetch_stall ? taken_hold : taken; 
	assign jump_sb = fetch_stall ? jump_hold : jump;

endmodule

