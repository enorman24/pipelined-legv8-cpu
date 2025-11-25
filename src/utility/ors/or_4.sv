`timescale 1ns/10ps
module or_4(num, ored);
    input logic [3:0] num;
    output logic ored;

    or #(50ps) orGate (ored, num[3], num[2], num[1], num[0]);
endmodule