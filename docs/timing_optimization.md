# Timing Optimization

## Overview

After completing the RTL-to-GDSII implementation of the 32-bit RV32I pipelined RISC-V processor, post-layout Static Timing Analysis (STA) was performed to evaluate the timing performance of the physical implementation.

The initial implementation showed significant setup timing violations. Timing optimization was therefore performed at both the RTL and physical-design levels while keeping the functional behavior and timing constraints consistent.

The optimization process focused on:

- RTL datapath optimization
- Forwarding logic optimization
- ALU logic evaluation
- Multiplexer implementation
- Physical-design optimization
- Buffering and timing-driven placement
- Post-CTS timing optimization
- Post-routing timing analysis

---

## Timing Constraint

The design was evaluated for a target clock period of:

```text
Clock period = 10 ns
Target frequency = 100 MHz
