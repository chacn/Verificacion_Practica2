onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /MSD_TB/DUT/clk
add wave -noupdate /MSD_TB/DUT/rst
add wave -noupdate -color Magenta /MSD_TB/DUT/start
add wave -noupdate -color Coral /MSD_TB/DUT/load
add wave -noupdate -radix unsigned /MSD_TB/DUT/opcode
add wave -noupdate -radix decimal /MSD_TB/DUT/data
add wave -noupdate -radix decimal /MSD_TB/DUT/result
add wave -noupdate -radix decimal /MSD_TB/DUT/residue
add wave -noupdate -color {Medium Blue} /MSD_TB/DUT/ready_flag
add wave -noupdate -color {Orange Red} /MSD_TB/DUT/error_flag
add wave -noupdate /MSD_TB/DUT/load_x
add wave -noupdate /MSD_TB/DUT/load_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {528 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 354
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
WaveRestoreZoom {0 ps} {584 ps}
