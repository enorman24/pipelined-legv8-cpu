`timescale 1ns/10ps

module mem_datapath (
    input logic clk,
    input logic [63:0] alu_out,
    input logic [63:0] wr_data,

    //CONTROL SIGS
    input logic wr_en,
    input logic rd_en,
    input logic mem_to_reg_cntrl, //if 0 the alu out goes to reg

    //output to data forwarding and WB
    output logic [63:0] mem_to_reg_data
); 

    logic [63:0] mem_rd_data;

    //===============DATA MEMORY================//
    datamem datamemory (
        .address        (alu_out),
        .write_enable   (wr_en),
        .read_enable    (rd_en),
        .write_data     (wr_data),
        .clk            (clk),
        .xfer_size      (4'b1000),
        .read_data      (mem_rd_data)
    );
    //============MEM TO REG SELECT===========//
    mux2_1_64 mem_mux (
        .sel            (mem_to_reg_cntrl), 
        .a              (alu_out), 
        .b              (mem_rd_data), 
        .out            (mem_to_reg_data)
    );
endmodule