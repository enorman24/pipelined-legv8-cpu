`timescale 1ns/10ps

module forwarding_control (
    input logic [4:0] ex_wr_reg,
    input logic ex_wr_en,

    input logic [4:0] mem_wr_reg,
    input logic mem_wr_en,

    input logic [4:0] rm,
    input logic [4:0] rn,
    input logic [4:0] rd,
    input logic reg2loc,

    output logic forwarding_source_a, //mux input for the forwarding source to a (0 is from ex)
    output logic forwarding_source_b, //mux input for the forwarding source to b (0 is from ex)
    output logic forwarding_a_en, //mux input for the forwarding logic to a
    output logic forwarding_b_en //mux input for the forwarding logic to b
);
    logic [4:0] in_b, in_a;

    assign in_a = rn;
    
    //deciding what the selected address for data b is
    always_comb begin
        in_b = rd;
        if(reg2loc) begin
            in_b = rm;
        end
    end

    assign forwarding_source_a = !(ex_wr_en && (in_a == ex_wr_reg));
    assign forwarding_source_b = !(ex_wr_en && (in_b == ex_wr_reg));


    assign forwarding_a_en = (((ex_wr_en && (in_a == ex_wr_reg)) || (mem_wr_en && (in_a == mem_wr_reg))) && (in_a != 5'b11111));
    assign forwarding_b_en = (((ex_wr_en && (in_b == ex_wr_reg)) || (mem_wr_en && (in_b == mem_wr_reg))) && (in_b != 5'b11111));

endmodule