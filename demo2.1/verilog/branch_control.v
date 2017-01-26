module branch_control(eqz, neqz, ltz, gez, taken, instr);

	input [4:0] instr;
	input eqz, neqz, ltz, gez;
	output reg taken;

	always @ (*) begin
		taken = 0;
		casex(instr)
			//BEQZ
			5'b01100: begin
				taken = eqz;
			end

			//BNEZ
			5'b01101: begin
				taken = neqz;
			end
			
			//BLTZ
			5'b01110: begin
				taken = ltz;
			end

			//BGEZ
			5'b01111: begin
				taken = gez;
			end
			
			default: begin
				taken = 0;
			end
			
		endcase
	end

endmodule

