`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.08.2024 21:40:37
// Design Name: 
// Module Name: uart_txx
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


module uart_txx
#(parameter clks_per_bit=543)
(input clk,input i_data_avail,input [7:0]i_databyte,output reg o_active,output reg o_tx,output reg o_done);
localparam idle=2'b00;
localparam start=2'b01;
localparam sendbit=2'b10;
localparam stop=2'b11;
reg [1:0]state=0;
reg [15:0]counter=0;
reg [2:0]bitind=0;
reg [7:0]databyte=0;
always @(posedge clk)
begin
case(state)
idle:
begin
o_tx<=1;
o_done<=0;
counter<=0;
bitind<=0;
if (i_data_avail==1)
begin
o_active<=1;
databyte<=i_databyte;
state<=start;
end
else
begin
state<=idle;
o_active<=0;
end
end
start:
begin
o_tx<=0;
if(counter<clks_per_bit-1)
begin
counter<=counter+16'b1;
state<=start;
end
else 
begin
counter<=0;
state<=sendbit;
end
end
sendbit:
begin
o_tx<=databyte[bitind];
if(counter<clks_per_bit-1)
begin
counter<=counter+16'b1;
state<=sendbit;
end
else
begin
counter<=0;
if(bitind<7)
begin
bitind<=bitind+3'b1;
state<=sendbit;
end
else
begin
bitind<=0;
state<=stop;
end
end
end
stop:
begin
o_tx<=1;
if(counter<clks_per_bit-1)
begin
counter<=counter+16'b1;
state<=stop;
end
else
begin
o_done<=1;
state<=idle;
o_active<=0;
end
end
default:
state<=idle;
endcase
end
endmodule
