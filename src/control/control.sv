`timescale 1ns/10ps
// import InstructionTypesPkg::*;
import controlPkg::*;

module control (
    input [10:0] opcode,
    input logic clk, 
    input logic reset,
    input alu_flags flags,
    input logic zero_check,
    input logic set_flags_in,

    output logic set_flags_out,
    output cntrl controlsigs
);

    alu_flags currFlags;
    logic setFlags;
    

    always_comb begin
        controlsigs = '0;
        set_flags_out = 1'b0;
        unique casez (opcode)
            11'b1001000100?: begin //ADDI
                controlsigs.ALUSrc = 1;
                controlsigs.RegWrite = 1;
                controlsigs.aluControl = ADD;
            end
            11'b10101011000: begin //ADDS
                controlsigs.Reg2Loc = 1;
                controlsigs.ALUSrc = 0;
                controlsigs.RegWrite = 1;
                controlsigs.aluControl = ADD;
                set_flags_out = 1'b1;
            end
            11'b10001010000: begin //AND
                controlsigs.Reg2Loc = 1;
                controlsigs.RegWrite = 1;
                controlsigs.aluControl = AND;
            end
            11'b000101?????: begin //B
                controlsigs.uncondBr = 1;
                controlsigs.brTaken = 1;
            end
            11'b01010100???: begin //B.LT
                if(set_flags_in) begin
                    controlsigs.brTaken = (flags.negative != flags.overflow);
                end else begin
                    controlsigs.brTaken = (currFlags.negative != currFlags.overflow);
                end
                controlsigs.aluControl = SUB;
            end
            11'b10110100???: begin //CBZ
                controlsigs.brTaken = zero_check;
                controlsigs.aluControl = PASSB;
            end
            11'b11001010000: begin //XOR
                controlsigs.Reg2Loc = 1;
                controlsigs.RegWrite = 1;
                controlsigs.aluControl = XOR;
            end
            11'b11111000010: begin //LDUR
                controlsigs.MemRead = 1;
                controlsigs.MemtoReg = 1;
                controlsigs.ALUSrc = 1;
                controlsigs.RegWrite = 1;
                controlsigs.aluControl = ADD;
                controlsigs.ImmSel = 1;
            end
            11'b11010011010: begin //LSR
                controlsigs.RegWrite = 1;
                controlsigs.aluOrShift = 1;
            end
            11'b11111000000: begin //STUR
                controlsigs.MemWrite = 1;
                controlsigs.ALUSrc = 1;
                controlsigs.aluControl = ADD;
                controlsigs.ImmSel = 1;
            end
            11'b11101011000: begin //SUBS
                controlsigs.Reg2Loc = 1;
                controlsigs.RegWrite = 1;
                controlsigs.aluControl = SUB;
                set_flags_out = 1'b1;
            end
            default: controlsigs = '0;
        endcase
    end

    always_ff @(posedge clk) begin
        if(reset) begin
            currFlags <= '0;
        end else if(set_flags_in) begin
            currFlags <= flags;
        end
    end

endmodule