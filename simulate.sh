#!/bin/bash
# Local simulation script

echo "Compiling Verilog files..."
iverilog -o adder_sim adder.v adder_tb.v

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo ""
    echo "Running simulation..."
    vvp adder_sim
else
    echo "Compilation failed!"
    exit 1
fi
