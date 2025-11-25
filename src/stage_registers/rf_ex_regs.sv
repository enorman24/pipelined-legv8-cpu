`timescale 1ns/10ps

import controlPkg::*;
//need to name all instantiations
module rf_ex_regs (
    input logic clk,
    input logic reset,

    input logic [63:0] data_a_d,
    input logic [63:0] data_b_d,
    input logic [5:0] shamt_d,
    input logic MemRead_d,
    input logic aluOrShift_d,
    input logic MemtoReg_d,
    input logic MemWrite_d,
    input logic RegWrite_d,
    input logic [2:0] aluControl_d,
    input logic [4:0] reg_write_addr_d,
    input logic [63:0] reg_b_out_stur_d,
    input logic set_flags_d,

    output logic [63:0] data_a_q,
    output logic [63:0] data_b_q,
    output logic [5:0] shamt_q,
    output logic MemRead_q,
    output logic aluOrShift_q,
    output logic MemtoReg_q,
    output logic MemWrite_q,
    output logic RegWrite_q,
    output logic [2:0] aluControl_q,
    output logic [4:0] reg_write_addr_q,
    output logic [63:0] reg_b_out_stur_q,
    output logic set_flags_q
);

    reg_64_bits data_a_reg (
        .q      (data_a_q),
        .d      (data_a_d),
        .reset  (reset),
        .clk    (clk)
    );

    reg_64_bits data_b_reg (
        .q      (data_b_q),
        .d      (data_b_d),
        .reset  (reset),
        .clk    (clk)
    );

    reg_64_bits data_b_reg_stur (
        .q      (reg_b_out_stur_q),
        .d      (reg_b_out_stur_d),
        .reset  (reset),
        .clk    (clk)
    );


    reg_6_bits shamt_reg (
        .q      (shamt_q),
        .d      (shamt_d),
        .reset  (reset),
        .clk    (clk)
    );

    D_FF memread_ff (
        .q      (MemRead_q), 
        .d      (MemRead_d),
        .reset  (reset), 
        .clk    (clk)
    );

    D_FF aluorshift_ff (
        .q      (aluOrShift_q), 
        .d      (aluOrShift_d),
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

    D_FF setFlags_ff (
        .q      (set_flags_q), 
        .d      (set_flags_d),
        .reset  (reset), 
        .clk    (clk)
    );

    

    reg_3_bits aluctrl_reg (
        .q      (aluControl_q), 
        .d      (aluControl_d),
        .reset  (reset), 
        .clk    (clk)
    );

    reg_5_bits regwriteaddr_reg (
        .q      (reg_write_addr_q),
        .d      (reg_write_addr_d),
        .reset  (reset),
        .clk    (clk)
    );


endmodule