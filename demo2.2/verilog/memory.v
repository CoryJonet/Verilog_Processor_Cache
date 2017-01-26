module memory(ALU_res, memWrite, read2data, clk, rst, memtoRegMux, mem_stall, memRead);

	input clk, rst, memWrite, memRead;
	input [15:0] ALU_res, read2data;

	output [15:0] memtoRegMux;
	output mem_stall;
		
	wire err, Done, CacheHit;

	stallmem dataMem(.DataOut(memtoRegMux), .DataIn(read2data), .Addr(ALU_res), 
			.Wr(memWrite), .createdump(1'b0), .clk(clk), .rst(rst), 
			.Done(Done), .Stall(mem_stall), .CacheHit(CacheHit), .Rd(memRead), .err(err));
			
endmodule
