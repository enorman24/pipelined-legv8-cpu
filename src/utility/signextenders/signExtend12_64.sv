`timescale 1ns/10ps

//really a zero extend (just don't want to have to change all the names)
module signExtend12_64 (
    input logic [11:0] in,
    output logic [63:0] out
);
    assign out = {52'b0, in};
endmodule