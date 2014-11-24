module Sequential_4(
	Instr,
	RFWrite,
	regwSel
);

	input	[3:0]Instr;
	output	RFWrite;
	output	regwSel;
	reg	RFWrite,regwSel;
	
	//RFWrite Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: RFWrite <= 1'b1;		//Load
			4'b0010: RFWrite <= 1'b0;		//Store
			4'b0100: RFWrite <= 1'b1;		//ADD
			4'b0110: RFWrite <= 1'b1;		//SUB
			4'b1000: RFWrite <= 1'b1;		//NAND
			4'b0111: RFWrite <= 1'b1;		//ORI
			4'b1111: RFWrite <= 1'b1;		//ORI
			4'b0011: RFWrite <= 1'b1;		//Shift	
			4'b1011:	RFWrite <= 1'b1;		//Shift
			4'b0101: RFWrite <= 1'b0;		//BZ
			4'b1001: RFWrite <= 1'b0;		//BNZ
			4'b1101: RFWrite <= 1'b0;		//BPZ
			4'b0001: RFWrite <= 1'b0;		//Stop
			4'b1010: RFWrite <= 1'b0;		//NOP
			default: RFWrite <= 1'b0;
		endcase
	end
	
	//regwSel Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: regwSel <= 1'b0;		//Load
			4'b0010: regwSel <= 1'b0;		//Store
			4'b0100: regwSel <= 1'b0;		//ADD
			4'b0110: regwSel <= 1'b0;		//SUB
			4'b1000: regwSel <= 1'b0;		//NAND
			4'b0111: regwSel <= 1'b1;		//ORI
			4'b1111: regwSel <= 1'b1;		//ORI
			4'b0011: regwSel <= 1'b0;		//Shift	
			4'b1011:	regwSel <= 1'b0;		//Shift
			4'b0101: regwSel <= 1'b0;		//BZ
			4'b1001: regwSel <= 1'b0;		//BNZ
			4'b1101: regwSel <= 1'b0;		//BPZ
			4'b0001: regwSel <= 1'b0;		//Stop
			4'b1010: regwSel <= 1'b0;		//NOP
			default: regwSel <= 1'b0;
		endcase
	end
	
	
//	assign RFWrite = ~ ( (~Instr[0] & Instr[1] & ~Instr[2] & ~Instr[3]) |
//					 (Instr[0] & ~Instr[1] & ~Instr[2] & Instr[3]) | 
//					 (Instr[0] & ~Instr[1] & Instr[2] & ~Instr[3]) |
//					 (~Instr[0] & ~Instr[1] & Instr[2] & ~Instr[3])) ;
					
endmodule