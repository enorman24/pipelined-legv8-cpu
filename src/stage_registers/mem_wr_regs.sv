`timescale 1ns/10ps

//need to name all instantiations
module mem_wr_regs (
    input logic clk,
    input logic reset,

    output logic [63:0] data_q,
    output logic [4:0] reg_write_addr_q,
    output logic RegWrite_q,

    input logic [63:0] data_d,
    input logic [4:0] reg_write_addr_d,
    input logic RegWrite_d
);


    reg_64_bits data_reg (
        .q      (data_q),
        .d      (data_d),
        .reset  (reset),
        .clk    (clk)
    );

    reg_5_bits regwriteaddr_reg (
        .q      (reg_write_addr_q),
        .d      (reg_write_addr_d),
        .reset  (reset),
        .clk    (clk)
    );

    D_FF regwrite_ff (
        .q      (RegWrite_q), 
        .d      (RegWrite_d),
        .reset  (reset), 
        .clk    (clk)
    );


endmodule