`timescale 1ns/10ps

module pc_register(
	input logic clk,
	input logic reset,
	input logic [63:0] writeData,

	output logic [63:0] readData
);
	
	
	genvar i;
	generate
		for(i=0; i<64; i++) begin : pcFFnum
			D_FF pcFF (
				.q		(readData[i]), 
				.d		(writeData[i]), 
				.reset	(reset), 
				.clk	(clk)
			);
		end
	endgenerate

endmodule
