// Testbench for Adder Module
`timescale 1ns / 1ps

module adder_tb();
    reg  [3:0] a, b;
    wire [4:0] sum;

    // Instantiate the adder module
    adder uut (
        .a(a),
        .b(b),
        .sum(sum)
    );

    initial begin
        // Test cases
        $display("Starting Adder Testbench");
        $display("Time | A | B | Sum | Expected");
        
        // Test 1: 0 + 0
        a = 4'b0000; b = 4'b0000;
        #10 $display("%3d  | %d | %d | %d   | %d", $time, a, b, sum, 0);
        
        // Test 2: 5 + 3 = 8
        a = 4'b0101; b = 4'b0011;
        #10 $display("%3d  | %d | %d | %d   | %d", $time, a, b, sum, 8);
        
        // Test 3: 15 + 1 = 16
        a = 4'b1111; b = 4'b0001;
        #10 $display("%3d  | %d | %d | %d   | %d", $time, a, b, sum, 16);
        
        // Test 4: 7 + 8 = 15
        a = 4'b0111; b = 4'b1000;
        #10 $display("%3d  | %d | %d | %d   | %d", $time, a, b, sum, 15);
        
        $finish;
    end
endmodule
