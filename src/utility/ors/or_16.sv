`timescale 1ns/10ps
module or_16(num, ored);
    input logic [15:0] num;
    output logic ored;

    logic [3:0] temp;

    or_4 first (.num(num[3:0]), .ored(temp[0]));
    or_4 second (.num(num[7:4]), .ored(temp[1]));
    or_4 third (.num(num[11:8]), .ored(temp[2]));
    or_4 fourth (.num(num[15:12]), .ored(temp[3]));

    or #(50ps) orGate (ored, temp[3], temp[2], temp[1], temp[0]);

endmodule