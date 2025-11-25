`timescale 1ns/10ps
module oneBitAlu(a, b, carry_in, carry_out, out, cntrl, subtract);
    input logic a, b, carry_in, subtract;
    input logic [2:0] cntrl;
    output logic carry_out, out;

    logic [7:0] mux_inputs;
    logic and_out, or_out, xor_out, adder_out, b_sub;

    and #(50ps) and_gate(and_out, a, b);
    or  #(50ps) or_gate(or_out, a, b);
    xor #(50ps) xor_gate(xor_out, a, b);

    //for if it is a subtract
    xor #(50ps) xor_b_subtract_gate(b_sub, b, subtract);

    oneBitAdder adder_instance (.a(a), .b(b_sub), .carry_in(carry_in), .carry_out(carry_out), .out(adder_out));

    assign mux_inputs = {1'bX, xor_out, or_out, and_out, adder_out, adder_out, 1'bX, b};
    mux8_1 mux_instance (.sel(cntrl), .in(mux_inputs), .out(out));

endmodule
