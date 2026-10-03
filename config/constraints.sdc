###############################################################################
# Created by write_sdc
###############################################################################
current_design riscv_cpu
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_uncertainty 0.1000 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {rst}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[0]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[10]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[11]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[12]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[13]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[14]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[15]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[16]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[17]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[18]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[19]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[1]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[20]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[21]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[22]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[23]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[24]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[25]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[26]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[27]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[28]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[29]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[2]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[30]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[31]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[3]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[4]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[5]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[6]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[7]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[8]}]
set_output_delay 0.5000 -clock [get_clocks {clk}] -add_delay [get_ports {write_back_out[9]}]
set_false_path\
    -from [get_ports {rst}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
