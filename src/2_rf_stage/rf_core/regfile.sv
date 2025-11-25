`timescale 1ns/10ps

module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input logic RegWrite, clk;
	input logic [4:0] ReadRegister1, ReadRegister2;
	input logic [4:0] WriteRegister;
	input logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	logic [31:0] decoderToReg;
	logic [63:0] regOut [0:31];
	logic [31:0] muxIn [0:63];


	
	decoder5to32 decoder (.write(RegWrite), .addr(WriteRegister), .out(decoderToReg));
	
	genvar i;
	generate
		for(i=0; i<31; i++) begin : registers
			register registernum (.clk(clk), .writeData(WriteData), .writeEn(decoderToReg[i]), .readData(regOut[i]));
		end
	endgenerate
	assign regOut[31] = 64'b0;
	genvar j, k;
	generate
		for(j=0; j<64; j++) begin : muxs
			for(k=0; k<32; k++) begin : arrays
				assign muxIn[j][k] = regOut[k][j];
			end
			mux32_1 firstmux  (.sel(ReadRegister1), .in(muxIn[j]), .out(ReadData1[j]));
			mux32_1 secondmux (.sel(ReadRegister2), .in(muxIn[j]), .out(ReadData2[j]));
		end
	endgenerate
endmodule