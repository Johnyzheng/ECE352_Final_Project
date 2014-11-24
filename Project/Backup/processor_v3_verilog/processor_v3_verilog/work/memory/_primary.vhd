library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        wren            : in     vl_logic;
        clock           : in     vl_logic;
        MemRead         : in     vl_logic;
        address         : in     vl_logic_vector(7 downto 0);
        data            : in     vl_logic_vector(7 downto 0);
        q               : out    vl_logic_vector(7 downto 0)
    );
end memory;
