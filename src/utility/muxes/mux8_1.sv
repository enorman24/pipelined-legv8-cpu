`timescale 1ns/10ps

module mux8_1(sel, in, out);
	input logic [2:0] sel;
	input logic [7:0] in;
	output logic out;
	logic lower_out, upper_out;
	
	mux4_1 lower_mux(.sel(sel[1:0]), .in(in[3:0]), .out(lower_out));
	mux4_1 upper_mux(.sel(sel[1:0]), .in(in[7:4]), .out(upper_out));
	mux2_1 final_mux(.sel(sel[2]), .input_a(lower_out), .input_b(upper_out), .out(out));
	
endmodule


module mux8_1_testbench;
	logic [2:0] sel;
	logic [7:0] in;
	logic out;
	logic lower_out, upper_out;
	
	mux8_1 dut (.sel, .in, .out);
	
	initial begin
		sel = 3'b000; in = 8'b00000000; #10;
		sel = 3'b000; in = 8'b00000001; #10;
		sel = 3'b010; in = 8'b00000001; #10;
		sel = 3'b110; in = 8'b01110101; #10;
	end
endmodule
