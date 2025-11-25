`timescale 1ns/10ps

//need to name all instantiations
module if_rf_regs (
    input logic clk,
    input logic reset,
    
    input logic [31:0] instr_d,
    input logic [63:0] pc_d,
    

    output logic [31:0] instr_q,
    output logic [63:0] pc_q

);

    reg_64_bits pc_reg (
        .q      (pc_q),
        .d      (pc_d),
        .reset  (reset),
        .clk    (clk)
    );

    

    reg_32_bits instr_reg (
        .q      (instr_q),
        .d      (instr_d),
        .reset  (reset),
        .clk    (clk)
    );

    

endmodule