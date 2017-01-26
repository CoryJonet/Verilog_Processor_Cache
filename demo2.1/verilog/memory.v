module memory(ALU_res, memWrite, read2data, clk, rst, memtoRegMux);

	input clk, rst, memWrite;
	input [15:0] ALU_res, read2data;

	output [15:0] memtoRegMux;
		
	wire err;

	memory2c_align dataMem(.data_out(memtoRegMux), .data_in(read2data), .addr(ALU_res), 
			.enable(1'b1), .wr(memWrite), .createdump(1'b1), .clk(clk), .rst(rst), .err(err));

endmodule
