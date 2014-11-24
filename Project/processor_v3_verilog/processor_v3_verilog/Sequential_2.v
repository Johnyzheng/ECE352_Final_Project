module Sequential_2
(
	Instr,
	R1Sel,
	ZE5_Load,
	ZE3_Load,
	SE4_Load
);
	input	[3:0]Instr;
	output R1Sel;	
	output /*[4:0]*/ZE5_Load; 
	output /*[2:0]*/ZE3_Load;
	output /*[3:0]*/SE4_Load; 
	
	assign R1Sel = (Instr[0] & Instr[1] & Instr[2]); 
//	assign SE4_Load[0] = Instr[4];
//	assign SE4_Load[1] = Instr[5];
//	assign SE4_Load[2] = Instr[6];
//	assign SE4_Load[3] = Instr[7];
//	
//	assign ZE3_Load[0] = Instr[3];
//	assign ZE3_Load[1] = Instr[4];
//	assign ZE3_Load[2] = Instr[5];
//	
//	assign ZE5_Load[0] = Instr[3];
//	assign ZE5_Load[1] = Instr[4];
//	assign ZE5_Load[2] = Instr[5];
//	assign ZE5_Load[3] = Instr[6];
//	assign ZE5_Load[4] = Instr[7];
	assign	ZE5_Load = 1'b1;
	assign	SE4_Load = 1'b1;
	assign	ZE3_Load = 1'b1;

endmodule