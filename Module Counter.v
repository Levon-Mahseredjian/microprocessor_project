`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 14:42:55
// Design Name: 
// Module Name: Module Counter
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

// Program Counter size depends on length of program
module counter #(prog_size = 32) (sys_clk, sys_rst, en, cnt);


input sys_clk;
input sys_rst;
input en;
output [$clog2(prog_size)-1:0] cnt;

localparam cntr_size = $clog2(prog_size);

reg [$clog2(prog_size)-1:0] cnt;

always @ (posedge sys_clk) begin
    if (sys_rst) 
        cnt <= {cntr_size{1'b0}};
    else if (en)
        cnt <= cnt + 1'b1;
    end
endmodule
