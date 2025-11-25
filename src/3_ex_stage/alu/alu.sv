// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
    input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out ;

	logic [64:0] carrys;
	logic [63:0] singleBitResult, shiftResult;
	logic subtract, ored;

	// flags
	xor #(50ps) overflow_detection (overflow, carrys[63], carrys[64]);
	assign negative = result[63];
	assign carry_out = carrys[64];

	or_64 oredOuts (.num(result), .ored(ored));
	not #(50ps) isZero (zero, ored);

	//subtraction
	// isSubtract subtractTester (.cntrl, .subtract);
	assign subtract = cntrl[0];
	assign carrys[0] = subtract;

	// one bit alus
    genvar i;
	generate;
		for(i=0; i<64; i++) begin : eachOneBitALU
      		oneBitAlu oneBitALU (.a(A[i]), .b(B[i]), .carry_in(carrys[i]), .carry_out(carrys[i+1]), .out(result[i]), .cntrl(cntrl), .subtract(subtract));
    	end
	endgenerate
endmodule