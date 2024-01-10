set projDir "G:/My\ Drive/Alchitry/io-counter/work/vivado"
set projName "io-counter"
set topName top
set device xc7a35tftg256-1
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "G:/My\ Drive/Alchitry/io-counter/work/verilog/au_top_0.v" "G:/My\ Drive/Alchitry/io-counter/work/verilog/reset_conditioner_1.v" "G:/My\ Drive/Alchitry/io-counter/work/verilog/hex2bcd_2.v" "G:/My\ Drive/Alchitry/io-counter/work/verilog/fourhex_3.v" "G:/My\ Drive/Alchitry/io-counter/work/verilog/hex7segment_4.v" ]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set xdcSources [list "C:/Program\ Files/Alchitry/Alchitry\ Labs/library/components/au.xdc" "G:/My\ Drive/Alchitry/io-counter/work/constraint/io-counter.xdc" ]
read_xdc $xdcSources
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
