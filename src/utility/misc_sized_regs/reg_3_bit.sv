`timescale 1ns/10ps

module reg_3_bits (
	output logic [2:0] q, 
	input logic [2:0] d, 
	input logic reset, 
	input logic clk
);
	
	genvar i;
	generate
		for(i=0; i<3; i++) begin : regFFnum
			D_FF ff (
				.q		(q[i]),
				.d		(d[i]),
				.reset	(reset),
				.clk	(clk)
			);
		end
	endgenerate


endmodule
