library verilog;
use verilog.vl_types.all;
entity Sequential_1 is
    port(
        Instr           : in     vl_logic_vector(3 downto 0);
        PCWrite         : out    vl_logic;
        PC1_Load        : out    vl_logic;
        PC2_Load        : out    vl_logic;
        PC3_Load        : out    vl_logic;
        IR_1_Load       : out    vl_logic;
        IR_2_Load       : out    vl_logic;
        IR_3_Load       : out    vl_logic;
        IR_4_Load       : out    vl_logic;
        CounterOn       : out    vl_logic
    );
end Sequential_1;
