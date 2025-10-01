## This file is a general .xdc for the Nexys4 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

set_property PACKAGE_PIN E3 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name clk -period 10.00 -waveform {0 5} [get_ports clk]
# Period = 10(ns) => freq = 100(MHz)

##Buttons
##Bank = 15, Pin name = IO_L3P_T0_DQS_AD1P_15,				Sch name = CPU_RESET
set_property PACKAGE_PIN C12 [get_ports rst]				
	set_property IOSTANDARD LVCMOS33 [get_ports rst]
##Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
set_property PACKAGE_PIN E16 [get_ports b_enter]						
	set_property IOSTANDARD LVCMOS33 [get_ports b_enter]
##Bank = CONFIG, Pin name = IO_L15N_T2_DQS_DOUT_CSO_B_14,	Sch name = BTNL
set_property PACKAGE_PIN T16 [get_ports b_sign]						
	set_property IOSTANDARD LVCMOS33 [get_ports b_sign]

## Switches
##Bank = 34, Pin name = IO_L21P_T3_DQS_34,					Sch name = SW0
set_property PACKAGE_PIN U9 [get_ports {alu_input[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[0]}]
##Bank = 34, Pin name = IO_25_34,							Sch name = SW1
set_property PACKAGE_PIN U8 [get_ports {alu_input[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[1]}]
##Bank = 34, Pin name = IO_L23P_T3_34,						Sch name = SW2
set_property PACKAGE_PIN R7 [get_ports {alu_input[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[2]}]
##Bank = 34, Pin name = IO_L19P_T3_34,						Sch name = SW3
set_property PACKAGE_PIN R6 [get_ports {alu_input[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[3]}]
##Bank = 34, Pin name = IO_L19N_T3_VREF_34,					Sch name = SW4
set_property PACKAGE_PIN R5 [get_ports {alu_input[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[4]}]
##Bank = 34, Pin name = IO_L20P_T3_34,						Sch name = SW5
set_property PACKAGE_PIN V7 [get_ports {alu_input[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[5]}]
##Bank = 34, Pin name = IO_L20N_T3_34,						Sch name = SW6
set_property PACKAGE_PIN V6 [get_ports {alu_input[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[6]}]
##Bank = 34, Pin name = IO_L10P_T1_34,						Sch name = SW7
set_property PACKAGE_PIN V5 [get_ports {alu_input[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alu_input[7]}]

## 7 segment display
#Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = CA
set_property PACKAGE_PIN L3 [get_ports {seven_seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[0]}]
#Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
set_property PACKAGE_PIN N1 [get_ports {seven_seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[1]}]
#Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
set_property PACKAGE_PIN L5 [get_ports {seven_seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[2]}]
#Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
set_property PACKAGE_PIN L4 [get_ports {seven_seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[3]}]
#Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
set_property PACKAGE_PIN K3 [get_ports {seven_seg[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[4]}]
#Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
set_property PACKAGE_PIN M2 [get_ports {seven_seg[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[5]}]
#Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
set_property PACKAGE_PIN L6 [get_ports {seven_seg[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {seven_seg[6]}]

#Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
set_property PACKAGE_PIN N6 [get_ports {anode[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[0]}]
#Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = AN1
set_property PACKAGE_PIN M6 [get_ports {anode[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[1]}]
#Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = AN2
set_property PACKAGE_PIN M3 [get_ports {anode[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[2]}]
#Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = AN3
set_property PACKAGE_PIN N5 [get_ports {anode[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {anode[3]}]

