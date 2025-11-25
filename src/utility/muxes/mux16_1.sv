`timescale 1ns/10ps

module mux16_1(sel, in, out);
	input logic [3:0] sel;
	input logic [15:0] in;
	output logic out;
	logic lower_out, upper_out;
	
	mux8_1 lower_mux(.sel(sel[2:0]), .in(in[7:0]), .out(lower_out));
	mux8_1 upper_mux(.sel(sel[2:0]), .in(in[15:8]), .out(upper_out));
	mux2_1 final_mux(.sel(sel[3]), .input_a(lower_out), .input_b(upper_out), .out(out));
	
endmodule
