`timescale 1ns/10ps
module twoBitLeftShift_64 (
    input logic [63:0] in,
    output logic [63:0] out
);
    assign out = {in[61:0], 2'b00};
endmodule