`timescale 1ns/10ps
module oneBitAdder (a, b, carry_in, carry_out, out);
    input logic a, b, carry_in;
    output logic carry_out, out;
    
    carryout carry (.a, .b, .carry_in, .carry_out);
    sum summer (.a, .b, .carry_in, .out);

endmodule