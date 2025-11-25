`timescale 1ns/10ps
module signExtend32_64 (
    input logic [31:0] in,
    output logic [63:0] out
);
    assign out = {{32{in[31]}}, in};
endmodule