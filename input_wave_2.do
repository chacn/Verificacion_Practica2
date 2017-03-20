onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /MSD_TB/DUT/clk
add wave -noupdate /MSD_TB/DUT/rst
add wave -noupdate /MSD_TB/DUT/start
add wave -noupdate /MSD_TB/DUT/opcode
add wave -noupdate -radix unsigned /MSD_TB/DUT/operand_1
add wave -noupdate -radix unsigned /MSD_TB/DUT/operand_2
add wave -noupdate -radix unsigned /MSD_TB/DUT/result
add wave -noupdate -radix unsigned /MSD_TB/DUT/residue
add wave -noupdate /MSD_TB/DUT/ready_flag
add wave -noupdate /MSD_TB/DUT/overflow_flag
add wave -noupdate /MSD_TB/DUT/error_flag
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/control_signal
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/out_R
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/out_Q
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/BS_module/data_out
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/BS_module/data_in
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/BS_module/shift_enable
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/BS_module/synch_reset
add wave -noupdate -radix unsigned /MSD_TB/DUT/SQRT_MODULE/BS_module/Counter_data/Counting
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/BS_module/Counter_data/MaxValue_Bit
add wave -noupdate /MSD_TB/DUT/SQRT_MODULE/BS_module/Counter_data/Maximum_Value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {468 ps} 0}
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
WaveRestoreZoom {412 ps} {540 ps}
