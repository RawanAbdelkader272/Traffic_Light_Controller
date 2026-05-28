library verilog;
use verilog.vl_types.all;
entity traffic_light_controller is
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
end traffic_light_controller;
