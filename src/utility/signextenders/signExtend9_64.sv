`timescale 1ns/10ps
module signExtend9_64 (
    input logic [8:0] in,
    output logic [63:0] out
);
    assign out = {{55{in[8]}}, in};
endmodule