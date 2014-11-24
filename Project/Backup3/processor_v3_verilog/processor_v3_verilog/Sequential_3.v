module Sequential_3(
	Instr,
	NwireOut,
	ZwireOut,
	ALU1,
	ALU2,
	ALUOp,
	MemRead,
	MemWrite,
	R1R2Load,
	PCSel,
	WBinWrite,
	ALU3,
	FlagWrite
);

	input	[3:0]Instr;
	input NwireOut,ZwireOut;
	output	ALU1,MemRead,MemWrite,R1R2Load,PCSel,WBinWrite,ALU3, FlagWrite;
	output [2:0] ALU2,ALUOp;
	reg	[2:0]ALU2,ALUOp;
	reg 	ALU1,ALU3,FlagWrite,MemWrite,MemRead;
	
	//MemWrite Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: MemWrite <= 1'b0;		//Load
			4'b0010: MemWrite <= 1'b1;		//Store
			4'b0100: MemWrite <= 1'b0;		//ADD
			4'b0110: MemWrite <= 1'b0;		//SUB
			4'b1000: MemWrite <= 1'b0;		//NAND
			4'b0111: MemWrite <= 1'b0;		//ORI
			4'b1111: MemWrite <= 1'b0;		//ORI
			4'b0011: MemWrite <= 1'b0;		//Shift
			4'b1011: MemWrite <= 1'b0;		//Shift
			4'b0101: MemWrite <= 1'b0;		//BZ
			4'b1001: MemWrite <= 1'b0;		//BNZ
			4'b1101: MemWrite <= 1'b0;		//BPZ
			4'b0001: MemWrite <= 1'b0;		//Stop
			4'b1010: MemWrite <= 1'b0;		//NOP
			default: MemWrite <= 1'b0;
		endcase
	end

	//MemRead Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: MemRead <= 1'b1;		//Load
			4'b0010: MemRead <= 1'b0;		//Store
			4'b0100: MemRead <= 1'b0;		//ADD
			4'b0110: MemRead <= 1'b0;		//SUB
			4'b1000: MemRead <= 1'b0;		//NAND
			4'b0111: MemRead <= 1'b0;		//ORI
			4'b1111: MemRead <= 1'b0;		//ORI
			4'b0011: MemRead <= 1'b0;		//Shift
			4'b1011: MemRead <= 1'b0;		//Shift
			4'b0101: MemRead <= 1'b0;		//BZ
			4'b1001: MemRead <= 1'b0;		//BNZ
			4'b1101: MemRead <= 1'b0;		//BPZ
			4'b0001: MemRead <= 1'b0;		//Stop
			4'b1010: MemRead <= 1'b0;		//NOP
			default: MemRead <= 1'b0;
		endcase
	end
	
	
	//ALU2 Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: ALU2 <= 3'b000;		//Load
			4'b0010: ALU2 <= 3'b000;		//Store
			4'b0100: ALU2 <= 3'b000;		//ADD
			4'b0110: ALU2 <= 3'b000;		//SUB
			4'b1000: ALU2 <= 3'b000;		//NAND
			4'b0111: ALU2 <= 3'b011;		//ORI
			4'b1111: ALU2 <= 3'b011;		//ORI
			4'b0011: ALU2 <= 3'b100;		//Shift
			4'b1011: ALU2 <= 3'b100;		//Shift
			4'b0101: ALU2 <= 3'b010;		//BZ
			4'b1001: ALU2 <= 3'b010;		//BNZ
			4'b1101: ALU2 <= 3'b010;		//BPZ
			4'b0001: ALU2 <= 3'b000;		//Stop
			4'b1010: ALU2 <= 3'b000;		//NOP
			default: ALU2 <= 3'b000;
		endcase
	end
	
	
	//ALUOp Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: ALUOp <= 3'b000;		//Load
			4'b0010: ALUOp <= 3'b000;		//Store
			4'b0100: ALUOp <= 3'b000;		//ADD
			4'b0110: ALUOp <= 3'b001;		//SUB
			4'b1000: ALUOp <= 3'b011;		//NAND
			4'b0111: ALUOp <= 3'b010;		//ORI
			4'b1111:	ALUOp <= 3'b010;		//ORI
			4'b0011: ALUOp <= 3'b100;		//Shift	
			4'b1011: ALUOp <= 3'b100;		//Shift
			4'b0101: ALUOp <= 3'b000;		//BZ
			4'b1001: ALUOp <= 3'b000;		//BNZ
			4'b1101: ALUOp <= 3'b000;		//BPZ
			4'b0001: ALUOp <= 3'b000;		//Stop
			4'b1010: ALUOp <= 3'b000;		//NOP
			default: ALUOp <= 3'b000;
		endcase
	end
	
	//ALU1 Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: ALU1 <= 1'b1;		//Load
			4'b0010: ALU1 <= 1'b1;		//Store
			4'b0100: ALU1 <= 1'b1;		//ADD
			4'b0110: ALU1 <= 1'b1;		//SUB
			4'b1000: ALU1 <= 1'b1;		//NAND
			4'b0111: ALU1 <= 1'b1;		//ORI
			4'b1111: ALU1 <= 1'b1;		//ORI
			4'b0011: ALU1 <= 1'b1;		//Shift	
			4'b1011:	ALU1 <= 1'b1;		//Shift	
			4'b0101: ALU1 <= 1'b0;		//BZ
			4'b1001: ALU1 <= 1'b0;		//BNZ
			4'b1101: ALU1 <= 1'b0;		//BPZ
			4'b0001: ALU1 <= 1'b1;		//Stop
			4'b1010: ALU1 <= 1'b1;		//NOP
			default: ALU1 <= 1'b1;
		endcase
	end

	//ALU3 Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: ALU3 <= 1'b1;		//Load
			4'b0010: ALU3 <= 1'b0;		//Store
			4'b0100: ALU3 <= 1'b0;		//ADD
			4'b0110: ALU3 <= 1'b0;		//SUB
			4'b1000: ALU3 <= 1'b0;		//NAND
			4'b0111: ALU3 <= 1'b0;		//ORI
			4'b1111:	ALU3 <= 1'b0;		//ORI
			4'b0011: ALU3 <= 1'b0;		//Shift	
			4'b1011:	ALU3 <= 1'b0;		//Shift
			4'b0101: ALU3 <= 1'b0;		//BZ
			4'b1001: ALU3 <= 1'b0;		//BNZ
			4'b1101: ALU3 <= 1'b0;		//BPZ
			4'b0001: ALU3 <= 1'b0;		//Stop
			4'b1010: ALU3 <= 1'b0;		//NOP
			default: ALU3 <= 1'b0;
		endcase
	end
	
	//FlagWrite Assignment
	always @(*)
	begin
		case (Instr)
			4'b0000: FlagWrite <= 1'b0;		//Load
			4'b0010: FlagWrite <= 1'b0;		//Store
			4'b0100: FlagWrite <= 1'b1;		//ADD
			4'b0110: FlagWrite <= 1'b1;		//SUB
			4'b1000: FlagWrite <= 1'b1;		//NAND
			4'b0111: FlagWrite <= 1'b1;		//ORI
			4'b1111:	FlagWrite <= 1'b1;		//ORI
			4'b0011: FlagWrite <= 1'b1;		//Shift
			4'b1011: FlagWrite <= 1'b1;		//Shift
			4'b0101: FlagWrite <= 1'b0;		//BZ
			4'b1001: FlagWrite <= 1'b0;		//BNZ
			4'b1101: FlagWrite <= 1'b0;		//BPZ
			4'b0001: FlagWrite <= 1'b0;		//Stop
			4'b1010: FlagWrite <= 1'b0;		//NOP
			default: FlagWrite <= 1'b0;
		endcase
	end
			
					 
assign	R1R2Load = 1'b1;
assign	WBinWrite = 1'b1;

assign	PCSel = ~((ZwireOut & Instr[0] & ~Instr[1] & Instr[2] & ~Instr[3]) | 
						(~ZwireOut & Instr[0] & ~Instr[1] & ~Instr[2] & Instr[3]) | 
						(~NwireOut & Instr[0] & ~Instr[1] & Instr[2] & Instr[3]));

endmodule