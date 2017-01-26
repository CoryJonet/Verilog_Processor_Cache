module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter mem_type = 0;

	localparam IDLE =          5'b00000;
   localparam RD_COMPARE =    5'b00001; 
   localparam RD_DIRTY0 =     5'b00010; 
   localparam RD_DIRTY1 =     5'b00011;
   localparam RD_DIRTY2 =     5'b00100;
   localparam RD_DIRTY3 =     5'b00101;
   localparam RD_MEM0 =       5'b00110;
   localparam RD_MEM1 =       5'b00111;
   localparam RD_MEM2 =       5'b01000;
   localparam RD_MEM3 =       5'b01001;
   localparam RD_MEM =        5'b01010; 
   localparam RD_CLEAR =      5'b01011;
	localparam WR_COMPARE =    5'b01100;
   localparam WR_DIRTY0 =     5'b01101;
   localparam WR_DIRTY1 =     5'b01110;
   localparam WR_DIRTY2 =     5'b01111;
   localparam WR_DIRTY3 =     5'b10000;
   localparam WR_MEM =        5'b10001;
   localparam EVICT_WAIT =    5'b10010;
   localparam WR_CACHE0 =     5'b10011;
   localparam WR_CACHE1 =     5'b10100;
   localparam WR_CACHE2 =     5'b10101;
   localparam WR_CACHE3 =     5'b10110;   
   localparam WR_CLEAR =      5'b10111;

/***************************************************** CACHE **********************************************************/

   reg [15:0] cacheDataIn;
   reg [2:0] cacheOff;
   reg cacheValid_in, cacheEn0, cacheEn1, cacheComp, cacheWr, cacheInRdCompare;

   wire [15:0] cacheDataOut0, cacheDataOut1, cacheDataSel;	
   wire [4:0] tagOut0, tagOut1;
	wire dirty0, valid0, cacheHit0, cacheErr0;
   wire dirty1, valid1, cacheHit1, cacheErr1;

   cache #(0 + mem_type) c0(	//Outputs
										.tag_out			(tagOut0),
										.data_out		(cacheDataOut0),
                 					.hit				(cacheHit0), 
										.dirty			(dirty0), 
										.valid			(valid0), 
										.err				(cacheErr0),
										// Inputs
										.enable			(cacheEn0), 
										.clk				(clk), 
										.rst				(rst), 
										.createdump		(createdump), 
										.tag_in			(Addr[15:11]), 
										.index			(Addr[10:3]), 
										.offset			(cacheOff), 
										.data_in			(cacheDataIn),
										.comp				(cacheComp), 
										.write			(cacheWr), 
										.valid_in		(cacheValid_in));

   cache #(2 + mem_type) c1(	//Outputs
										.tag_out			(tagOut1),
										.data_out		(cacheDataOut1),
                 					.hit				(cacheHit1), 
										.dirty			(dirty1), 
										.valid			(valid1), 
										.err				(cacheErr1),
										// Inputs
										.enable			(cacheEn1), 
										.clk				(clk), 
										.rst				(rst), 
										.createdump		(createdump), 
										.tag_in			(Addr[15:11]), 
										.index			(Addr[10:3]), 
										.offset			(cacheOff), 
										.data_in			(cacheDataIn),
										.comp				(cacheComp), 
										.write			(cacheWr), 
										.valid_in		(cacheValid_in));

/***************************************************** MEMORY *********************************************************/
	reg [15:0] memAddr, memDataIn;
	reg memWr, memRd;
	
	wire [15:0] memDataOut;
	wire [3:0] memBusy;
	wire memStall, memErr;

   four_bank_mem fmem(.clk					(clk), 
							.rst					(rst), 
							.createdump			(createdump), 
							.addr					(memAddr), 
							.data_in				(memDataIn), 
							.wr					(memWr), 
							.rd					(memRd),
                    	.data_out			(memDataOut), 
							.stall				(memStall), 
							.busy					(memBusy), 
							.err					(memErr));

/***************************************************** VICTIM *********************************************************/

	wire victimValid, victimDirty, victimWay, victimWay_in, victimWrite, victimWrite_in;
   reg toggleVictim, chooseVictim, victimSel;

	dff ff6(.q(victimWay), .d(victimWay_in), .clk(clk), .rst(rst));
   assign victimWay_in = (toggleVictim) ? ~victimWay : victimWay;


   dff ff7(.q(victimWrite), .d(victimWrite_in), .clk(clk), .rst(rst));
   assign victimWrite_in = (chooseVictim) ? victimSel : victimWrite;

   always @(*) begin
        casex ({valid0, valid1})

            2'b00: begin
					victimSel = 1'b0;
				end

            2'b01: begin 
					victimSel = 1'b0;
				end

            2'b10: begin
					victimSel = 1'b1;
				end

            2'b11: begin
					victimSel = victimWay;
				end

        endcase

   end

	assign victimValid = (victimSel) ? valid1 : valid0;
   assign victimDirty = (victimSel) ? dirty1 : dirty0;


   assign cacheDataSel = (cacheInRdCompare) ? 
										((valid0 & cacheHit0) ? 
													cacheDataOut0 
													: cacheDataOut1) 
										: ((victimWrite) ? 
													cacheDataOut1 
													: cacheDataOut0);

