`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.04.2024 14:32:06
// Design Name:
// Module Name: Decoder
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


module Decoder(
    input clk,
    input rst,
    input [3:0] w,
    output reg a,
    output reg b,
    output reg out_reg,
    output reg [1:0] s,
    output reg mux1,
    output reg mux2,
    output reg alu,
    output reg [3:0] alu_op,
    output reg clraccum,
    output reg ir,
    output reg pc,
    input [3:0] en,
    input flag_bit
  );

  reg int_a;
  reg int_b;
  reg int_out_reg;
  reg [1:0] int_s;
  reg int_alu;
  reg int_clraccum;

  always @(posedge clk or posedge rst)
  begin
    if (rst == 1'b1)
    begin
      a <= 1'b0;
      b <= 1'b0;
      out_reg <= 1'b0;
      s <= 2'b00;
      mux1 <= 1'b0;
      mux2 <= 1'b0;
      alu <= 1'b0;
      clraccum <= 1'b1;
      ir <= 1'b0;
      pc <= 1'b0;
      alu_op <= {4{1'b1}};

      int_a <= 1'b0;
      int_b <= 1'b0;
      int_out_reg <= 1'b0;
      int_s <= 2'b00;
      int_alu <= 1'b0;
      int_clraccum <= 1'b1;
    end
    else if (clk == 1'b1)
    begin
      a <= 1'b0;
      b <= 1'b0;
      out_reg <= 1'b0;
      s <= 2'b00;
      alu <= 1'b0;
      clraccum <= 1'b0;
      ir <= 1'b0;
      pc <= 1'b0;
      int_clraccum <= 1'b0;

      case (en)
        4'b1000:
        begin // T0 - enable the IR
          ir <= 1'b1;
        end
        4'b0100:
        begin // T1 - Decode Instruction
          case (w)
            4'b0000:
              int_a <= 1'b1;  // Load A register from input switches.
            4'b0001:
              int_b <= 1'b1;  // Load B register from input switches.
            4'b0010:
              int_out_reg <= 1'b1;  // Load output register.
            4'b0011:
            begin
              mux1 <= 1'b0;
              int_s <= 2'b11;
            end  // Load shifter with A register contents
            4'b0100:
            begin
              mux1 <= 1'b1;
              int_s <= 2'b11;
            end  // Load shifter with B register contents.
            4'b0101:
              int_s <= 2'b01; // Shift right
            4'b0110:
              int_s <= 2'b10; // Shift left.
            4'b0111:
            begin
              if (flag_bit == 1)
              begin
                mux1 <= 1'b0;
                mux2 <= 1'b0;
                int_alu <= 1'b1;
                alu_op <= 4'b0011;
              end
            end  // If the shifter flag is 1, add contents of A register into accumulator.
            4'b1000:
            begin
              if (flag_bit == 1)
              begin
                mux2 <= 1'b1;
                int_alu <= 1'b1;
                alu_op <= 4'b0011;
              end
            end  // If the shifter flag is 1, add contents of shifter into accumulator.
            4'b1001:
            begin
              int_alu <= 1'b1;
              alu_op <= 4'b0011;
            end  // Add the ALU inputs.
            4'b1010:
            begin
              int_alu <= 1'b1;
              alu_op <= 4'b0100;
            end  // Subtract the ALU inputs.
            4'b1011:
            begin
              int_alu <= 1'b1;
              alu_op <= 4'b0110;
            end  // Bitwise invert an ALU input.
            4'b1100:
            begin
              int_alu <= 1'b1;
              alu_op <= 4'b0000;
            end  // Bitwise AND the ALU inputs.
            4'b1101:
            begin
              int_alu <= 1'b1;
              alu_op <= 4'b0001;
            end  // Bitwise OR the ALU inputs.
            4'b1110:
            begin
              int_alu <= 1'b1;
              alu_op <= 4'b0010;
            end  // Bitwise XOR the ALU inputs
            4'b1111:
              int_clraccum <= 1'b1;  // Clear the contents of the accumulator.
          endcase
        end
        4'b0010:
        begin // T2 - Execute Instruction
          a <= int_a;
          b <= int_b;
          out_reg <= int_out_reg;
          s <= int_s;
          alu <= int_alu;
          clraccum <= int_clraccum;
        end
        4'b0001:
        begin // T3 - enable the program counter
          int_a <= 1'b0;
          int_b <= 1'b0;
          int_out_reg <= 1'b0;
          int_s <= 1'b0;
          int_alu <= 1'b0;
          int_clraccum <= 1'b0;
          pc <= 1'b1;
        end
      endcase
    end
  end

endmodule
