# clk => 100000000Hz
create_clock -period 10.0 -name clk_0 -waveform {0.000 5.000} [get_ports clk]
set_property PACKAGE_PIN N14 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
set_property PACKAGE_PIN H8 [get_ports {vp_in}]
set_property IOSTANDARD LVCMOS33 [get_ports {vp_in}]
set_property PACKAGE_PIN J7 [get_ports {vn_in}]
set_property IOSTANDARD LVCMOS33 [get_ports {vn_in}]
set_property PACKAGE_PIN N13 [get_ports {UCD_io[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UCD_io[0]}]
set_property PACKAGE_PIN P13 [get_ports {UCD_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UCD_io[1]}]
set_property PACKAGE_PIN L4 [get_ports {UCD_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UCD_io[2]}]
set_property PACKAGE_PIN M4 [get_ports {UCD_io[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UCD_io[3]}]
set_property PACKAGE_PIN R2 [get_ports {UCD_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {UCD_io[4]}]
