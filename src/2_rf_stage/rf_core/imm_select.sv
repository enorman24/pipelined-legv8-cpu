`timescale 1ns/10ps

module imm_select (
    input logic [11:0] alu_imm,
    input logic [8:0] ld_sr_imm,

    //control signal that determines selected immediate
    input logic sel, //alu imm if zero, ld/str if 1


    output logic [63:0] sel_imm
);


    logic [63:0] imm9, imm12;

    signExtend9_64 ld_st_imm (
        .in         (ld_sr_imm),
        .out        (imm9)
    );

    //really zero extend
    signExtend12_64 add_sub_imm (
        .in         (alu_imm),
        .out        (imm12)
    );

    mux2_1_64 immedMux (
        .sel            (sel), 
        .a              (imm12), // addi/subi
        .b              (imm9), // load/store
        .out            (sel_imm)
    );

endmodule