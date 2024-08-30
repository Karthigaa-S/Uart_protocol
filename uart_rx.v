`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2024 20:56:11
// Design Name: 
// Module Name: uart_rx
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


module uart_rx
#(parameter clks_per_bit=543)
(input clk,input i_rx,output o_data_avail,output [7:0]o_databyte);
localparam idle=2'b00;
localparam start=2'b01;
localparam get_bit=2'b10;
localparam stop=2'b11;
reg rx_buffer=1'b1;
reg rx=1'b1;
reg [1:0]state=0;
reg [15:0]counter=0;
reg [2:0]bit_index=0;
reg data_avail=0;
reg [7:0]data_byte=0;
assign o_data_avail=data_avail;
assign o_databyte=data_byte;
always @(posedge clk)
begin 
rx_buffer<=i_rx;
rx<=rx_buffer;
end 
always @(posedge clk)
begin
case(state)
idle:
begin
data_avail<=0;
counter<=0;
bit_index<=0;
if(rx==0)
state<=start;
else
state<=idle;
end
start:
begin
if(counter==(clks_per_bit-1)/2)
begin 
if (rx==0)
begin
counter<=0;
state<=get_bit;
end
else
begin
state<=idle;
end
end
else
begin
counter<=counter+16'b1;
state<=start;
end
end
get_bit:
begin
if (counter<clks_per_bit-1)
begin
counter<=counter+16'b1;
state<=get_bit;
end
else
begin
counter<=0;
data_byte[bit_index]<=rx;
if(bit_index<7)
begin
bit_index<=bit_index+3'b1;
state<=get_bit;
end
else
begin
bit_index<=0;
state<=stop;
end
end
end
stop:
begin
if(counter<clks_per_bit-1)
begin
counter<=counter+16'b1;
state<=stop;
end
else
begin
data_avail<=1;
counter<=0;
state<=idle;
end
end
default:
state<=idle;
endcase
end
endmodule
