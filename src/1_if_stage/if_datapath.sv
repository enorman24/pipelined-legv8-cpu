`timescale 1ns/10ps

module if_datapath (
    input logic clk,
    input logic reset,

    input logic [63:0] br_taken_pc,
    input logic br_taken,

    //to rf
    output logic [63:0] pc,
    output logic [31:0] instr
);

    //============== BRANCH LOGIC THAT RETAINS PC AT BRANCH==============//
    logic [63:0] nextpc, pc4;

    adder instradder4 (
        .A              (pc), 
        .B              (64'b100), 
        .result         (pc4)
    );

    mux2_1_64 isntrBranch (
        .sel            (br_taken),  //control
        .a              (pc4), 
        .b              (br_taken_pc), 
        .out            (nextpc)
    );

    pc_register PC (
        .clk        (clk),
        .reset      (reset),
        .writeData  (nextpc),
        .readData   (pc)
    );

    //========== INSTRUCTION MEMORY ==========//
    instructmem instructmemory (
        .address        (pc),       
        .instruction    (instr),
        .clk            (clk)
    );

endmodule