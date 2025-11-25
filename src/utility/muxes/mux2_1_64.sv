`timescale 1ns/10ps
module mux2_1_64 (
    input logic [63:0]      a, b,
    input logic             sel,
    output logic [63:0]     out
);

genvar i;
generate;
    for(i = 0; i < 64; i++) begin : muxs
        mux2_1 onebit (
            .sel          (sel), 
            .input_a      (a[i]), 
            .input_b      (b[i]), 
            .out          (out[i])
        );
    end
endgenerate
endmodule