`timescale 1ns/10ps

module mux32_1(sel, in, out);
	input logic [4:0] sel;
	input logic [31:0] in;
	output logic out;
	logic lower_out, upper_out;
	
	mux16_1 lower_mux(.sel(sel[3:0]), .in(in[15:0]), .out(lower_out));
	mux16_1 upper_mux(.sel(sel[3:0]), .in(in[31:16]), .out(upper_out));
	mux2_1 final_mux(.sel(sel[4]), .input_a(lower_out), .input_b(upper_out), .out(out));
	
endmodule
