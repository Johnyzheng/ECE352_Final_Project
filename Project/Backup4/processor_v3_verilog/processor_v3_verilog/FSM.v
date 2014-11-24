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
	reset, instr, clock, next_instr,next_next_instr,
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
	IR2Sel,
	CounterOn
);
	input	[7:0] instr, next_instr, next_next_instr;
	input	N, Z;
	input	reset, clock;
	output	reg	PCWrite, PC1_Load, PC2_Load, PC3_Load;
	output	reg	IR_1_Load, IR_2_Load, IR_3_Load, IR_4_Load;
	output	reg	CounterOn, IR1Sel, IR2Sel; 		//Control to turn on the counter, active high
	//output	[3:0] state;
	
	reg [3:0]	state;

	
	
	// state constants (note: asn = add/sub/nand, asnsh = add/sub/nand/shift)
	parameter [3:0] reset_s = 0, c1 = 1, c2_br = 2, c3_br = 3, c4_br = 4, c2_stop = 5, c2_data = 6, c3_data = 7, c2_data_2 = 8;
	
	// determines the next state based upon the current state; supports
	// asynchronous reset
	always @(posedge clock or posedge reset)
	begin
		if (reset) state = reset_s;
		else
		begin
			case(state)
				reset_s:	state = c1; 		// reset state
				c1:	begin				// cycle 2
							if(instr[3:0] == 4'b0101 | instr[3:0] == 4'b1001 | instr[3:0] == 4'b1101) state = c2_br;
							else if (instr[3:0] == 4'b0001)	state = c2_stop;
					
									/*LOAD,ADD,SUB,NAND,SHIFT -> STORE,LOAD,ADD,SUB,NAND*/
							else if ((((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'b0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) &
									(instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) & 
									(instr[7:6] == next_instr[7:6] | instr[5:4] == next_instr[7:6])) /**/ |
									
									/*LOAD,ADD,SUB,NAND,SHIFT -> SHIFT*/
									(((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'b0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
									& (instr[2:0] == 3'b011)) & (instr[7:6] == next_instr[7:6])) /**/ |
									
									/*ORI -> STORE,LOAD,ADD,SUB,NAND*/
									(((next_instr[2:0] == 3'b111) 
									& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
									& (instr[7:6] == 2'b01 | instr[5:4] == 2'b01)) /**/ |
									
									/*ORI -> SHIFT*/
									(((next_instr[2:0] == 3'b111) 
									& (instr[2:0] == 3'b011)) & (instr[7:6] == 2'b01)) /**/ |
									
									/*LOAD,ADD,SUB,NAND,SHIFT -> ORI*/
									(((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'b0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
									& (instr[2:0] == 3'b111)) & (next_instr[7:6] == 2'b01)) | 
									
									/*ORI -> ORI*/
									(((next_instr[2:0] == 3'b111) & (instr[2:0] == 3'b111))))
									begin
										state = c2_data;
									end
							else if ((((next_next_instr[3:0] == 4'b0000 | next_next_instr[3:0] == 4'b0100 | next_next_instr[3:0] == 4'b0110 | next_next_instr[3:0] == 4'b1000 | next_next_instr[2:0] == 3'b011) &
									(instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) & 
									(instr[7:6] == next_next_instr[7:6] | instr[5:4] == next_next_instr[7:6])) /**/ |
									
									/*LOAD,ADD,SUB,NAND,SHIFT -> SHIFT*/
									(((next_next_instr[3:0] == 4'b0000 | next_next_instr[3:0] == 4'b0100 | next_next_instr[3:0] == 4'b0110 | next_next_instr[3:0] == 4'b1000 | next_next_instr[2:0] == 3'b011) 
									& (instr[2:0] == 3'b011)) & (instr[7:6] == next_next_instr[7:6])) /**/ |
									
									/*ORI -> STORE,LOAD,ADD,SUB,NAND*/
									(((next_next_instr[2:0] == 3'b111) 
									& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
									& (instr[7:6] == 2'b01 | instr[5:4] == 2'b01)) /**/ |
									
									/*ORI -> SHIFT*/
									(((next_next_instr[2:0] == 3'b111) 
									& (instr[2:0] == 3'b011)) & (instr[7:6] == 2'b01)) /**/ |
									
									/*LOAD,ADD,SUB,NAND,SHIFT -> ORI*/
									(((next_next_instr[3:0] == 4'b0000 | next_next_instr[3:0] == 4'b0100 | next_next_instr[3:0] == 4'b0110 | next_next_instr[3:0] == 4'b1000 | next_next_instr[2:0] == 3'b011) 
									& (instr[2:0] == 3'b111)) & (next_next_instr[7:6] == 2'b01)) | 
									
									/*ORI -> ORI*/
									(((next_next_instr[2:0] == 3'b111) & (instr[2:0] == 3'b111))))
							state = c2_data_2;
							else state = c1;
						end
				c2_br:	state = c3_br;	
				c3_br:	state = c4_br;
				c2_data: state = c3_data;
				c3_data:	state = c1;
				c2_data_2: state = c1;
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
					IR2Sel = 1;
				end					
			c1: 		//control = 19'b1110100000010000000;
				begin
					if (instr[3:0] == 4'b0101 | instr[3:0] == 4'b1001 | instr[3:0] == 4'b1101)	//For All branches
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
							IR2Sel = 1;
						end
					
					else if (instr[3:0] != 4'b0001)
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
							IR2Sel = 1;
						end
						
					else if 
						/*LOAD,ADD,SUB,NAND,SHIFT -> STORE,LOAD,ADD,SUB,NAND*/
						((((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'b0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
						& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
						& (instr[7:6] == next_instr[7:6] | instr[5:4] == next_instr[7:6])) /**/ |
						
						/*LOAD,ADD,SUB,NAND,SHIFT -> SHIFT*/
						(((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'b0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
						& (instr[2:0] == 3'b011)) & (instr[7:6] == next_instr[7:6])) /**/ |
						
						/*ORI -> STORE,LOAD,ADD,SUB,NAND*/
						(((next_instr[2:0] == 3'b111) 
						& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
						& (instr[7:6] == 2'b01 | instr[5:4] == 2'b01)) /**/ |
						
						/*ORI -> SHIFT*/
						(((next_instr[2:0] == 3'b111) 
						& (instr[2:0] == 3'b011)) & (instr[7:6] == 2'b01)) /**/ |
						
						/*LOAD,ADD,SUB,NAND,SHIFT -> ORI*/
						(((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'b0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
						& (instr[2:0] == 3'b111)) & (next_instr[7:6] == 2'b01)) | 
						
						/*ORI -> ORI*/
						(((next_instr[2:0] == 3'b111) & (instr[2:0] == 3'b111))))
						begin
							PCWrite = 1;			//Prevent PC from incrementing immediately
							PC1_Load = 1;
							PC2_Load = 1;
							PC3_Load = 1;
							IR_1_Load = 1;
							IR_2_Load = 1;
							IR_3_Load = 1;
							IR_4_Load = 1;
							CounterOn =	0;
							IR1Sel = 1;				//STOP IR1_reg from getting new values
							IR2Sel = 0;
						end
						
					else if
						((((next_next_instr[3:0] == 4'b0000 | next_next_instr[3:0] == 4'b0100 | next_next_instr[3:0] == 4'b0110 | next_next_instr[3:0] == 4'b1000 | next_next_instr[2:0] == 3'b011) &
						(instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) & 
						(instr[7:6] == next_next_instr[7:6] | instr[5:4] == next_next_instr[7:6])) /**/ |
						
						/*LOAD,ADD,SUB,NAND,SHIFT -> SHIFT*/
						(((next_next_instr[3:0] == 4'b0000 | next_next_instr[3:0] == 4'b0100 | next_next_instr[3:0] == 4'b0110 | next_next_instr[3:0] == 4'b1000 | next_next_instr[2:0] == 3'b011) 
						& (instr[2:0] == 3'b011)) & (instr[7:6] == next_next_instr[7:6])) /**/ |
						
						/*ORI -> STORE,LOAD,ADD,SUB,NAND*/
						(((next_next_instr[2:0] == 3'b111) 
						& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
						& (instr[7:6] == 2'b01 | instr[5:4] == 2'b01)) /**/ |
						
						/*ORI -> SHIFT*/
						(((next_next_instr[2:0] == 3'b111) 
						& (instr[2:0] == 3'b011)) & (instr[7:6] == 2'b01)) /**/ |
						
						/*LOAD,ADD,SUB,NAND,SHIFT -> ORI*/
						(((next_next_instr[3:0] == 4'b0000 | next_next_instr[3:0] == 4'b0100 | next_next_instr[3:0] == 4'b0110 | next_next_instr[3:0] == 4'b1000 | next_next_instr[2:0] == 3'b011) 
						& (instr[2:0] == 3'b111)) & (next_next_instr[7:6] == 2'b01)) | 
						
						/*ORI -> ORI*/
						(((next_next_instr[2:0] == 3'b111) & (instr[2:0] == 3'b111))))
						begin
							PCWrite = 1;			//Prevent PC from incrementing immediately
							PC1_Load = 1;
							PC2_Load = 1;
							PC3_Load = 1;
							IR_1_Load = 1;
							IR_2_Load = 1;
							IR_3_Load = 1;
							IR_4_Load = 1;
							CounterOn =	0;
							IR1Sel = 1;				//STOP IR1_reg from getting new values
							IR2Sel = 0;
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
							IR2Sel = 1;
						end
				end
			c2_data:
				begin
					PCWrite = 0;			//Prevent PC from incrementing immediately
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 0;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 1;				//STOP IR1_reg from getting new values
					IR2Sel = 0;
				end
			c3_data:
				begin
					PCWrite = 0;			//Prevent PC from incrementing immediately
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 0;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 1;				//STOP IR1_reg from getting new values\
					IR2Sel = 0;
				end
			c2_data_2:
				begin
					PCWrite = 0;			//Prevent PC from incrementing immediately
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 0;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 1;				//STOP IR1_reg from getting new values\
					IR2Sel = 0;
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
					IR2Sel = 1;
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
					IR2Sel = 1;
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
						IR1Sel = 0;
						IR2Sel = 1;
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
					IR2Sel = 0;
				end
			default:	//control = 19'b0000000000000000000;
				begin
					PCWrite = 1;
					PC1_Load = 1;
					PC2_Load = 1;
					PC3_Load = 1;
					IR_1_Load = 1;
					IR_2_Load = 1;
					IR_3_Load = 1;
					IR_4_Load = 1;
					CounterOn =	0;
					IR1Sel = 1;
					IR2Sel = 1;
				end
		endcase
	end
	
//	/*LOAD,ADD,SUB,NAND,SHIFT -> STORE,LOAD,ADD,SUB,NAND*/
//	((((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
//	& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
//	& (instr[7:6] == next_instr[7:6] | instr[5:4] == next_instr[7:6])) /**/ |
//	
//	/*LOAD,ADD,SUB,NAND,SHIFT -> SHIFT*/
//	(((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
//	& (instr[2:0] == 3'b011)) & (instr[7:6] == next_instr[7:6])) /**/ |
//	
//	/*ORI -> STORE,LOAD,ADD,SUB,NAND*/
//	(((next_instr[2:0] == 3'b111) 
//	& (instr[3:0] == 4'b0000 | instr[3:0] == 4'b0010 | instr[3:0] == 4'b0100 | instr[3:0] == 4'b0110 | instr[3:0] == 4'b1000)) 
//	& (instr[7:6] == 2'b01 | instr[5:4] == 2'b01)) /**/ |
//	
//	/*ORI -> SHIFT*/
//	(((next_instr[2:0] == 3'b111) 
//	& (instr[2:0] == 3'b011)) & (instr[7:6] == 2'b01)) /**/ |
//	
//	/*LOAD,ADD,SUB,NAND,SHIFT -> ORI*/
//	(((next_instr[3:0] == 4'b0000 | next_instr[3:0] == 4'0100 | next_instr[3:0] == 4'b0110 | next_instr[3:0] == 4'b1000 | next_instr[2:0] == 3'b011) 
//	& (instr[2:0] == 3'b111)) & (next_instr[7:6] == 2'b01)) | 
//	
//	/*ORI -> ORI*/
//	(((next_instr[2:0] == 3'b111) & (instr[2:0] == 3'b111))))
	
endmodule
