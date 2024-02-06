set projDir "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/vivado"
set projName "P118-memory-bus-lab"
set topName top
set device xc7a35tftg256-1
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/verilog/au_top_0.v" "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/verilog/slowcounter_1.v" "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/verilog/binary2display_2.v" "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/verilog/memory_3.v" "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/verilog/nibble2seg_4.v" ]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set xdcSources [list "C:/Users/ericp/github/UCD_P118_Alchitry/P118-memory-bus-lab/work/constraint/membus.xdc" "C:/Program\ Files/Alchitry/Alchitry\ Labs/library/components/au.xdc" ]
read_xdc $xdcSources
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1 -jobs 8
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
