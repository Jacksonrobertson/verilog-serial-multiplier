# 4×4 Serial-In / Serial-Out Multiplier (Verilog)

A 4-bit × 4-bit unsigned multiplier with a **serial (bit-at-a-time) interface**. Two
4-bit operands are shifted in one bit per clock, multiplied by a combinational array
multiplier, and the 8-bit product is shifted back out serially. A small Moore finite
state machine sequences the input → multiply → output phases.

The design was written and simulated with Cadence Xcelium; it is plain Verilog-2001 and
also runs under the open-source [Icarus Verilog](https://steveicarus.github.io/iverilog/)
simulator (see [Simulation](#simulation)).

## How it works

```
             ┌────────────────────────────── multiplier (top) ──────────────────────────────┐
             │                                                                               │
  start ───▶ │   ┌────────────┐  serial_in_en   ┌────────────┐   ┌────────────┐  serial_out_en│
  clock ───▶ │   │ controller │────────────┐    │ serial_in8 │   │ serial_out8│◀───────┐      │
  reset ───▶ │   │   (FSM)    │            └───▶ │  (SIPO +   │   │  (PISO)    │        │      │
             │   └─────┬──────┘  serial_out_en   │   load)    │   └─────┬──────┘        │      │
   in  ──────┼─────────┼──────────────────▶ in ─▶│            │         │ out ──────────┼───▶ out
             │         │                          └─────┬──────┘         ▲               │      │
             │       done                       out_0[7:0]              │               │      │
             │         │                               ▼         out_1[7:0]             │      │
             │         │                        ┌──────────────┐        │               │      │
             │         └──────────────▶ done    │ multiplier4  │────────┘               │      │
             │                                  │ (comb. 4×4)  │                        │      │
             │                                  └──────┬───────┘                        │      │
             │                                    half_adder2 / full_adder              │      │
             └───────────────────────────────────────────────────────────────────────────────┘
```

Data path: `in` → **serial_in8** → `out_0[7:0]` → **multiplier4** → `out_1[7:0]` →
**serial_out8** → `out`.

The 8 bits loaded into `serial_in8` are the two operands packed together
(`in[3:0] = a`, `in[7:4] = b`); `multiplier4` produces the 8-bit product `a × b`.

### Controller FSM (Moore)

| State  | Meaning                        | `serial_in_en` | `serial_out_en` | `done` |
|--------|--------------------------------|:--------------:|:---------------:|:------:|
| IDLE   | wait for `start`               | 0 | 0 | 0 |
| INPUT  | shift 8 bits into `serial_in8` | 1 | 0 | 0 |
| MULT   | latch product into `serial_out8` | 0 | 1 | 0 |
| OUTPUT | shift 8 product bits out        | 0 | 0 | 1 |

An internal 3-bit counter times the 8-clock INPUT and OUTPUT phases. `reset` is
**active-low**.

## Repository layout

```
rtl/                 synthesizable design
├── Multiplier.v     top module `multiplier` — wires the blocks together
├── controller.v     sequencing FSM
├── serial_in8.v     8-bit serial-in shift register with load latch
├── serial_out8.v    8-bit serial-out (parallel-load) shift register
├── multiplier4.v    combinational 4×4 array multiplier
├── half_adder2.v    half adder (building block)
└── full_adder.v     full adder (built from two half adders)
tb/                  testbenches
├── Multiplier_tb.v  top-level end-to-end test
├── controller_tb.v  FSM test
├── multiplier4_tb.v combinational multiplier test
├── serial_out8_tb.v serial-out shift register test
└── serial_in8_tb.v  (module `serial_out8_tb`; a near-duplicate of the serial-out bench)
Makefile             Icarus Verilog build/run targets
```

## Module reference

| Module        | Ports |
|---------------|-------|
| `multiplier`  | in: `clock, reset, start, in`; out: `done, out` |
| `controller`  | in: `clock, reset, start`; out: `done_flag, serial_in_en, serial_out_en` |
| `serial_in8`  | in: `in, reset, clock, load`; out: `out[7:0]` |
| `serial_out8` | in: `in[7:0], reset, clock, load`; out: `out` |
| `multiplier4` | in: `in[7:0]`; out: `out[7:0]` |
| `full_adder`  | in: `a, b, cin`; out: `y, cout` |
| `half_adder2` | in: `a, b`; out: `y, c` |

## Simulation

### Icarus Verilog (open source)

```sh
make             # build + run the self-terminating unit testbenches
make multiplier4 # combinational multiplier testbench
make controller  # FSM testbench
make serial_out8 # serial-out shift register testbench
make top         # elaborate the full-design testbench (see note)
make clean
```

Each unit target compiles the design plus one testbench into `build/` and runs it
with `vvp`. The full-design testbench (`Multiplier_tb`) ends with `$stop` — an
interactive pause under Cadence Xcelium. Icarus `vvp` does not terminate on `$stop`,
so `make top` only elaborates it; run the complete simulation with Xcelium.

### Cadence Xcelium (original toolchain)

```sh
xrun rtl/*.v tb/Multiplier_tb.v
```

## License

Released under the [MIT License](LICENSE).
