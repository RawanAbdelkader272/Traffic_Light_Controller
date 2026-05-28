library verilog;
use verilog.vl_types.all;
entity timer is
    generic(
        FINAL_VALUE     : integer := 30
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        start           : in     vl_logic;
        done            : out    vl_logic;
        count           : out    vl_logic_vector(5 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FINAL_VALUE : constant is 1;
end timer;
