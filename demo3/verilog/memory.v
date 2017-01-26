module memory(ALU_res, memWrite, read2data, clk, rst, memtoRegMux, mem_stall, memRead, IF_pc_2_w_in);

	input clk, rst, memWrite, memRead;
	input [15:0] ALU_res, read2data, IF_pc_2_w_in;

	output [15:0] memtoRegMux;
	output mem_stall;
	
	wire [15:0] memRdRes, saveMem_in, IF_pc_2_w_old;
	wire err, Done, CacheHit, Rd, Wr;
	
	assign saveMem_in = Done ? memRdRes : memtoRegMux;
	
	assign Wr = Done ? 1'b0 : 
						(IF_pc_2_w_in != IF_pc_2_w_old) ? memWrite :
							1'b0;
							
	assign Rd = Done ? 1'b0 : 
						(IF_pc_2_w_in != IF_pc_2_w_old) ? memRead :
							1'b0;
	
	dff saveMemRes[15:0](.d(saveMem_in), .q(memtoRegMux), .clk(clk), .rst(rst));
	dff PC_change[15:0](.d(IF_pc_2_w_in), .q(IF_pc_2_w_old), .clk(clk), .rst(rst));

	mem_system dataMem(.DataOut(memRdRes), .DataIn(read2data), .Addr(ALU_res), 
			.Wr(Wr), .createdump(1'b0), .clk(clk), .rst(rst), 
			.Done(Done), .Stall(mem_stall), .CacheHit(CacheHit), .Rd(Rd), .err(err));
			
			
endmodule
