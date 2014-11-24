// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	a simple processor which operates basic mathematical
//					operations as follow:
//					(1)loading, (2)storing, (3)adding, (4)subtracting,
//					(5)shifting, (6)oring, (7)branch if zero,
//					(8)branch if not zero, (9)branch if positive zero
//					 
// Input(s):		1. KEY0(reset): clear all values from registers,
//									reset flags condition, and reset
//									control FSM
//					2. KEY1(clock): manual clock controls FSM and all
//									synchronous components at every
//									positive clock edge
//
//
// Output(s):		1. HEX Display: display registers value K3 to K1
//									in hexadecimal format
//
//					** For more details, please refer to the document
//					   provided with this implementation
//
// ---------------------------------------------------------------------

module multicycle
(
SW, KEY, HEX0, HEX1, HEX2, HEX3,
HEX4, HEX5, HEX6, HEX7, LEDG, LEDR
);

// ------------------------ PORT declaration ------------------------ //
input	[1:0] KEY;
input [2:0] SW;
output	[6:0] HEX0, HEX1, HEX2, HEX3;
output	[6:0] HEX4, HEX5, HEX6, HEX7;
output	[7:0] LEDG;
output	[17:0] LEDR;

// ------------------------- Registers/Wires ------------------------ //
wire	clock, reset;
wire	IRLoad, MDRLoad, MemRead, MemWrite, PCWrite, RegIn, AddrSel;
wire	ALU1, ALUOutWrite, FlagWrite, R1R2Load, R1Sel, RFWrite;
wire	[7:0] R2wire, PCwire, R1wire, RFout1wire, RFout2wire;
wire	[7:0] ALU1wire, ALU2wire, ALUwire, ALUOut, MDRwire, MEMwire, MEMwirePC;
wire	[7:0] SE4wire, ZE5wire, ZE3wire, AddrWire, RegWire, AddrWirePC;
wire	[7:0] reg0, reg1, reg2, reg3;
wire	[7:0] constant;
wire	[7:0] IR_1,IR_2,IR_3,IR_4,ALU3wire,ALUPCwire;				//New Wires
wire	[7:0]	ZE3wireOut,ZE5wireOut,SE4wireOut,PC_Next,WBinOut;
wire	[7:0]	PC1Out,PC2Out,PC3Out,IR1_in,IR2_in,ALUwireOut,PCSelOut;
wire	[2:0] ALUOp, ALU2; 
wire	[1:0] R1_in,regw_in;
wire	Nwire, Zwire, NwireOut, ZwireOut;
wire	CounterOn;
wire	[15:0] counterOut;
wire	IR_1_Load,IR_2_Load,IR_3_Load,IR_4_Load,ZE5_Load,ZE3_Load,SE4_Load;	//New Controls
wire	WBinWrite,PCSel,ALU3,PC1_Load,PC2_Load,PC3_Load,regwSel,IR1Sel,IR2Sel;
reg		N, Z;

// ------------------------ Input Assignment ------------------------ //
assign	clock = KEY[1];
assign	reset =  ~KEY[0]; // KEY is active high


// ------------------- DE2 compatible HEX display ------------------- //
HEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),										
	.out0(HEX0),.out1(HEX1),.out2(HEX2),.out3(HEX3),
	.out4(HEX4),.out5(HEX5),.out6(HEX6),.out7(HEX7),
	.CounterIn(counterOut),.CounterEnable(SW[2])													//Added count and sel
);
// ----------------- END DE2 compatible HEX display ----------------- //

/*
// ------------------- DE1 compatible HEX display ------------------- //
chooseHEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),
	.out0(HEX0),.out1(HEX1),.select(SW[1:0])
);
// turn other HEX display off
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;
// ----------------- END DE1 compatible HEX display ----------------- //
*/

