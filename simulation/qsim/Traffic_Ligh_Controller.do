onerror {exit -code 1}
vlib work
vlog -work work Traffic_Ligh_Controller.vo
vlog -work work Traffic_Light_Controller.vwf.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.traffic_light_controller_vlg_vec_tst -voptargs="+acc"
vcd file -direction Traffic_Ligh_Controller.msim.vcd
vcd add -internal traffic_light_controller_vlg_vec_tst/*
vcd add -internal traffic_light_controller_vlg_vec_tst/i1/*
run -all
quit -f
