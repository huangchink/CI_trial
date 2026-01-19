// Simple I2C master for a single write transaction (behavioral, simulation-focused)
`timescale 1ns / 1ps

module i2c_master(
    input        start,
    input  [6:0] addr,
    input  [7:0] data,
    output reg   busy,
    output reg   done,
    output reg   ack_error,
    output reg   scl,
    inout        sda
);
    parameter integer T_HALF = 50;

    reg  sda_drive;
    wire sda_in;
    reg  ack;

    assign sda = sda_drive ? 1'b0 : 1'bz;
    assign sda_in = sda;

    task i2c_clock_low;
    begin
        scl = 1'b0;
        #(T_HALF);
    end
    endtask

    task i2c_clock_high;
    begin
        scl = 1'b1;
        #(T_HALF);
    end
    endtask

    task i2c_send_bit;
    input bit_val;
    begin
        i2c_clock_low();
        sda_drive = (bit_val == 1'b0);
        i2c_clock_high();
    end
    endtask

    task i2c_send_byte;
    input [7:0] byte_val;
    integer i;
    begin
        for (i = 7; i >= 0; i = i - 1) begin
            i2c_send_bit(byte_val[i]);
        end
    end
    endtask

    task i2c_read_ack;
    output ack_val;
    begin
        i2c_clock_low();
        sda_drive = 1'b0; // release SDA for slave ACK
        i2c_clock_high();
        ack_val = (sda_in == 1'b0);
        i2c_clock_low();
    end
    endtask

    initial begin
        scl = 1'b1;
        sda_drive = 1'b0;
        busy = 1'b0;
        done = 1'b0;
        ack_error = 1'b0;
        ack = 1'b0;
    end

    always @(posedge start) begin
        if (!busy) begin
            busy = 1'b1;
            done = 1'b0;
            ack_error = 1'b0;

            // START condition: SDA goes low while SCL is high
            sda_drive = 1'b0;
            scl = 1'b1;
            #(T_HALF);
            sda_drive = 1'b1;
            #(T_HALF);

            // Address + write bit
            i2c_send_byte({addr, 1'b0});
            i2c_read_ack(ack);
            if (!ack) begin
                ack_error = 1'b1;
            end

            // Data byte
            i2c_send_byte(data);
            i2c_read_ack(ack);
            if (!ack) begin
                ack_error = 1'b1;
            end

            // STOP condition: SDA goes high while SCL is high
            i2c_clock_low();
            sda_drive = 1'b1;
            i2c_clock_high();
            sda_drive = 1'b0;
            #(T_HALF);

            busy = 1'b0;
            done = 1'b1;
            #(T_HALF);
            done = 1'b0;
        end
    end
endmodule
