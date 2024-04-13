`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.04.2024 14:45:27
// Design Name:
// Module Name: Shifter
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

module Shifter(
    input clk,
    input rst,
    input [1:0] s,
    input [7:0] din,
    output [7:0] so,
    output flag
  );

  reg [8:0] q;

  always @(posedge clk or posedge rst)
  begin
    if (rst)
      q <= {9{1'b0}};
    else
    case (s)
      2'b11 : // Load din
        q <= {din, q[0]};
      2'b01 : // Shift Right
        q <= q >> 1;
      2'b10 : // Shift Left
      begin
        q[8:1] <= q[8:1] << 1;
        q[0] <= q[0];
      end
      default:
        q <= q;
    endcase
  end

  assign flag = q[0];
  assign so = q[8:1];

endmodule
