`timescale 1ns/10ps
module adder(A, B, result);
    input logic [63:0] A, B;
	output logic [63:0] result;

	logic [64:0] carrys;


	assign carrys[0] = 0;

	// one bit alus
    genvar i;
	generate;
		for(i=0; i<64; i++) begin : eachOneBitAdder
            oneBitAdder singleBitAdders (.a(A[i]), .b(B[i]), .carry_in(carrys[i]), .carry_out(carrys[i+1]), .out(result[i]));
    	end
	endgenerate

endmodule