//FSM		Control(
//	.reset(reset),.clock(clock),.N(N),.Z(Z),.instr(IR[3:0]),
//	.PCwrite(PCWrite),.MemRead(MemRead),.MemWrite(MemWrite),
//	.IRload(IRLoad),.R1Sel(R1Sel),.MDRload(MDRLoad),.R1R2Load(R1R2Load),
//	.ALU1(ALU1),.ALUOutWrite(ALUOutWrite),.RFWrite(RFWrite),.RegIn(RegIn),
//	.FlagWrite(FlagWrite),.ALU2(ALU2),.ALUop(ALUOp),.CounterOn(CounterOn)
//);

//assign PC1_Load = 1'b1;
//assign PC2_Load = 1'b1;
//assign PC3_Load = 1'b1;
////assign PC4_Load = 1'b1;
//assign IR_1_Load = 1'b1;
//assign IR_2_Load = 1'b1;
//assign IR_3_Load = 1'b1;
//assign IR_4_Load = 1'b1;


memory	DataMem(
	.MemRead(MemRead),.wren(MemWrite),.clock(clock),.address_pc(AddrWirePC),
	.address(R2wire),.data(R1wire),.q(MEMwire),.q_pc(MEMwirePC)
);

ALU		ALU(
	.in1(ALU1wire),
	.in2(ALU2wire),
	.out(ALUwire),
	.ALUOp(ALUOp),
	.N(Nwire),
	.Z(Zwire)
);

