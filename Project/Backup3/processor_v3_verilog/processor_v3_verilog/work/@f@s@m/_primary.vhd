library verilog;
use verilog.vl_types.all;
entity FSM is
    generic(
        reset_s         : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi0);
        c1              : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        c2_br           : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi0);
        c3_br           : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi1);
        c4_br           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi0);
        c2_stop         : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi1);
        c3_stop         : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi0);
        c4_stop         : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi1)
    );
    port(
        reset           : in     vl_logic;
        instr           : in     vl_logic_vector(3 downto 0);
        clock           : in     vl_logic;
        N               : in     vl_logic;
        Z               : in     vl_logic;
        PCWrite         : out    vl_logic;
        PC1_Load        : out    vl_logic;
        PC2_Load        : out    vl_logic;
        PC3_Load        : out    vl_logic;
        IR_1_Load       : out    vl_logic;
        IR_2_Load       : out    vl_logic;
        IR_3_Load       : out    vl_logic;
        IR_4_Load       : out    vl_logic;
        IR1Sel          : out    vl_logic;
        CounterOn       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of reset_s : constant is 2;
    attribute mti_svvh_generic_type of c1 : constant is 2;
    attribute mti_svvh_generic_type of c2_br : constant is 2;
    attribute mti_svvh_generic_type of c3_br : constant is 2;
    attribute mti_svvh_generic_type of c4_br : constant is 2;
    attribute mti_svvh_generic_type of c2_stop : constant is 2;
    attribute mti_svvh_generic_type of c3_stop : constant is 2;
    attribute mti_svvh_generic_type of c4_stop : constant is 2;
end FSM;
