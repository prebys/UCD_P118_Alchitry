set projDir "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/vivado"
set projName "P118-DAC-set-lab"
set topName top
set device xc7a35tftg256-1
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/verilog/au_top_0.v" "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/verilog/slowcount_1.v" "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/verilog/dac_set_ad5626_2.v" "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/verilog/hex2bcd_3.v" "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/verilog/fourhex_4.v" "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/verilog/hex7segment_5.v" ]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set xdcSources [list "C:/Users/prebys/github/UCD_P118_Alchitry/P118-DAC-set-lab/work/constraint/dac_test.xdc" "C:/Program\ Files/Alchitry/Alchitry\ Labs/library/components/au.xdc" ]
read_xdc $xdcSources
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
