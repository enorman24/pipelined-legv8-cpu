`timescale 1ns/10ps

module branch_pc_datapath (
    input logic [25:0] b_addr,
    input logic [18:0] cond_addr,
    input logic [63:0] branch_instr_pc,

    input logic uncondbr_sel,
    input logic brTaken,

    output logic [63:0] br_taken_pc
);

    logic [63:0] branchoffset;

    branch_path eval_branch (
            .b_addr         (b_addr),
            .cond_addr      (cond_addr),
            .uncondbr_sel   (uncondbr_sel),
            .branchaddr     (branchoffset)
    );

    adder instradderbranch ( 
            .A              (branch_instr_pc), //uses the branches pc not the current one
            .B              (branchoffset), 
            .result         (br_taken_pc)
    );

    

endmodule