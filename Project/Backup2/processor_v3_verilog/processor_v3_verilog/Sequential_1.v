module Sequential_1
(
	Instr,
	PCWrite,
	PC1_Load,
	PC2_Load,
	PC3_Load,
	IR_1_Load,
	IR_2_Load,
	IR_3_Load,
	IR_4_Load,
	CounterOn
);
	input	[3:0]Instr;
	output PCWrite,CounterOn,PC1_Load,PC2_Load,PC3_Load;
	output IR_1_Load,IR_2_Load,IR_3_Load,IR_4_Load;
	
	assign PCWrite = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign CounterOn = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign PC1_Load = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign PC2_Load = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign PC3_Load = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign IR_1_Load = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign IR_2_Load = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign IR_3_Load = ~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3]);
	assign IR_4_Load = 1/*~(Instr[0] & ~Instr[1] & ~Instr[2] & ~Instr[3])*/;

endmodule