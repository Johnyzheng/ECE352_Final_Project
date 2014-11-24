`timescale 1 ps / 1 ps

module mux2to1_8bit(
	data0x,
	data1x,
	sel,
	result);

	input	[7:0]  data0x;
	input	[7:0]  data1x;
	input	  sel;
	output	[7:0]  result;

	assign result = sel ? data1x : data0x;

endmodule

