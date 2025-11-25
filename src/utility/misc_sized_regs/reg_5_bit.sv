`timescale 1ns/10ps

module reg_5_bits (
	output logic [4:0] q, 
	input logic [4:0] d, 
	input logic reset, 
	input logic clk
);
	
	genvar i;
	generate
		for(i=0; i<5; i++) begin : regFFnum
			D_FF ff (
				.q		(q[i]),
				.d		(d[i]),
				.reset	(reset),
				.clk	(clk)
			);
		end
	endgenerate


endmodule
