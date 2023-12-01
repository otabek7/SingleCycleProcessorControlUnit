`timescale 1ns / 1ps
/*
 * Module: InstructionMemory
 *
 * Implements read-only instruction memory
 * 
 */
module InstructionMemory(Data, Address);
   parameter T_rd = 20;
   parameter MemSize = 40;
   
   output [31:0] Data;
   input [63:0]  Address;
   reg [31:0] 	 Data;
   
   /*
    * ECEN 350 Processor Test Functions
    * Texas A&M University
    */
   
   always @ (Address) begin

      case(Address)

	/* Test Program 1:
	 * Program loads constants from the data memory. Uses these constants to test
	 * the following instructions: LDUR, ORR, AND, CBZ, ADD, SUB, STUR and B.
	 * 
	 * Assembly code for test:
	 * 
	 * 0: LDUR X9, [XZR, 0x0]    //Load 1 into x9
	 * 4: LDUR X10, [XZR, 0x8]   //Load a into x10
	 * 8: LDUR X11, [XZR, 0x10]  //Load 5 into x11
	 * C: LDUR X12, [XZR, 0x18]  //Load big constant into x12
	 * 10: LDUR X13, [XZR, 0x20]  //load a 0 into X13
	 * 
	 * 14: ORR X10, X10, X11  //Create mask of 0xf
	 * 18: AND X12, X12, X10  //Mask off low order bits of big constant
	 * 
	 * loop:
	 * 1C: CBZ X12, end  //while X12 is not 0
	 * 20: ADD X13, X13, X9  //Increment counter in X13
	 * 24: SUB X12, X12, X9  //Decrement remainder of big constant in X12
	 * 28: B loop  //Repeat till X12 is 0
	 * 2C: STUR X13, [XZR, 0x20]  //store back the counter value into the memory location 0x20
	 */
	

	63'h000: Data = 32'hF84003E9;
	63'h004: Data = 32'hF84083EA;
	63'h008: Data = 32'hF84103EB; // x10
	63'h00c: Data = 32'hF84183EC;
	63'h010: Data = 32'hF84203ED;
	63'h014: Data = 32'hAA0B014A;
	63'h018: Data = 32'h8A0A018C; // x12
	63'h01c: Data = 32'hB400008C;
	63'h020: Data = 32'h8B0901AD;
	63'h024: Data = 32'hCB09018C;
	63'h028: Data = 32'h17FFFFFD;
	63'h02c: Data = 32'hF80203ED;
	63'h030: Data = 32'hF84203ED;  //One last load to place stored value on memdbus for test checking.

	/* Add code for your tests here */
	//63'h034: Data = {11'b11010010100, 16'hdef0, 5'd10}; // MOVZ, DEF0, LSL0

	//63'h034: Data = {11'b10110001000, 16'hdef0, 5'd10}; //ADDI
	//63'h038: Data = {11'b10001011000, 16'hdef0, 5'd10}; //ADD

	
	// ADD X9, XZR, 0x0
	63'h034: Data = {11'b10101010000, 16'h1f, 5'd0, 5'd9}; //ADD 

	// ADDI X0, XZR, 0x1234
	// 63'h040: Data = {11'b10110001000, 12'h1234, 5'h1f, 5'd0}; //ADD 


	// MOVZ 0x1234, x0 (shift by 48)
	63'h038: Data = {11'b11010010111, 16'h1234, 5'b0}; //TODO: Comeback to this

	// ADD X9, X9, X0
	63'h03c: Data = {11'b00001011000, 16'h9, 5'd0, 5'h9}; //ADD 

	// ADDI X0, XZR, 0x5678
	// 63'h04c: Data = {11'b10110001000, 12'h5678, 5'h1f, 5'd0}; //ADDI

	// MOVZ 0x5678, 0x0 (shift by 32)
	63'h040: Data = {11'b11010010110, 16'h5678, 5'h0}; //TODO: Comeback to this

	// ADD X9, X9, X0
	63'h044: Data = {11'b10001011000, 16'h9, 5'd0, 5'h9}; //ADD 


	// ADDI X0, XZR, 0x9abc
	// 63'h058: Data = {11'b10110001000, 12'h9abc, 5'h1f, 5'd0}; //ADDI

	// MOVZ 0x9abc, 0x0 (shift by 16)
	63'h048: Data = {11'b11010010101, 16'h9abc, 5'd0}; //TODO: Comeback to this

	// ADD X9, X9, X0
	63'h04c: Data = {11'b10001011000, 16'h9, 5'd0, 5'd9}; //ADD 


	// ADDI X0, XZR, 0xdef0
	// 63'h064: Data = {11'b10110001000, 12'hdef0, 5'h1f, 5'd0}; //ADDI

	// MOVZ 0xdef0, 0x0 (shift by 0)
	63'h050: Data = {11'b11010010100, 16'hdef0, 5'd0}; //TODO: Comeback to this

	// ADD X9, X9, X0
	63'h054: Data = {11'b10001011000, 16'h9, 5'd0, 5'd9}; //ADD 


	// STUR X9, [XZR, 0x28]
	63'h058: Data = {11'b11111000000, 9'h28, 2'h0, 5'h1f, 5'h9}; //STUR 

	// LDUR X10, [XZR, 0x28]
	63'h05c: Data = {11'b111000010, 9'h28, 2'h0, 5'h1f, 5'ha}; //LDUR 
	
	default: Data = 32'hXXXXXXXX;
      endcase
   end
endmodule
