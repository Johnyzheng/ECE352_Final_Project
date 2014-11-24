library verilog;
use verilog.vl_types.all;
entity Sequential_3 is
    port(
        Instr           : in     vl_logic_vector(3 downto 0);
        NwireOut        : in     vl_logic;
        ZwireOut        : in     vl_logic;
        ALU1            : out    vl_logic;
        ALU2            : out    vl_logic_vector(2 downto 0);
        ALUOp           : out    vl_logic_vector(2 downto 0);
        MemRead         : out    vl_logic;
        MemWrite        : out    vl_logic;
        R1R2Load        : out    vl_logic;
        PCSel           : out    vl_logic;
        WBinWrite       : out    vl_logic;
        ALU3            : out    vl_logic;
        FlagWrite       : out    vl_logic
    );
end Sequential_3;
