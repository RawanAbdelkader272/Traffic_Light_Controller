library verilog;
use verilog.vl_types.all;
entity traffic_light_controller_vlg_check_tst is
    port(
        G_E             : in     vl_logic;
        G_N             : in     vl_logic;
        R_E             : in     vl_logic;
        R_N             : in     vl_logic;
        Y_E             : in     vl_logic;
        Y_N             : in     vl_logic;
        digit_sel       : in     vl_logic_vector(1 downto 0);
        seg             : in     vl_logic_vector(6 downto 0);
        sampler_rx      : in     vl_logic
    );
end traffic_light_controller_vlg_check_tst;
