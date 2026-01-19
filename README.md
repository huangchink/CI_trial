# Verilog Adder Pre-simulation Project

Simple 4-bit Adder module with pre-simulation test setup using Icarus Verilog.

## Files

- **adder.v** - Simple 4-bit adder module
- **adder_tb.v** - Testbench for the adder
- **.github/workflows/verilog-sim.yml** - CI pipeline configuration

## Local Testing

To run the simulation locally:

```bash
# Install Icarus Verilog (if not already installed)
# Ubuntu/Debian:
sudo apt-get install iverilog

# macOS:
brew install icarus-verilog

# Windows: Download from http://iverilog.icarus.com/
```

Run simulation:
```bash
iverilog -o adder_sim adder.v adder_tb.v
vvp adder_sim
```

Generate VCD file for waveform viewing:
```bash
iverilog -g2009 -o adder_sim_vcd adder.v adder_tb.v
vvp adder_sim_vcd -vcd adder.vcd
```

## CI/CD

The project uses GitHub Actions to automatically run pre-simulation on every push and pull request. The workflow:
1. Installs Icarus Verilog
2. Compiles the Verilog files
3. Runs simulation
4. Generates VCD waveform file

VCD artifacts are automatically uploaded for download.
