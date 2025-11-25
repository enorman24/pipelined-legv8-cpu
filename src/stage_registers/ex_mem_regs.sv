`timescale 1ns/10ps

//need to name all instantiations
module ex_mem_regs (
    input logic clk,
    input logic reset,

    input logic [63:0] ex_data_d,
    input logic [63:0] wr_data_d,
    input logic MemRead_d,
    input logic MemtoReg_d,
    input logic MemWrite_d,
    input logic RegWrite_d,
    input logic [4:0] reg_write_addr_d,
    input logic [63:0] reg_b_out_stur_d,


    output logic [63:0] ex_data_q,
    output logic [63:0] wr_data_q,
    output logic MemRead_q,
    output logic MemtoReg_q,
    output logic MemWrite_q,
    output logic RegWrite_q,
    output logic [4:0] reg_write_addr_q,
    output logic [63:0] reg_b_out_stur_q
);


    reg_64_bits ex_data_reg (
        .q      (ex_data_q),
        .d      (ex_data_d),
        .reset  (reset),
        .clk    (clk)
    );

    reg_64_bits data_b_reg_stur (
        .q      (reg_b_out_stur_q),
        .d      (reg_b_out_stur_d),
        .reset  (reset),
        .clk    (clk)
    );

    reg_64_bits wr_data_reg (
        .q      (wr_data_q),
        .d      (wr_data_d),
        .reset  (reset),
        .clk    (clk)
    );

    D_FF memread_ff (
        .q      (MemRead_q), 
        .d      (MemRead_d),
        .reset  (reset), 
        .clk    (clk)
    );

    D_FF memtoreg_ff (
        .q      (MemtoReg_q), 
        .d      (MemtoReg_d),
        .reset  (reset), 
        .clk    (clk)
    );

    D_FF memwrite_ff (
        .q      (MemWrite_q), 
        .d      (MemWrite_d),
        .reset  (reset), 
        .clk    (clk)
    );

    D_FF regwrite_ff (
        .q      (RegWrite_q), 
        .d      (RegWrite_d),
        .reset  (reset), 
        .clk    (clk)
    );

    reg_5_bits regwriteaddr_ff (
        .q      (reg_write_addr_q), 
        .d      (reg_write_addr_d),
        .reset  (reset), 
        .clk    (clk)
    );


endmodule