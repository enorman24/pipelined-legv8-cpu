`timescale 1ns/10ps

module register(clk, writeData, writeEn, readData);
	input logic clk, writeEn;
	input logic [63:0] writeData;
	output logic [63:0] readData;
	
	genvar i;
	generate
		for(i=0; i<64; i++) begin : regFFnum
			reg_FF regFF (.en(writeEn), .write(writeData[i]), .clk(clk), .reset(1'b0), .out(readData[i]));
		end
	endgenerate


endmodule