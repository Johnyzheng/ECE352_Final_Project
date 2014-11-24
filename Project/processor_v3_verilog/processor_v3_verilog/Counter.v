// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module Counter(clock, reset, enable, counterOut);
//-------------Input Ports-----------------------------
	input clock ;
	input reset ;
	input enable ;
	//-------------Output Ports----------------------------
	output [15:0] counterOut ;
	//-------------Input ports Data Type-------------------
	// By rule all the input ports should be wires   
	wire clock ;
	wire reset ;
	wire enable ;
	//-------------Output Ports Data Type------------------
	// Output port can be a storage element (reg) or a wire
	reg [15:0] counterOut ;
	
	//------------Code Starts Here-------------------------
	// Since this counter is a positive edge trigged one,
	// We trigger the below block with respect to positive
	// edge of the clock.
	always @ (posedge clock or posedge reset)
	begin : COUNTER // Block Name
		// At every rising edge of clock we check if reset is active
		// If active, we load the counter output with 4'b0000
		if (reset == 1'b1) begin
			counterOut <=  #1  16'h0000;
		end
		// If enable is active, then we increment the counter
		else if (enable == 1'b1) begin
			counterOut <=  #1  counterOut + 1;
		end
	end // End of Block COUNTER
endmodule