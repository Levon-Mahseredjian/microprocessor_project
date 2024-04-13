`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 14:48:36
// Design Name: 
// Module Name: Accumulator
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


module Accumulator_reg(output reg [7:0] data_out, input [7:0] data_in, input reg_clk,
reg_rst, reg_en);
 always @ (posedge reg_clk)
begin
 if (reg_rst)
 data_out <= 8'b0;
 else if (reg_en)
 data_out <= data_in;
 end
 endmodule