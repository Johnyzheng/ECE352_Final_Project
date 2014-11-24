library verilog;
use verilog.vl_types.all;
entity Sequential_2 is
    port(
        Instr           : in     vl_logic_vector(3 downto 0);
        R1Sel           : out    vl_logic;
        ZE5_Load        : out    vl_logic;
        ZE3_Load        : out    vl_logic;
        SE4_Load        : out    vl_logic
    );
end Sequential_2;
