`timescale 1ns/10ps


// a is chosen if sel is 0
module mux2_1(sel, input_a, input_b, out);
	input logic input_a, input_b, sel;
	output logic out;
	logic inverted_sel, and_a, and_b, or_result;
	
	xor #(50ps) invert_sel (inverted_sel, sel, 1'b1);
	and #(50ps) and_input_a (and_a, input_a, inverted_sel);
	and #(50ps) and_input_b (and_b, sel, input_b);
	or #(50ps) or_gate (out, and_a, and_b);
	
endmodule


module mux2_1_testbench();
	logic input_a, input_b, sel;
	logic out;
	logic inverted_sel, and_a, and_b, or_result;
	
	mux2_1 dut (.sel, .input_a, .input_b, .out);
	
	integer i;
	
	initial begin
		for (i = 0; i < 8; i++) begin
			{sel, input_a, input_b} = i; #10;
		end
	end
	
endmodule
