`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2024 22:17:09
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tb();
reg clk;
parameter clks_per_bit = 543; 
reg i_data_avail;
reg [7:0]i_databyte;
wire o_active;
wire o_tx;
wire o_done;
wire i_rx=o_tx;
wire o_data_avail;
wire [7:0]o_databyte;
uart_txx #(.clks_per_bit(clks_per_bit)) ut (
        .clk(clk),
        .i_data_avail(i_data_avail),
        .i_databyte(i_databyte),
        .o_active(o_active),
        .o_tx(o_tx),
        .o_done(o_done)
    );
uart_rx #(.clks_per_bit(clks_per_bit)) ur (
            .clk(clk),
            .i_rx(i_rx),
            .o_data_avail(o_data_avail),
            .o_databyte(o_databyte)
        );
initial begin
clk=0;
forever #2 clk=~clk;
end
initial begin
i_data_avail=0;
i_databyte=8'b0;
#10;
i_databyte=8'hAB;
i_data_avail=1;
#50;
i_data_avail=0;
#25000 $finish;

end


endmodule
