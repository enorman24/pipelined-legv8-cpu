`timescale 1ns/10ps

module reg_FF (en, write, clk, reset, out);
	input en, write, clk, reset;
	output out;
	logic cur, temp;
	
	
	mux2_1 mux (.sel(en), .input_a(cur), .input_b(write), .out(temp));
	D_FF FF (.q(cur), .d(temp), .reset(reset), .clk(clk));
	assign out = cur; 

endmodule