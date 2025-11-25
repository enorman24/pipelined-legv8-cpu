`timescale 1ns/10ps

import controlPkg::*;

module ex_datapath (    
    input logic [63:0] data_a,
    input logic [63:0] data_b,
    input logic [5:0] shamt,

    //CONTROL
    input aluCntrl alu_op,
    input logic shift_instr,

    output logic [63:0] ex_data_out,
    output alu_flags flags
);
    import controlPkg::*; //alucntrl and flags typedefs

    logic [63:0] alu_data_out, shifter_data_out;

    //=========== ALU ================//
    alu alu (
        .A              (data_a), 
        .B              (data_b), 
        .cntrl          (alu_op), //have to add this control logic
        .result         (alu_data_out),
        .negative       (flags.negative),
        .zero           (flags.zero), 
        .overflow       (flags.overflow), 
        .carry_out      (flags.carryOut)
    );

    //=========== SHIFTER ================//
    shifter shift (
		.value	 		(data_a),
		.direction		(1'b1), 
		.distance 		(shamt),
		.result	 		(shifter_data_out)
	);

    //=========== SELECT SHIFTER OUTPUT IF SHIFT ================//
    mux2_1_64 shiftOrAluMux (
        .sel            (shift_instr), 
        .a              (alu_data_out),
        .b              (shifter_data_out),
        .out            (ex_data_out)
    );

endmodule