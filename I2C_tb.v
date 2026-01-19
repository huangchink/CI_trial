`timescale 1ns / 10ps

module i2c_tb();

localparam durTime = 5*1000;
reg sysClk, rst_n, tick_tx, sda_i;
reg [7:0]addr_i, data_i;
wire [15:0]data_o;
wire SCL;
wire SDA;
integer i;
assign SDA = (sda_i==1'b1)?1'bz:1'b0;
pullup(SDA);

usage_I2C_write_R_W UUT(
  .en(tick_tx),
  .clk_sys(sysClk),
  .rst_n(rst_n),
  .addr(addr_i),
  .data_i(data_i),
  .SCLK(SCL),
  .SDA(SDA),
  .data_o(data_o)
);

always@(negedge SCL, negedge rst_n)begin
  if(!rst_n)sda_i <= 1'b1;
  else if(i==8||i==17||i==27||i==28||i==36||i==35||i==43)#2000 sda_i <= 1'b0;//<27 for write
  else#2000 sda_i <= 1'b1;
end

always@(posedge SCL, negedge rst_n)begin
  if(!rst_n)i <= 0;
  else i <= i + 1;
end

always #10 sysClk = ~sysClk;

initial begin
  sysClk  = 0;
  rst_n   = 1;
  tick_tx = 0;
  sda_i   = 1'b1;
  addr_i  = 8'hA6;
  data_i  = 8'h81;
  #50 rst_n   = 0;
  #50 rst_n   = 1;

  #10 tick_tx = 1;
  #10 tick_tx = 0;

  repeat(50) #durTime;

  addr_i  = 8'hA7;
  #10 tick_tx = 1;
  #10 tick_tx = 0;

  repeat(100) #durTime;

  $finish;

end

endmodule