ALU		PC_ALU(
	.in1(AddrWirePC),
	.in2(8'b00000001),
	.out(ALUPCwire),
	.ALUOp(3'b000),
	.N(),
	.Z()
);

RF		RF_block(
	.clock(clock),
	.reset(reset),
	.RFWrite(RFWrite),
	.dataw(WBinOut),
	.reg1(R1_in),
	.reg2(IR_2[5:4]),				//From IR_2
	.regw(regw_in),				//From IR_4
	.data1(RFout1wire),
	.data2(RFout2wire),
	.r0(reg0),.r1(reg1),.r2(reg2),.r3(reg3)
);

register_8bit_special	IR_1_reg(
	.clock(clock),
	.aclr(reset),
	.enable(IR_1_Load),
	.data(IR1_in),
	.q(IR_1)
);

register_8bit_special	IR_2_reg(
	.clock(clock),
	.aclr(reset),
	.enable(IR_2_Load),
	.data(IR2_in),
	.q(IR_2)	
);

register_8bit_special	IR_3_reg(
	.clock(clock),
	.aclr(reset),
	.enable(IR_3_Load),
	.data(IR_2),
	.q(IR_3)	
);

register_8bit_special	IR_4_reg(
	.clock(clock),
	.aclr(reset),
	.enable(IR_4_Load),
	.data(IR_3),
	.q(IR_4)	
);

register_8bit	PC(
	.clock(clock),
	.aclr(reset),
	.enable(PCWrite),
	.data(PC_Next),
	.q(AddrWirePC)
);


register_8bit	PC1(
	.clock(clock),
	.aclr(reset),
	.enable(PC1_Load),
	.data(ALUPCwire),
	.q(PC1Out)	
);

register_8bit	PC2(
	.clock(clock),
	.aclr(reset),
	.enable(PC2_Load),
	.data(PC1Out),
	.q(PC2Out)	
);

register_8bit	PC3(
	.clock(clock),
	.aclr(reset),
	.enable(PC3_Load),
	.data(PC2Out),
	.q(PC3Out)	
);

//register_1bit	N_Flag(
//	.clock(clock),
//	.aclr(reset),
//	.enable(FlagWrite),
//	.data(Nwire),
//	.q(NwireOut)
//);
//
//register_1bit	Z_Flag(
//	.clock(clock),
//	.aclr(reset),
//	.enable(FlagWrite),
//	.data(Zwire),
//	.q(ZwireOut)
//);

FSM	Control_Hazard(
	.reset(reset),
	.clock(clock),
	.N(N),.Z(Z),
	.instr(MEMwirePC[7:0]),
	.next_instr(IR_1[7:0]),
	.next_next_instr(IR_2[7:0]),
	.PCWrite(PCWrite),
	.PC1_Load(PC1_Load),
	.PC2_Load(PC2_Load),
	.PC3_Load(PC3_Load),
	.IR_1_Load(IR_1_Load),
	.IR_2_Load(IR_2_Load),
	.IR_3_Load(IR_3_Load),
	.IR_4_Load(IR_4_Load),
	.IR1Sel(IR1Sel),
	.IR2Sel(IR2Sel),
	.CounterOn(CounterOn)
);

//Sequential_1	Control_1(
//	.Instr(MEMwirePC[3:0]),
//	.PCWrite(PCWrite),
//	.PC1_Load(PC1_Load),
//	.PC2_Load(PC2_Load),
//	.PC3_Load(PC3_Load),
//	.IR_1_Load(IR_1_Load),
//	.IR_2_Load(IR_2_Load),
//	.IR_3_Load(IR_3_Load),
//	.IR_4_Load(IR_4_Load),
//	.CounterOn(CounterOn)
//);

Sequential_2	Control_2(
	.Instr(IR_2[3:0]),
	.R1Sel(R1Sel),
	.ZE5_Load(ZE5_Load),
	.ZE3_Load(ZE3_Load),
	.SE4_Load(SE4_Load)
);

Sequential_3	Control_3(
	.Instr(IR_3[3:0]),
	.NwireOut(N),
	.ZwireOut(Z),
	.ALU1(ALU1),
	.ALU2(ALU2),
	.ALUOp(ALUOp),
	.MemRead(MemRead),
	.MemWrite(MemWrite),
	.R1R2Load(R1R2Load),
	.PCSel(PCSel),
	.WBinWrite(WBinWrite),
	.ALU3(ALU3),
	.FlagWrite(FlagWrite)
);

Sequential_4	Control_4(
	.Instr(IR_4[3:0]),
	.RFWrite(RFWrite),
	.regwSel(regwSel)
);

register_8bit	ZE3_reg(
	.clock(clock),
	.aclr(reset),
	.enable(ZE3_Load),
	.data(ZE3wire),
	.q(ZE3wireOut)	
);

register_8bit	SE4_reg(
	.clock(clock),
	.aclr(reset),
	.enable(SE4_Load),
	.data(SE4wire),
	.q(SE4wireOut)	
);

register_8bit	ZE5_reg(
	.clock(clock),
	.aclr(reset),
	.enable(ZE5_Load),
	.data(ZE5wire),
	.q(ZE5wireOut)	
);

//register_8bit	MDR_reg(
//	.clock(clock),
//	.aclr(reset),
//	.enable(MDRLoad),
//	.data(MEMwire),
//	.q(MDRwire)
//);


register_8bit	R1(
	.clock(clock),
	.aclr(reset),
	.enable(R1R2Load),
	.data(RFout1wire),
	.q(R1wire)
);

register_8bit	R2(
	.clock(clock),
	.aclr(reset),
	.enable(R1R2Load),
	.data(RFout2wire),
	.q(R2wire)
);

register_8bit	WBin(
	.clock(clock),
	.aclr(reset),
	.enable(WBinWrite),
	.data(ALU3wire),
	.q(WBinOut)
);

mux2to1_2bit		R1Sel_mux(
	.data0x(IR_2[7:6]),			//From IR_2
	.data1x(constant[1:0]),
	.sel(R1Sel),
	.result(R1_in)
);

mux2to1_2bit		regwSel_mux(
	.data0x(IR_4[7:6]),			//From IR_2
	.data1x(constant[1:0]),
	.sel(regwSel),
	.result(regw_in)	
);

mux2to1_8bit 		PCSel_mux(
	.data0x(ALUwire),
	.data1x(ALUPCwire),			//ALUPCwire input
	.sel(PCSel),
	.result(PC_Next)
);

//register_1bit		PCSel_reg(
//	.clock(clock),
//	.aclr(reset),
//	.enable(1'b1),
//	.data(PCSel),
//	.q(PCSelOut)
//);
//
//register_8bit	BR_reg(
//	.clock(clock),
//	.aclr(reset),
//	.enable(1'b1),
//	.data(ALUwire),
//	.q(ALUwireOut)
//);

mux2to1_8bit		IR1Sel_mux(
	.data0x(8'b00001010),
	.data1x(MEMwirePC),			
	.sel(IR1Sel),
	.result(IR1_in)
);

mux2to1_8bit		IR2Sel_mux(
	.data0x(8'b00001010),
	.data1x(IR_1),			
	.sel(IR2Sel),
	.result(IR2_in)
);

//mux2to1_8bit 		RegMux(
//	.data0x(ALUOut),
//	.data1x(MDRwire),
//	.sel(RegIn),
//	.result(RegWire)
//);

mux2to1_8bit 		ALU1_mux(
	.data0x(PC3Out),
	.data1x(R1wire),
	.sel(ALU1),
	.result(ALU1wire)
);

mux2to1_8bit		ALU3_mux(
	.data0x(ALUwire),
	.data1x(MEMwire),
	.sel(ALU3),
	.result(ALU3wire)
);

mux5to1_8bit 		ALU2_mux(
	.data0x(R2wire),
	.data1x(constant),
	.data2x(SE4wireOut),
	.data3x(ZE5wireOut),
	.data4x(ZE3wireOut),
	.sel(ALU2),
	.result(ALU2wire)
);

Counter				PerformanceCounter(
	.clock(clock), 
	.reset(reset), 
	.enable(CounterOn), 
	.counterOut(counterOut)
);

/*Seven_Segment_Display Hex_Display (
	// Inputs
	.register1(counterOut),
	.display_enable(SW[2]),
	// Outputs
	.seven_segment_display_0	(HEX0),
	.seven_segment_display_1	(HEX1),
	.seven_segment_display_2	(HEX2),
	.seven_segment_display_3	(HEX3)
);*/

sExtend		SE4(.in(IR_2[7:4]),.out(SE4wire));				//From IR_2
zExtend		ZE3(.in(IR_2[5:3]),.out(ZE3wire));				//From IR_2
zExtend		ZE5(.in(IR_2[7:3]),.out(ZE5wire));				//From IR_2
// define parameter for the data size to be extended
defparam	SE4.n = 4;
defparam	ZE3.n = 3;
defparam	ZE5.n = 5;

always@(posedge clock or posedge reset)
begin
if (reset)
	begin
	N <= 0;
	Z <= 0;
	end
else
if (FlagWrite)
	begin
	N <= Nwire;
	Z <= Zwire;
	end
end

// ------------------------ Assign Constant 1 ----------------------- //
assign	constant = 1;

// ------------------------- LEDs Indicator ------------------------- //
assign	LEDR[17] = PCWrite;
assign	LEDR[16] = AddrSel;
assign	LEDR[15] = MemRead;
assign	LEDR[14] = MemWrite;
assign	LEDR[13] = PC1_Load;
assign	LEDR[12] = R1Sel;
assign	LEDR[11] = MDRLoad;
assign	LEDR[10] = R1R2Load;
assign	LEDR[9] = ALU1;
assign	LEDR[2] = ALUOutWrite;
assign	LEDR[1] = RFWrite;
assign	LEDR[0] = PCSel;
assign	LEDR[8:6] = ALU2[2:0];
assign	LEDR[5:3] = ALUOp[2:0];
assign	LEDG[6:2] = constant[7:3];
assign	LEDG[7] = FlagWrite;
assign	LEDG[1] = N;
assign	LEDG[0] = Z;

endmodule
