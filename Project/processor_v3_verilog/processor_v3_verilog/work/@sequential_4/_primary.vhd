library verilog;
use verilog.vl_types.all;
entity Sequential_4 is
    port(
        Instr           : in     vl_logic_vector(3 downto 0);
        RFWrite         : out    vl_logic;
        regwSel         : out    vl_logic
    );
end Sequential_4;
