`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.04.2024 14:44:03
// Design Name:
// Module Name: MUX 1
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


module MUX_2_1(output[7:0]Y, input[7:0]A, B, input S);

  assign Y = S ? B : A;

endmodule
