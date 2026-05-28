onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /traffic_light_controller_tb/T
add wave -noupdate /traffic_light_controller_tb/GREEN_TIME
add wave -noupdate /traffic_light_controller_tb/YELLOW_TIME
add wave -noupdate /traffic_light_controller_tb/CLK_DIV
add wave -noupdate /traffic_light_controller_tb/MUX_CLK_DIV
add wave -noupdate /traffic_light_controller_tb/clk
add wave -noupdate /traffic_light_controller_tb/reset_n
add wave -noupdate /traffic_light_controller_tb/sensor_N
add wave -noupdate /traffic_light_controller_tb/sensor_E
add wave -noupdate /traffic_light_controller_tb/G_N
add wave -noupdate /traffic_light_controller_tb/Y_N
add wave -noupdate /traffic_light_controller_tb/R_N
add wave -noupdate /traffic_light_controller_tb/G_E
add wave -noupdate /traffic_light_controller_tb/Y_E
add wave -noupdate /traffic_light_controller_tb/R_E
add wave -noupdate /traffic_light_controller_tb/seg
add wave -noupdate /traffic_light_controller_tb/digit_sel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {933 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {600 ps} {1600 ps}
