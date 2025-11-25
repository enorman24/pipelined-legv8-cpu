`timescale 1ns/10ps

module sum (a, b, carry_in, out);
    input  logic a, b, carry_in;
    output logic out;

    logic and1_out, and2_out, and3_out, and4_out;
    logic not_a, not_b, not_c;

    // Inverters
    not inv0 (not_a, a);
    not inv1 (not_b, b);
    not inv2 (not_c, carry_in);
    
    // Sum section
    and #(50ps) and0 (and1_out, a, not_b, not_c);
    and #(50ps) and1 (and2_out, not_a, b, not_c);
    and #(50ps) and2 (and3_out, not_a, not_b, carry_in);
    and #(50ps) and3 (and4_out, a, b, carry_in);

    or  #(50ps) or0 (out, and1_out, and2_out, and3_out, and4_out);

endmodule
