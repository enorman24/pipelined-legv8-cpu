`timescale 1ns/10ps

module decoder5to32 (write, addr, out);
	input logic write;
	input logic [4:0] addr;
	output logic [31:0] out;
	logic [7:0] temp;
	
	decoder3to8 big (.write(write), .addr(addr[4:2]), .out(temp));
	
	genvar i;
	generate
		for(i=0; i<8; i++) begin : twotofour
			decoder2to4 dec2_4 (.write(temp[i]), .addr(addr[1:0]), .out(out[((i*4)+3):(i*4)]));
		end
	endgenerate
	

endmodule	

