
#==============================================================
# Project : 4-Bit Universal Shift Register
# FPGA    : XC7A100T-CSG324-1
# Board   : Digilent Arty A7-100T Rev. D/E
# Clock   : 100 MHz
#==============================================================

#--------------------------------------------------------------
# 100 MHz onboard clock
#--------------------------------------------------------------
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clk }]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports { clk }]

#--------------------------------------------------------------
# Parallel data input: data_input[3:0]
#--------------------------------------------------------------
set_property -dict { PACKAGE_PIN A8  IOSTANDARD LVCMOS33 } [get_ports { data_input[0] }]
set_property -dict { PACKAGE_PIN C11 IOSTANDARD LVCMOS33 } [get_ports { data_input[1] }]
set_property -dict { PACKAGE_PIN C10 IOSTANDARD LVCMOS33 } [get_ports { data_input[2] }]
set_property -dict { PACKAGE_PIN A10 IOSTANDARD LVCMOS33 } [get_ports { data_input[3] }]

#--------------------------------------------------------------
# Operation selector: sel[1:0]
#--------------------------------------------------------------
set_property -dict { PACKAGE_PIN D9 IOSTANDARD LVCMOS33 } [get_ports { sel[0] }]
set_property -dict { PACKAGE_PIN C9 IOSTANDARD LVCMOS33 } [get_ports { sel[1] }]

#--------------------------------------------------------------
# Register output: data_output[3:0]
#--------------------------------------------------------------
set_property -dict { PACKAGE_PIN H5  IOSTANDARD LVCMOS33 } [get_ports { data_output[0] }]
set_property -dict { PACKAGE_PIN J5  IOSTANDARD LVCMOS33 } [get_ports { data_output[1] }]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports { data_output[2] }]
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { data_output[3] }]
