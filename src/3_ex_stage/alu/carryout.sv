`timescale 1ns/10ps

module carryout(a, b, carry_in, carry_out);
    input logic a, b, carry_in;
    output logic carry_out;

    logic and_ab, and_ac, and_bc;

    and #(50ps) and_carry_ab (and_ab, a, b);
    and #(50ps) and_carry_ac (and_ac, a, carry_in);
    and #(50ps) and_carry_bc (and_bc, b, carry_in);

    or  #(50ps) or_carry_output (carry_out, and_ab, and_ac, and_bc);
    
endmodule
