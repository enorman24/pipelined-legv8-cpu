`timescale 1ns/10ps
module mux2_1_5 (
    input logic [4:0] a, 
    input logic [4:0] b,
    input logic sel,
    output logic [4:0] out
);

genvar i;
generate;
    for(i = 0; i < 5; i++) begin : muxs
        mux2_1 onebit (
            .sel          (sel), 
            .input_a      (a[i]), 
            .input_b      (b[i]), 
            .out          (out[i])
        );
    end
endgenerate
endmodule