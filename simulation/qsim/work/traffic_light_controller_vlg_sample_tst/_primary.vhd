library verilog;
use verilog.vl_types.all;
entity traffic_light_controller_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        sensor_E        : in     vl_logic;
        sensor_N        : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end traffic_light_controller_vlg_sample_tst;
