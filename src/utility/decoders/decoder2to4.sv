`timescale 1ns/10ps

module decoder2to4 (write, addr, out);
	input logic write;
	input logic [1:0] addr;
	output logic [3:0] out;
	
	logic [1:0] invert;
	
	genvar i;
	generate
		for(i=0;i<2;i++) begin : inverters
			not #(50ps) inv (invert[i], addr[i]);
		end
	endgenerate
	
	
	and #(50ps) and0 (out[0], write, invert[0], invert[1]);
	and #(50ps) and1 (out[1], write, addr[0],  invert[1]);
	and #(50ps) and2 (out[2], write, invert[0], addr[1]);
	and #(50ps) and3 (out[3], write, addr[0],  addr[1]);

endmodule
