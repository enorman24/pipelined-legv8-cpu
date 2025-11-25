`timescale 1ns/10ps

module branch_path (
    input logic [25:0] b_addr,
    input logic [18:0] cond_addr,
    input logic uncondbr_sel,

    output logic [63:0] branchaddr
);

    logic [63:0] b_ext, bcond_ext, selbr;


    signExtend26_64 brAddr (
        .in     (b_addr),
        .out    (b_ext)
    );

    signExtend19_64 condbrAddr (
        .in     (cond_addr),
        .out    (bcond_ext)
    );

    mux2_1_64 uncondBr (
        .sel            (uncondbr_sel), 
        .a              (bcond_ext), 
        .b              (b_ext), 
        .out            (selbr)
    );

    twoBitLeftShift_64 shift_branch(
        .in      (selbr),
        .out     (branchaddr)
    );

endmodule