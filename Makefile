# 4x4 serial-in / serial-out multiplier — Icarus Verilog build
IVERILOG ?= iverilog
VVP      ?= vvp
RTL      := $(wildcard rtl/*.v)
BUILD    := build

.PHONY: sim multiplier4 controller serial_out8 top clean

# Default: build + run the self-terminating unit testbenches.
sim: multiplier4 controller serial_out8

# top module of each unit testbench
multiplier4:  TOP := multiplier4_tb
controller:   TOP := controller_tb
serial_out8:  TOP := serial_out8_tb

# testbench source for each unit target
multiplier4:  TB := tb/multiplier4_tb.v
controller:   TB := tb/controller_tb.v
serial_out8:  TB := tb/serial_out8_tb.v

multiplier4 controller serial_out8:
	@mkdir -p $(BUILD)
	$(IVERILOG) -s $(TOP) -o $(BUILD)/$@.vvp $(RTL) $(TB)
	$(VVP) $(BUILD)/$@.vvp

# Full-design testbench. Multiplier_tb ends with $stop, an interactive pause
# under Cadence Xcelium; Icarus vvp does not terminate on $stop (it keeps the
# forever-clock running), so this target only *elaborates* it. Run the complete
# simulation with Xcelium:  xrun rtl/*.v tb/Multiplier_tb.v
top:
	@mkdir -p $(BUILD)
	$(IVERILOG) -s Multiplier_tb -o $(BUILD)/top.vvp $(RTL) tb/Multiplier_tb.v
	@echo "Elaborated $(BUILD)/top.vvp — run the full sim under Cadence Xcelium (xrun)."

clean:
	rm -rf $(BUILD)
