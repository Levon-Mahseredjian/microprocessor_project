`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 14:41:32
// Design Name: 
// Module Name: IR
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

module Reg_Great(output reg [3:0] data_out, input [3:0] data_in, input reg_clk, 
reg_rst, reg_en);
always @ (posedge reg_clk) 
begin
if (reg_rst)
data_out <= 4'b0000;
else if (reg_en)
data_out <= data_in;
end
endmodule

