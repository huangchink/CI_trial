// Testbench for simple I2C master
`timescale 1ns / 1ps

module i2c_tb();
    reg        start;
    reg  [6:0] addr;
    reg  [7:0] data;
    wire       scl;
    tri        sda;
    wire       busy;
    wire       done;
    wire       ack_error;

    // Pull-up to model idle-high bus
    pullup(sda);

    // Simple slave ACK generator (ack the first two bytes)
    reg sda_slave_drive;
    assign sda = sda_slave_drive ? 1'b0 : 1'bz;

    i2c_master dut (
        .start(start),
        .addr(addr),
        .data(data),
        .busy(busy),
        .done(done),
        .ack_error(ack_error),
        .scl(scl),
        .sda(sda)
    );

    reg [3:0] bit_count;
    reg [1:0] byte_count;

    initial begin
        bit_count = 4'd0;
        byte_count = 2'd0;
        sda_slave_drive = 1'b0;
    end

    // Count 9 SCL edges per byte (8 data + 1 ACK)
    always @(posedge scl or negedge busy) begin
        if (!busy) begin
            bit_count <= 4'd0;
            byte_count <= 2'd0;
        end else begin
            if (bit_count == 4'd8) begin
                bit_count <= 4'd0;
                byte_count <= byte_count + 1'b1;
            end else begin
                bit_count <= bit_count + 1'b1;
            end
        end
    end

    // Drive ACK during the 9th clock (SCL low-to-high transition)
    always @(negedge scl or negedge busy) begin
        if (!busy) begin
            sda_slave_drive <= 1'b0;
        end else begin
            if ((bit_count == 4'd8) && (byte_count < 2'd2)) begin
                sda_slave_drive <= 1'b1;
            end else begin
                sda_slave_drive <= 1'b0;
            end
        end
    end

    initial begin
        $dumpfile("i2c.vcd");
        $dumpvars(0, i2c_tb);
    end

    initial begin
        start = 1'b0;
        addr = 7'h42;
        data = 8'hA5;

        #100;
        $display("Starting I2C write");
        start = 1'b1;
        #20;
        start = 1'b0;

        wait (done == 1'b1);
        #20;

        if (ack_error) begin
            $display("I2C ACK error");
            $fatal;
        end else begin
            $display("I2C transaction complete");
        end

        #100;
        $finish;
    end
endmodule