/***************************************************** DELAYS *********************************************************/

	reg stallWait_in, waitFlag, doneWait_in, waitMem_in;

	wire [15:0]  cacheDataOut_flop, memDataOut_flop;
   wire waitMem_flop, waitCacheHit_in;

	dff waitStall(.q(Stall), .d(stallWait_in), .clk(clk), .rst(rst));
	dff waitDone(.q(Done), .d(doneWait_in), .clk(clk), .rst(rst));
	dff memDataOutWait [15:0] (.d(memDataOut), .q(memDataOut_flop), .clk(clk), .rst(rst));
   dff waitMem(.q(waitMem_flop), .d(waitMem_in), .clk(clk), .rst(rst));
	dff cacheDataOutWait [15:0](.d(cacheDataSel), .q(cacheDataOut_flop), .clk(clk), .rst(rst));

	assign waitCacheHit_in = (valid0 & cacheHit0) | (valid1 & cacheHit1);
   dff WaitCacheHit_in(.q(CacheHit), .d(waitCacheHit_in), .clk(clk), .rst(rst));
	assign DataOut = (waitMem_flop) ? cacheDataOut_flop : memDataOut_flop;

/***************************************************** FSM *********************************************************/

	reg [4:0] nxtState, nxtIdle, nextEvictState_in, nxtWrCompare, nxtRdCompare;
   reg nxtStall_idle, doneWrCompare;

	wire [4:0] state, nxtWrCache0, nxtWrCache1, nxtWrCache2, nxtWrCache3, 
				  nxtWrDirty0, nxtWrDirty1, nxtWrDirty2, nxtWrDirty3,
				  nxtRdMem0, nxtRdMem1, nxtRdMem2, nxtRdMem3,
				  nxtRdDirty0, nxtRdDirty1, nxtRdDirty2, nxtRdDirty3,
				  nxtEvict, nxtWrMem;
	wire [2:0] wait4Cycles_flop, wait4Cycles_in;

	dff stateReg [4:0] (.d(nxtState), .q(state), .clk(clk), .rst(rst));
   assign wait4Cycles_in = ({waitFlag, wait4Cycles_flop[2:1]});
	dff wait4CycleFlop [2:0](.clk(clk), .rst(rst), .d(wait4Cycles_in), .q(wait4Cycles_flop));

   always @(*) begin
      casex ({Rd, Wr})

         2'b00: begin
            nxtIdle = IDLE;
            nxtStall_idle = 1'b0;
         end

         2'b01: begin
            nxtIdle = WR_COMPARE;
            nxtStall_idle = 1'b1;
         end

         2'b10: begin
            nxtIdle = RD_COMPARE;
            nxtStall_idle = 1'b1;
         end

         default: begin
            nxtIdle = 5'bxxxxx;
            nxtStall_idle = 1'bx;
         end

      endcase

   end

   always @(*) begin
      doneWrCompare = 1'b0;
      
      casex({waitCacheHit_in,victimValid,victimDirty})

         3'b011: begin
				nxtWrCompare = WR_DIRTY0;
			end

         3'b010: begin
				nxtWrCompare = WR_MEM;
			end

         3'b1xx: begin
            nxtWrCompare = IDLE;
            doneWrCompare = 1'b1;
         end

         3'b00x: begin
				nxtWrCompare = WR_MEM;
			end

         default: begin
            nxtWrCompare = 5'bxxxxx;
            doneWrCompare = 1'bx;
         end

      endcase

   end

	assign nxtRdDirty0 = memStall ? RD_DIRTY0 : RD_DIRTY1;
   assign nxtRdDirty1 = memStall ? RD_DIRTY1 : RD_DIRTY2;
   assign nxtRdDirty2 = memStall ? RD_DIRTY2 : RD_DIRTY3;
   assign nxtRdDirty3 = memStall ? RD_DIRTY3 : RD_MEM0;

   assign nxtRdMem0 = (memStall | (|wait4Cycles_flop)) ? RD_MEM0 : EVICT_WAIT;
   assign nxtRdMem1 = memStall ? RD_MEM1 : EVICT_WAIT;
   assign nxtRdMem2 = memStall ? RD_MEM2 : EVICT_WAIT;
   assign nxtRdMem3 = memStall ? RD_MEM3 : EVICT_WAIT;

   assign nxtWrDirty0 = memStall ? WR_DIRTY0 : WR_DIRTY1;
   assign nxtWrDirty1 = memStall ? WR_DIRTY1 : WR_DIRTY2;
   assign nxtWrDirty2 = memStall ? WR_DIRTY2 : WR_DIRTY3;
   assign nxtWrDirty3 = memStall ? WR_DIRTY3 : WR_MEM;

	assign nxtWrMem = (memStall) ? WR_MEM : WR_CACHE0;

	dff evictWait [4:0](.d(nextEvictState_in), .q(nxtEvict), .clk(clk), .rst(rst));

	assign nxtWrCache0 = (memStall | ((Addr[2:0] == 3'b000) & (|wait4Cycles_flop))) ? WR_CACHE0 : EVICT_WAIT;
   assign nxtWrCache1 = (memStall | ((Addr[2:0] == 3'b010) & (|wait4Cycles_flop))) ? WR_CACHE1 : EVICT_WAIT;
   assign nxtWrCache2 = (memStall | ((Addr[2:0] == 3'b100) & (|wait4Cycles_flop))) ? WR_CACHE2 : EVICT_WAIT;
   assign nxtWrCache3 = (memStall | ((Addr[2:0] == 3'b110) & (|wait4Cycles_flop))) ? WR_CACHE3 : EVICT_WAIT;

   always @(*) begin
      casex({waitCacheHit_in,victimValid,victimDirty})

         3'b1xx: begin 
				nxtRdCompare = IDLE;
			end

         3'b011: begin
				nxtRdCompare = RD_DIRTY0;
			end

         3'b010: begin 
				nxtRdCompare = RD_MEM0;
			end

         3'b00x: begin
				nxtRdCompare = RD_MEM0;
			end

         default: begin
				nxtRdCompare = 5'bxxxxx;
			end

      endcase

   end

always @(*) begin
      cacheEn0 = 1'b0;
      cacheEn1 = 1'b0;
		cacheValid_in = 1'b0;
      cacheComp = 1'b0;
		doneWait_in = 1'b0;
      stallWait_in = 1'b0;
      cacheWr = 1'b0;
      cacheDataIn = DataIn;
      cacheOff = Addr[2:0];
      memWr = 1'b0;
      memRd = 1'b0;
      memAddr = {tagOut0,Addr[10:0]};
      memDataIn = cacheDataOut0;
      waitFlag = 1'b0;
      waitMem_in = 1'b0;
      nextEvictState_in = IDLE;
      toggleVictim = 1'b0;
      chooseVictim = 1'b0;
      cacheInRdCompare = 1'b0;

      casex (state)
         IDLE: begin
            stallWait_in = nxtStall_idle;
            toggleVictim = (nxtIdle != IDLE) ? 1'b1 : 1'b0;
            nxtState = nxtIdle;
         end

         RD_COMPARE: begin
            doneWait_in = (nxtRdCompare == IDLE) ? 1'b1 : 1'b0;
            stallWait_in = (nxtRdCompare == IDLE) ? 1'b0 : 1'b1;
            cacheEn0 = 1'b1;
            cacheEn1 = 1'b1;
            cacheComp = 1'b1;
            chooseVictim = 1'b1;
            nxtState = nxtRdCompare;
            waitMem_in = 1'b1;
            cacheInRdCompare = 1'b1;
         end

         RD_DIRTY0: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b000};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b000;
            waitFlag = (nxtRdDirty0 == RD_DIRTY1) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtRdDirty0;
         end

         RD_DIRTY1: begin
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b010;
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b010};
            waitFlag = (nxtRdDirty1 == RD_DIRTY2) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtRdDirty1;
         end

         RD_DIRTY2: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b100};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b100;
            waitFlag = (nxtRdDirty2 == RD_DIRTY3) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtRdDirty2;
         end

         RD_DIRTY3: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b110};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b110;
            waitFlag = (nxtRdDirty3 == RD_MEM0) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtRdDirty3;
         end

         RD_MEM0: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3],3'b000};
            nextEvictState_in = RD_MEM1;
            stallWait_in = 1'b1;
            nxtState = nxtRdMem0;
         end

         RD_MEM1: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3],3'b010};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheWr = 1'b1;
            cacheOff = 3'b000;
            cacheDataIn = memDataOut;
            nextEvictState_in = RD_MEM2;
            stallWait_in = 1'b1;
            nxtState = nxtRdMem1;
         end

         RD_MEM2: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3],3'b100};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheWr = 1'b1;
            cacheOff = 3'b010;
            cacheDataIn = memDataOut;
            nextEvictState_in = RD_MEM3;
            stallWait_in = 1'b1;
            nxtState = nxtRdMem2;
         end

         RD_MEM3: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3],3'b110};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheWr = 1'b1;
            cacheOff = 3'b100;
            cacheDataIn = memDataOut;
            nextEvictState_in = RD_MEM;
            stallWait_in = 1'b1;
            nxtState = nxtRdMem3;
         end

         RD_MEM: begin
            stallWait_in = 1'b1;
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheWr = 1'b1;
            cacheOff = 3'b110;
            cacheDataIn = memDataOut;
            nxtState = RD_CLEAR;
         end

         RD_CLEAR: begin
            waitMem_in = 1'b1;
            cacheInRdCompare = 1'b0;
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            stallWait_in = 1'b0;
            doneWait_in = 1'b1;
            nxtState = IDLE;
         end

			WR_COMPARE: begin
            doneWait_in = doneWrCompare;
            cacheEn0 = 1'b1;
            cacheEn1 = 1'b1;
            cacheComp = 1'b1;
            cacheWr = 1'b1;
            chooseVictim = 1'b1;
            stallWait_in = ~doneWrCompare;
            nxtState = nxtWrCompare;
         end

         WR_DIRTY0: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b000};
            waitFlag = (nxtWrDirty0 == WR_DIRTY1) ? 1'b1 : 1'b0;
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b000;
            stallWait_in = 1'b1;
            nxtState = nxtWrDirty0;
         end

         WR_DIRTY1: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b010};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b010;
            waitFlag = (nxtWrDirty1 == WR_DIRTY2) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtWrDirty1;
         end

         WR_DIRTY2: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b100};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b100;
            waitFlag = (nxtWrDirty2 == WR_DIRTY3) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtWrDirty2;
         end

         WR_DIRTY3: begin
            memWr = 1'b1;
            memAddr = {tagOut0,Addr[10:3],3'b110};
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheOff = 3'b110;
            waitFlag = (nxtWrDirty3 == WR_CACHE0) ? 1'b1 : 1'b0;
            stallWait_in = 1'b1;
            nxtState = nxtWrDirty3;
         end

         WR_MEM: begin
            memWr = 1'b1;
            stallWait_in= 1'b1;
            waitFlag = (nxtWrMem == WR_CACHE0) ? 1'b1 : 1'b0;
            memAddr = Addr;
            memDataIn = DataIn;
            nxtState = nxtWrMem;
         end

         EVICT_WAIT: begin
            stallWait_in = 1'b1;
            nxtState = nxtEvict;
         end

         WR_CACHE0: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3], 3'b000};
            nextEvictState_in = WR_CACHE1;
            stallWait_in= 1'b1;
            nxtState = nxtWrCache0;
         end

         WR_CACHE1: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3], 3'b010};
            cacheEn0 = (victimWrite) ? 1'b0 : ((nxtEvict == IDLE) ? 1'b1 : 1'b0);
            cacheEn1 = (victimWrite) ? ((nxtEvict == IDLE) ? 1'b1 : 1'b0) : 1'b0;
            cacheWr = 1'b1;
            cacheDataIn = memDataOut;
            cacheOff = 3'b000;
            nextEvictState_in = WR_CACHE2;
            stallWait_in = 1'b1;
            nxtState = nxtWrCache1;
         end

         WR_CACHE2: begin
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheWr = 1'b1;
            cacheDataIn = memDataOut;
            cacheOff = 3'b010;
            memRd = 1'b1;
            memAddr = {Addr[15:3], 3'b100};
            nextEvictState_in = WR_CACHE3;
            stallWait_in = 1'b1;
            nxtState = nxtWrCache2;
         end

         WR_CACHE3: begin
            memRd = 1'b1;
            memAddr = {Addr[15:3], 3'b110};
				cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
            cacheWr = 1'b1;
            cacheDataIn = memDataOut;
            cacheOff = 3'b100;
            nextEvictState_in = WR_CLEAR;
            stallWait_in = 1'b1;
            nxtState = nxtWrCache3;
         end

         WR_CLEAR: begin
            stallWait_in = 1'b0;
            doneWait_in = 1'b1;
            cacheEn0 = (victimWrite) ? 1'b0 : 1'b1;
            cacheEn1 = (victimWrite) ? 1'b1 : 1'b0;
				cacheValid_in = 1'b1;
            cacheWr = 1'b1;
            cacheDataIn = memDataOut;
            cacheOff = 3'b110;
            nxtState = IDLE;
         end

         default: begin
            nxtState = 5'bxxxx;
         end

      endcase

   end

endmodule // mem_system
