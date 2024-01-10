set projDir "C:/Users/prebys/Alchitry/ADC-DAC/work/vivado"
set projName "ADC-DAC"
set topName top
set device xc7a35tftg256-1
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "C:/Users/prebys/Alchitry/ADC-DAC/work/verilog/au_top_0.v" "C:/Users/prebys/Alchitry/ADC-DAC/work/verilog/xadc_wrapper_1.v" "C:/Users/prebys/Alchitry/ADC-DAC/work/verilog/dac_set_ad5626_2.v" ]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set xdcSources [list "C:/Program\ Files/Alchitry/Alchitry\ Labs/library/components/au.xdc" "C:/Users/prebys/Alchitry/ADC-DAC/work/constraint/test.xdc" ]
read_xdc $xdcSources
import_ip -srcset [get_filesets sources_1] [list "C:/Users/prebys/Alchitry/ADC-DAC/cores/xadc_wiz_0/xadc_wiz_0.xci"]
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1 -jobs 4
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
