onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /input_control_TB/DUT/clk
add wave -noupdate /input_control_TB/DUT/rst
add wave -noupdate -radix decimal /input_control_TB/DUT/data
add wave -noupdate /input_control_TB/DUT/opCode
add wave -noupdate -color {Orange Red} /input_control_TB/DUT/start
add wave -noupdate /input_control_TB/DUT/load
add wave -noupdate -radix decimal /input_control_TB/DUT/operand_1
add wave -noupdate -radix decimal /input_control_TB/DUT/operand_2
add wave -noupdate -radix unsigned /input_control_TB/DUT/opCode_R_out
add wave -noupdate /input_control_TB/DUT/load_x_out
add wave -noupdate /input_control_TB/DUT/load_y_out
add wave -noupdate /input_control_TB/DUT/start_out
add wave -noupdate /input_control_TB/DUT/error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 382
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
WaveRestoreZoom {0 ps} {211 ps}
