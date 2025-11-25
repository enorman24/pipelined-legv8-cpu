`timescale 1ns/10ps

module decoder3to8 (write, addr, out);
	input logic write;
	input logic [2:0] addr;
	output logic [7:0] out;
	
	logic [2:0] invert;
	
	genvar i;
	generate
		for(i=0;i<3;i++) begin : inverters
			not #(50ps) inv (invert[i], addr[i]);
		end
	endgenerate
	
	
	and #(50ps) and0 (out[0], write, invert[0], invert[1], invert[2]);
	and #(50ps) and1 (out[1], write, addr[0],  invert[1], invert[2]);
	and #(50ps) and2 (out[2], write, invert[0], addr[1],  invert[2]);
	and #(50ps) and3 (out[3], write, addr[0],  addr[1],   invert[2]);
	and #(50ps) and4 (out[4], write, invert[0], invert[1], addr[2]);
	and #(50ps) and5 (out[5], write, addr[0],  invert[1], addr[2]);
	and #(50ps) and6 (out[6], write, invert[0], addr[1],  addr[2]);
	and #(50ps) and7 (out[7], write, addr[0],  addr[1],   addr[2]);


endmodule	
