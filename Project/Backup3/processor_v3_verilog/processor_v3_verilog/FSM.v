// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	control processor's datapath
// 
// Input(s):	1. instr: input is used to determine states
//				2. N: if branches, input is used to determine if
//					  negative condition is true
//				3. Z: if branches, input is used to determine if 
//					  zero condition is true
//
// Output(s):	control signals
//
//				** More detail can be found on the course note under
//				   "Multi-Cycle Implementation: The Control Unit"
//
// ---------------------------------------------------------------------

module FSM
(
	reset, instr, clock,
	N, Z,
	PCWrite,
	PC1_Load,
	PC2_Load,
	PC3_Load,
	IR_1_Load,
	IR_2_Load,
	IR_3_Load,
	IR_4_Load,
	IR1Sel,
	CounterOn
);
	input	[3:0] instr;
	input	N, Z;
	input	reset, clock;
	output	reg	PCWrite, PC1_Load, PC2_Load, PC3_Load;
	output	reg	IR_1_Load, IR_2_Load, IR_3_Load, IR_4_Load;
	output	reg	CounterOn, IR1Sel; 		//Control to turn on the counter, active high
	//output	[3:0] state;
	
	reg [3:0]	state;

	
	
	// state constants (note: asn = add/sub/nand, asnsh = add/sub/nand/shift)
	parameter [3:0] reset_s = 0, c1 = 1, c2_br = 2, c3_br = 3, c4_br = 4, c2_stop = 5;
	
	// determines the next state based upon the current state; supports
	// asynchronous reset
	always @(posedge clock or posedge reset)
	begin
		if (reset) state = reset_s;
		else
		begin
			case(state)
				reset_s:	state = c1; 		// reset state
				c1:			begin				// cycle 2
								if(instr == 4'b0101 | instr == 4'b1001 | instr == 4'b1101) state = c2_br;
								else if (instr == 4'b0001)	state = c2_stop;
								else state = c1;
							end
				c2_br:	state = c3_br;	
				c3_br:	state = c4_br;
				c4_br:	state = c1;
				c2_stop:	state = c2_stop;
			endcase
		end
	end

	// sets the control sequences based upon the current state and instruction
	always @(*)
	begin
		case (state)
			reset_s:	//control = 19'b0000000000000000000;
				begin
					PCWrite = 0;
					PC1_Load = 0;
					PC2_Load = 0;
					PC3_Load = 0;
					IR_1_Load = 0;
					IR_2_Load = 0;
					IR_3_Load = 0;
					IR_4_Load = 0;
					CounterOn =	0;
					IR1Sel = 1;
				end					
			c1: 		//control = 19'b1110100000010000000;
				begin
					if (instr == 4'b0101 | instr == 4'b1001 | instr == 4'b1101)	//For All branches
						begin
							PCWrite = 0;			//Prevent PC from incrementing immediately
							PC1_Load = 1;
							PC2_Load = 1;
							PC3_Load = 1;
							IR_1_Load = 1;
							IR_2_Load = 1;
							IR_3_Load = 1;
							IR_4_Load = 1;
							CounterOn =	1;
							IR1Sel = 1;
						end
					
					else
						begin
							PCWrite = 1;
							PC1_Load = 1;
							PC2_Load = 1;
							PC3_Load = 1;
							IR_1_Load = 1;
							IR_2_Load = 1;
							IR_3_Load = 1;
							IR_4_Load = 1;
							CounterOn =	1;
							IR1Sel = 1;
						end
				end	
			c2_br: 		//control = 19'b0000000100000000000;
				begin
					PCWrite = 0;
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 1;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 0;
				end
			c3_br: 		//control = 19'b0000000100000000000;
				begin
					PCWrite = 0;
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 1;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 0;
				end
			c4_br:
					begin
						PCWrite = 1;
						PC1_Load = 1;
						PC2_Load = 1;
						PC3_Load = 1;
						IR_1_Load = 1;
						IR_2_Load = 1;
						IR_3_Load = 1;
						IR_4_Load = 1;
						CounterOn =	1;
						IR1Sel = 1;
					end
			c2_stop: 		//control = 19'b0000000100000000000;
				begin
					PCWrite = 0;
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 1;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 0;
				end
			default:	//control = 19'b0000000000000000000;
				begin
					PCWrite = 0;
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 1;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 0;
				end
		endcase
	end
	
endmodule
