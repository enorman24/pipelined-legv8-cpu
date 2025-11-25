

`timescale 1ns/10ps

module mux4_1(sel, in, out);
	input logic [1:0] sel;
	input logic [3:0] in;
	output logic out;
	logic lower_out, upper_out;
	
	mux2_1 lower_mux(.sel(sel[0]), .input_a(in[0]), .input_b(in[1]), .out(lower_out));
	mux2_1 upper_mux(.sel(sel[0]), .input_a(in[2]), .input_b(in[3]), .out(upper_out));
	mux2_1 final_mux(.sel(sel[1]), .input_a(lower_out), .input_b(upper_out), .out(out));
	
endmodule


module mux4_1_testbench;
	logic [1:0] sel;
	logic [3:0] in;
	logic out;
	logic lower_out, upper_out;

	mux4_1 dut (.sel, .in, .out);

	integer i;

	initial begin
		for (i = 0; i < 65; i++) begin
			sel = i[1:0];
			in[0] = i[2];
			in[1] = i[3];
			in[2] = i[4];
			in[3] = i[5];
			#10;
		end
	end
endmodule
