//structure of the control signals

// ALU signals
// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
`timescale 1ns/10ps

package controlPkg;

    typedef enum logic [2:0] {
        PASSB = 3'b000,
        ADD = 3'b010,
        SUB = 3'b011,
        AND = 3'b100,
        OR = 3'b101,
        XOR = 3'b110
    } aluCntrl;

    typedef struct packed {
        logic Reg2Loc;
        logic uncondBr;
        logic brTaken;
        logic MemRead;
        logic aluOrShift;
        logic MemtoReg;
        logic MemWrite;
        logic ALUSrc;
        logic RegWrite;
        aluCntrl aluControl;
        logic ImmSel;
    } cntrl;

    typedef struct packed {
        logic zero;
        logic overflow;
        logic carryOut;
        logic negative;
    } alu_flags;

endpackage : controlPkg




