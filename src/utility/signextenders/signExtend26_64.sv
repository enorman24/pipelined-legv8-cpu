`timescale 1ns/10ps
module signExtend26_64 (
    input logic [25:0] in,
    output logic [63:0] out
);
    assign out = {{38{in[25]}}, in};
endmodule