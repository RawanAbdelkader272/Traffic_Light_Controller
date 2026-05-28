library verilog;
use verilog.vl_types.all;
entity traffic_light_controller is
    generic(
        GREEN_TIME      : integer := 30;
        YELLOW_TIME     : integer := 5;
        CLK_DIV         : integer := 50000000;
        MUX_CLK_DIV     : integer := 50000
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        sensor_N        : in     vl_logic;
        sensor_E        : in     vl_logic;
        G_N             : out    vl_logic;
        Y_N             : out    vl_logic;
        R_N             : out    vl_logic;
        G_E             : out    vl_logic;
        Y_E             : out    vl_logic;
        R_E             : out    vl_logic;
        seg             : out    vl_logic_vector(6 downto 0);
        digit_sel       : out    vl_logic_vector(1 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of GREEN_TIME : constant is 1;
    attribute mti_svvh_generic_type of YELLOW_TIME : constant is 1;
    attribute mti_svvh_generic_type of CLK_DIV : constant is 1;
    attribute mti_svvh_generic_type of MUX_CLK_DIV : constant is 1;
end traffic_light_controller;
