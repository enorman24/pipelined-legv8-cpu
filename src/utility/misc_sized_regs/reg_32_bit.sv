`timescale 1ns/10ps

module reg_32_bits (
	output logic [31:0] q, 
	input logic [31:0] d, 
	input logic reset, 
	input logic clk
);
	
	genvar i;
	generate
		for(i=0; i<32; i++) begin : regFFnum
			D_FF ff (
				.q		(q[i]),
				.d		(d[i]),
				.reset	(reset),
				.clk	(clk)
			);
		end
	endgenerate


endmodule
