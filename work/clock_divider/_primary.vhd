library verilog;
use verilog.vl_types.all;
entity clock_divider is
    generic(
        DIV_VALUE       : integer := 50000000
    );
    port(
        clk_in          : in     vl_logic;
        reset_n         : in     vl_logic;
        clk_out         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DIV_VALUE : constant is 1;
end clock_divider;
