# 4×4 Serial Multiplier (Verilog)

A class project: a 4-bit × 4-bit multiplier with a serial interface. The two operands
are shifted in one bit at a time, multiplied, and the 8-bit product is shifted back out
serially, with a small state machine running the input → multiply → output sequence.

Written and simulated with Cadence Xcelium; it also runs under Icarus Verilog.

## Files

- `rtl/` — the design
  - `Multiplier.v` — top module, wires everything together
  - `controller.v` — state machine
  - `serial_in8.v` / `serial_out8.v` — serial in / out shift registers
  - `multiplier4.v` — combinational 4×4 multiplier (`half_adder2.v`, `full_adder.v`)
- `tb/` — testbenches for the modules

## Running it

With Icarus Verilog:

```sh
iverilog -s Multiplier_tb -o sim.vvp rtl/*.v tb/Multiplier_tb.v && vvp sim.vvp
```

Swap in any other `tb/*.v` file (with its module name after `-s`) to run a single block.
With Cadence Xcelium: `xrun rtl/*.v tb/Multiplier_tb.v`.

## License

MIT
