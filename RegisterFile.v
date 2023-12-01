`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
	
	input [63:0] BusW;
	input [4:0] RA, RB, RW; // provides enough bits for all registers
	input RegWr, Clk;

	output  [63:0] BusA;
	output 	[63:0] BusB;

	reg [63:0] registers [31:0]; // 32 64-bit registers



	initial registers[31] <= 64'b0; // set 31st register to 0

	assign #2 BusA = registers[RA]; // pass to BusA with 2 tic delay
	assign #2 BusB = registers[RB]; // pass to BusB with 2 tic delay

	always@(negedge Clk) begin
		if (RegWr && RW != 31) 
		begin
			registers[RW] <= #3 BusW; // delay of 3 tics as instructed
		end
	end

endmodule