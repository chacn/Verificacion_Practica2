onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Top
add wave -noupdate /MSD_TB/DUT/clk
add wave -noupdate /MSD_TB/DUT/rst
add wave -noupdate -color {Orange Red} -radix unsigned /MSD_TB/DUT/residue
add wave -noupdate /MSD_TB/DUT/start
add wave -noupdate -radix unsigned /MSD_TB/DUT/opcode
add wave -noupdate -radix decimal /MSD_TB/DUT/operand_1
add wave -noupdate -radix decimal /MSD_TB/DUT/operand_2
add wave -noupdate -color Gold -radix unsigned /MSD_TB/DUT/result
add wave -noupdate /MSD_TB/DUT/ready_flag
add wave -noupdate -divider Control
add wave -noupdate /MSD_TB/DUT/CONTROL_MODULE/start
add wave -noupdate -radix unsigned /MSD_TB/DUT/CONTROL_MODULE/opc_code
add wave -noupdate /MSD_TB/DUT/CONTROL_MODULE/control
add wave -noupdate -color {Dark Orchid} -radix unsigned /MSD_TB/DUT/CONTROL_MODULE/state_counter_wire
add wave -noupdate /MSD_TB/DUT/CONTROL_MODULE/CURRENT_STATE_SELECTOR/enable
add wave -noupdate /MSD_TB/DUT/CONTROL_MODULE/CURRENT_STATE_SELECTOR/load_value
add wave -noupdate /MSD_TB/DUT/CONTROL_MODULE/CURRENT_STATE_SELECTOR/value_to_load
add wave -noupdate -divider Multiplicador
add wave -noupdate -radix unsigned /MSD_TB/DUT/MULTIPLIER_MODULE/control
add wave -noupdate /MSD_TB/DUT/MULTIPLIER_MODULE/m1_in
add wave -noupdate /MSD_TB/DUT/MULTIPLIER_MODULE/m2_in
add wave -noupdate /MSD_TB/DUT/MULTIPLIER_MODULE/AddResult_in
add wave -noupdate -color Gold -radix decimal /MSD_TB/DUT/MULTIPLIER_MODULE/P_out
add wave -noupdate /MSD_TB/DUT/MULTIPLIER_MODULE/Add1_out
add wave -noupdate /MSD_TB/DUT/MULTIPLIER_MODULE/Add2_out
add wave -noupdate /MSD_TB/DUT/MULTIPLIER_MODULE/AddSign_out
add wave -noupdate -divider Divider
add wave -noupdate -expand /MSD_TB/DUT/DIVIDER_MODULE/control
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/divider
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/dividend
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/AddResult_in
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/Result
add wave -noupdate -color {Orange Red} -radix unsigned /MSD_TB/DUT/DIVIDER_MODULE/Residue
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/Add1_out
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/Add2_out
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/AddSign_out
add wave -noupdate -divider {Shift left dividend}
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/SHIFT_LEFT_DIVIDEND/Data_Input
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/SHIFT_LEFT_DIVIDEND/load
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/SHIFT_LEFT_DIVIDEND/shift
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/SHIFT_LEFT_DIVIDEND/sync_rst
add wave -noupdate -radix binary /MSD_TB/DUT/DIVIDER_MODULE/SHIFT_LEFT_DIVIDEND/Data_Output
add wave -noupdate -divider residuo
add wave -noupdate -radix unsigned /MSD_TB/DUT/DIVIDER_MODULE/TEMPORAL_DIVIDEND_REGISTER/Data_Input
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/TEMPORAL_DIVIDEND_REGISTER/enable
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/TEMPORAL_DIVIDEND_REGISTER/sync_reset
add wave -noupdate -color {Orange Red} -radix unsigned /MSD_TB/DUT/DIVIDER_MODULE/TEMPORAL_DIVIDEND_REGISTER/Data_Output
add wave -noupdate -divider result
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/RESULT_REGISTER/Data_Input
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/RESULT_REGISTER/enable
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/RESULT_REGISTER/sync_reset
add wave -noupdate /MSD_TB/DUT/DIVIDER_MODULE/RESULT_REGISTER/Data_Output
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {241 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 441
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
WaveRestoreZoom {14 ps} {158 ps}
