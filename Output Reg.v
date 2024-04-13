`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 14:49:36
// Design Name: 
// Module Name: Output Reg
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


module Output_Reg(output reg [7:0] data_out, input [7:0] data_in, input reg_clk,
reg_rst, reg_en);
 always @ (posedge reg_clk)
begin
 if (reg_rst)
 data_out <= 8'b0;
 else if (reg_en)
 data_out <= data_in[7:0]; //assign lower four bits
 end
 endmodule
