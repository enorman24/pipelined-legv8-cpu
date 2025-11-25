`timescale 1ns/10ps

module rf_datapath (
    input logic clk,

    //register addresses
    input logic [4:0] rd_addr, //the address from writeback
    input logic [4:0] rd_data, //the data to the mux
    input logic [4:0] rm,
    input logic [4:0] rn,
    input logic [8:0] ld_sr_imm,
    input logic [11:0] alu_imm,

    input logic [63:0] wr_data, //from WB stage

    //control signals
    input logic reg2loc, // mux signal from rf_control
    input logic reg_write, //write signal from WB
    input logic imm_sel, //9 or 12 bit immediate (alu imm vs laod/store) (0 is alu imm)
    input logic alu_src, //if 1 it comes from an immediate, 0 comes from reg

    //=============implementation subject to change===============
    //CONTROL
    input logic forwarding_source_a, //mux input for the forwarding source to a (0 is from ex)
    input logic forwarding_source_b, //mux input for the forwarding source to b (0 is from ex)
    input logic forwarding_a_en, //mux input for the forwarding logic to a
    input logic forwarding_b_en, //mux input for the forwarding logic to b
    //DATA
    input logic [63:0] forwarding_data_a_ex, //forwarded data a EX
    input logic [63:0] forwarding_data_b_ex, //forwarded data a EX
    input logic [63:0] forwarding_data_a_mem, //forwarded data a MEM
    input logic [63:0] forwarding_data_b_mem, //forwarded data a MEM
    //=============implementation subject to change===============

    //to EX
    output logic [63:0] data_a,
    output logic [63:0] data_b,
    output logic [63:0] reg_data_b_out
);  

    logic [4:0] reg2loc_addr;
    logic [63:0] reg_data_a, reg_data_b;
    logic [63:0] reg_b_forwarded;


    //=============REG2LOC MUX================//
    mux2_1_5 instrToReg (
        .sel            (reg2loc), 
        .a              (rd_data), 
        .b              (rm), 
        .out            (reg2loc_addr)
    );
    //============REGISTER FILE================//
    regfile registerfile (
        .ReadData1      (reg_data_a), 
        .ReadData2      (reg_data_b), 
        .WriteData      (wr_data), 
        .ReadRegister1  (rn),
        .ReadRegister2  (reg2loc_addr), 
        .WriteRegister  (rd_addr), 
        .RegWrite       (reg_write), 
        .clk            (~clk)
    );

    //==========CHOOSE THE IMMEDIATE============//
    logic [63:0] selected_imm;
    
    imm_select which_imm ( // 0 is alu imm
        .alu_imm      (alu_imm),
        .ld_sr_imm    (ld_sr_imm),
        .sel          (imm_sel),
        .sel_imm      (selected_imm)  
    );
    //===========CHOOSE IF DATA B IS FROM REG OR IMM========//
    mux2_1_64 reg_or_imm_mux (
        .sel (alu_src),
        .a   (reg_b_forwarded),
        .b   (selected_imm),
        .out (data_b)
    );


    logic [63:0] selected_forward_a, selected_forward_b;
    //=============CHOOSE DATA FORWARDING SOURCE FOR A============//
    mux2_1_64 forwarding_sel_a (
        .sel            (forwarding_source_a), 
        .a              (forwarding_data_a_ex), 
        .b              (forwarding_data_a_mem), 
        .out            (selected_forward_a)
    );
    //=============CHOOSE DATA FORWARDING SOURCE FOR B============//
    mux2_1_64 forwarding_sel_b (
        .sel            (forwarding_source_b), 
        .a              (forwarding_data_b_ex), 
        .b              (forwarding_data_b_mem), 
        .out            (selected_forward_b)
    );
    //=============CHOOSE IF DATA FORWARDING IS ON A============//
    mux2_1_64 forwarding_en_a (
        .sel            (forwarding_a_en), 
        .a              (reg_data_a), 
        .b              (selected_forward_a), 
        .out            (data_a)
    );
    //=============CHOOSE IF DATA FORWARDING IS ON B============//
    mux2_1_64 forwarding_en_b (
        .sel (forwarding_b_en),
        .a   (reg_data_b),
        .b   (selected_forward_b),
        .out (reg_b_forwarded)
    );



    assign reg_data_b_out = reg_b_forwarded;

    
endmodule