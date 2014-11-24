library verilog;
use verilog.vl_types.all;
entity register_1bit is
    port(
        aclr            : in     vl_logic;
        clock           : in     vl_logic;
        data            : in     vl_logic_vector(0 downto 0);
        enable          : in     vl_logic;
        q               : out    vl_logic_vector(0 downto 0)
    );
end register_1bit;
