# Verilog Pre-simulation Project

Simple 4-bit Adder and I2C master modules with pre-simulation test setup using Icarus Verilog.

## Files

- **adder.v** - Simple 4-bit adder module
- **adder_tb.v** - Testbench for the adder
- **I2C.v** - Simple I2C master module
- **I2C_tb.v** - Testbench for the I2C master
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
iverilog -g2009 -o adder_sim adder.v adder_tb.v
vvp adder_sim

iverilog -g2009 -o i2c_sim I2C.v I2C_tb.v
vvp i2c_sim
```

Generate VCD file for waveform viewing:
```bash
iverilog -g2009 -o adder_sim_vcd adder.v adder_tb.v
vvp adder_sim_vcd

iverilog -g2009 -o i2c_sim_vcd I2C.v I2C_tb.v
vvp i2c_sim_vcd
```

## CI/CD

The project uses GitHub Actions to automatically run pre-simulation on every push and pull request. The workflow:
1. Installs Icarus Verilog
2. Compiles the Verilog files
3. Runs simulation
4. Generates VCD waveform files

VCD artifacts are automatically uploaded for download.
