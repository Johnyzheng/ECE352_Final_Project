// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module register_1bit (
	aclr,
	clock,
	data,
	enable,
	q);

	input	  aclr;
	input	  clock;
	input	[0:0]  data;
	input	  enable;
	output reg	[0:0]  q;
	
	always @(posedge clock, posedge aclr)
	begin
		if (aclr)
			q <= 1'b1;
		else if (enable)
			q <= data;
	end

endmodule