`timescale 1ns/10ps

import controlPkg::*;

module cpu_top(
    input logic clk,
    input logic reset
);

//======= WB =======//
    logic [63:0] wb_data;
    logic [4:0] wb_addr;
    logic wb_RegWrite;

//======= WB =======//

    logic [63:0] if_pc, rf_pc, rf_br_taken_pc;
    logic [31:0] if_instr, rf_instr;

    logic [63:0] fwd_ex_data, fwd_mem_data;
    logic [63:0] rf_data_a, rf_data_b, ex_data_a, ex_data_b; 
    // logic rf_MemRead, rf_aluOrShift, rf_MemtoReg, rf_MemWrite, rf_RegWrite, rf_aluControl, rf_reg_write_addr;
    logic ex_MemRead, ex_aluOrShift, ex_MemtoReg, ex_MemWrite, ex_RegWrite;
    aluCntrl ex_aluControl;
    logic [5:0] ex_shamt;
    logic [4:0] ex_reg_write_addr, mem_reg_write_addr;
    logic [63:0] mem_data_in, mem_data_out, mem_data_wr;
    logic mem_MemRead, mem_MemtoReg, mem_MemWrite, mem_RegWrite;
    cntrl rf_cntrl;
    alu_flags curr_flags;
    logic acc_br_zero;
    logic rf_set_flags, ex_set_flags;

    logic forwarding_source_a, forwarding_source_b;
    logic forwarding_en_a, forwarding_en_b;
    logic [63:0] reg_b_out_stur, mem_stur_data, ex_stur_data;


//==================== IF ========================//
    if_datapath if_stage (
        .clk                    (clk),
        .reset                  (reset),
        .br_taken_pc            (rf_br_taken_pc),
        .br_taken               (rf_cntrl.brTaken),
        .pc                     (if_pc),
        .instr                  (if_instr)
    );

//================= STAGE REGISTERS TO / FROM RF ====================//
    if_rf_regs if_rf_stage_regs (
        .clk                    (clk),
        .reset                  (reset),
        .instr_d                (if_instr),
        .pc_d                   (if_pc),
        
        .instr_q                (rf_instr),
        .pc_q                   (rf_pc)
        
    );

//================== CONTROL ========================//

    control control_path (
        .opcode                 (rf_instr[31:21]),
        .clk                    (clk),
        .reset                  (reset),
        .flags                  (curr_flags),
        .zero_check             (acc_br_zero), //need to check for this at the end of this stage
        .set_flags_in           (ex_set_flags),
        .set_flags_out          (rf_set_flags),
        .controlsigs            (rf_cntrl)
    );

    
    forwarding_control forwarding_control (
        .ex_wr_reg              (ex_reg_write_addr),
        .ex_wr_en               (ex_RegWrite),

        .mem_wr_reg             (mem_reg_write_addr),
        .mem_wr_en              (mem_RegWrite),
        .rm                     (rf_instr[20:16]),
        .rn                     (rf_instr[9:5]),
        .rd                     (rf_instr[4:0]),
        .reg2loc                (rf_cntrl.Reg2Loc),

        .forwarding_source_a    (forwarding_source_a),
        .forwarding_source_b    (forwarding_source_b),

        .forwarding_a_en        (forwarding_en_a),
        .forwarding_b_en        (forwarding_en_b)
    );


//================ RF DATAPATH ====================//
    rf_datapath rf_datapath (
        .clk                    (clk),
        .rd_addr                (wb_addr), //from wb
        .rd_data                (rf_instr[4:0]),
        .rm                     (rf_instr[20:16]),
        .rn                     (rf_instr[9:5]),
        .alu_imm                (rf_instr[21:10]),
        .ld_sr_imm              (rf_instr[20:12]),

        .wr_data                (wb_data),
        .reg2loc                (rf_cntrl.Reg2Loc), 
        .reg_write              (wb_RegWrite),
        .imm_sel                (rf_cntrl.ImmSel),
        .alu_src                (rf_cntrl.ALUSrc),

        .forwarding_source_a    (forwarding_source_a), 
        .forwarding_source_b    (forwarding_source_b),

        .forwarding_a_en        (forwarding_en_a), 
        .forwarding_b_en        (forwarding_en_b),

        .forwarding_data_a_ex   (fwd_ex_data), 
        .forwarding_data_b_ex   (fwd_ex_data),

        .forwarding_data_a_mem  (fwd_mem_data),
        .forwarding_data_b_mem  (fwd_mem_data),

        .data_a                 (rf_data_a),
        .data_b                 (rf_data_b),
        .reg_data_b_out         (reg_b_out_stur)  
    );
    

    branch_pc_datapath pc_datapath (
        .b_addr                 (rf_instr[25:0]),
        .cond_addr              (rf_instr[23:5]),
        .branch_instr_pc        (rf_pc),
        .uncondbr_sel           (rf_cntrl.uncondBr),
        .brTaken                (rf_cntrl.brTaken), //input
        .br_taken_pc            (rf_br_taken_pc)
    );

    logic or_of_b;

    or_64 zero_check (
        .num                    (rf_data_b),
        .ored                   (or_of_b)
    );

    not #(50ps) isZero (acc_br_zero, or_of_b);

//================= STAGE REGISTERS ====================//
//assigning enum to bits
    logic [2:0] alu_cntrl_bits_q, alu_cntrl_bits_d;
    assign alu_cntrl_bits_d = rf_cntrl.aluControl;

    rf_ex_regs rf_to_ex_registers ( //add data that will be written to memory
        .clk                    (clk),
        .reset                  (reset),
        .data_a_d               (rf_data_a),
        .data_b_d               (rf_data_b),
        .shamt_d                (rf_instr[15:10]),

        .MemRead_d              (rf_cntrl.MemRead),
        .aluOrShift_d           (rf_cntrl.aluOrShift),
        .MemtoReg_d             (rf_cntrl.MemtoReg),
        .MemWrite_d             (rf_cntrl.MemWrite),
        .RegWrite_d             (rf_cntrl.RegWrite),
        .aluControl_d           (alu_cntrl_bits_d),
        .reg_write_addr_d       (rf_instr[4:0]),
        .reg_b_out_stur_d       (reg_b_out_stur),
        .set_flags_d            (rf_set_flags),

        .data_a_q               (ex_data_a),
        .data_b_q               (ex_data_b),
        .shamt_q                (ex_shamt),
        .MemRead_q              (ex_MemRead),
        .aluOrShift_q           (ex_aluOrShift),
        .MemtoReg_q             (ex_MemtoReg),
        .MemWrite_q             (ex_MemWrite),
        .RegWrite_q             (ex_RegWrite),
        .aluControl_q           (alu_cntrl_bits_q),
        .reg_write_addr_q       (ex_reg_write_addr),
        .reg_b_out_stur_q       (ex_stur_data),
        .set_flags_q            (ex_set_flags)
    );  

    assign ex_aluControl = aluCntrl'(alu_cntrl_bits_q);

//==================== EX ========================//
    ex_datapath ex_datapath (    
        .data_a                 (ex_data_a),
        .data_b                 (ex_data_b),
        .shamt                  (ex_shamt),
        .alu_op                 (ex_aluControl),
        .shift_instr            (ex_aluOrShift),
        .ex_data_out            (fwd_ex_data),
        .flags                  (curr_flags)
    );


//================= STAGE REGISTERS ====================//
    ex_mem_regs ex_to_mem_registers (
        .clk                    (clk),
        .reset                  (reset),
        .ex_data_d              (fwd_ex_data),
        .wr_data_d              (ex_data_b),
        .MemRead_d              (ex_MemRead),
        .MemtoReg_d             (ex_MemtoReg),
        .MemWrite_d             (ex_MemWrite),
        .RegWrite_d             (ex_RegWrite),
        .reg_write_addr_d       (ex_reg_write_addr),
        .reg_b_out_stur_d       (ex_stur_data),
        .ex_data_q              (mem_data_in),
        .wr_data_q              (mem_data_wr),
        .MemRead_q              (mem_MemRead),
        .MemtoReg_q             (mem_MemtoReg),
        .MemWrite_q             (mem_MemWrite),
        .RegWrite_q             (mem_RegWrite),
        .reg_write_addr_q       (mem_reg_write_addr),
        .reg_b_out_stur_q       (mem_stur_data)
    );      

//==================== MEM ========================//

    mem_datapath mem_datapath (
        .clk                    (clk),
        .alu_out                (mem_data_in),
        .wr_data                (mem_stur_data),
        .wr_en                  (mem_MemWrite),
        .rd_en                  (mem_MemRead),
        .mem_to_reg_cntrl       (mem_MemtoReg),
        .mem_to_reg_data        (fwd_mem_data)
    );

//================= STAGE REGISTERS ====================//
    mem_wr_regs mem_to_wr_registers (
        .clk                    (clk),
        .reset                  (reset),
        .data_q                 (wb_data),
        .reg_write_addr_q       (wb_addr),
        .RegWrite_q             (wb_RegWrite),
        .data_d                 (fwd_mem_data),
        .reg_write_addr_d       (mem_reg_write_addr),
        .RegWrite_d             (mem_RegWrite)
    );

//==================== WB ========================//
    //Only combinational logic that links mem to reg file



endmodule