# 4x4 serial-in / serial-out multiplier — Icarus Verilog build
IVERILOG ?= iverilog
VVP      ?= vvp
RTL      := $(wildcard rtl/*.v)
BUILD    := build

.PHONY: sim multiplier controller multiplier4 serial_out8 clean

sim: multiplier

# top module of each testbench
multiplier:   TOP := Multiplier_tb
controller:   TOP := controller_tb
multiplier4:  TOP := multiplier4_tb
serial_out8:  TOP := serial_out8_tb

# testbench source for each target
multiplier:   TB := tb/Multiplier_tb.v
controller:   TB := tb/controller_tb.v
multiplier4:  TB := tb/multiplier4_tb.v
serial_out8:  TB := tb/serial_out8_tb.v

multiplier controller multiplier4 serial_out8:
	@mkdir -p $(BUILD)
	$(IVERILOG) -s $(TOP) -o $(BUILD)/$@.vvp $(RTL) $(TB)
	$(VVP) $(BUILD)/$@.vvp

clean:
	rm -rf $(BUILD)
