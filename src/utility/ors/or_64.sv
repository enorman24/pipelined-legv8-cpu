`timescale 1ns/10ps
module or_64(num, ored);
    input logic [63:0] num;
    output logic ored;

    logic [3:0] temp;

    or_16 first (.num(num[15:0]), .ored(temp[0]));
    or_16 second (.num(num[31:16]), .ored(temp[1]));
    or_16 third (.num(num[47:32]), .ored(temp[2]));
    or_16 fourth (.num(num[63:48]), .ored(temp[3]));

    or #(50ps) orGate (ored, temp[0], temp[1], temp[2], temp[3]);

endmodule
