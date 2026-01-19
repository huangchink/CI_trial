#!/bin/bash
# Local simulation script

echo "Compiling Verilog files..."
iverilog -g2009 -o adder_sim adder.v adder_tb.v

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo ""
    echo "Running simulation..."
    vvp adder_sim

    if [ -f adder.vcd ]; then
        echo ""
        echo "VCD generated: adder.vcd"
    fi
else
    echo "Compilation failed!"
    exit 1
fi

echo ""
echo "Compiling I2C files..."
iverilog -g2009 -o i2c_sim I2C.v I2C_tb.v

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo ""
    echo "Running simulation..."
    vvp i2c_sim

    if [ -f i2c.vcd ]; then
        echo ""
        echo "VCD generated: i2c.vcd"
    fi
else
    echo "Compilation failed!"
    exit 1
fi
