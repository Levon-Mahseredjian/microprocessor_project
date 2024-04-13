`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.04.2024 20:40:23
// Design Name:
// Module Name: Test_BN
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

// Simple Verilog Testbench Wrapper
module tb_processor;

  // Declare the signals
  reg clk =0;
  reg reset;
  reg BTNU;
  reg [3:0] SW_A, SW_B;
  wire [7:0] LED;

  // Instantiate the design under test (DUT)
  // Replace "your_dut_module" with the actual name of your design module
  microprocessor dut
       (.BTNU(BTNU),
        .CLK100MHZ(clk),
        .CPU_RESETN(reset),
        .LED(LED),
        .SW_A(SW_A),
        .SW_B(SW_B));

  // Generate a 100 MHz clock
  always #5 clk = ~clk; // Half-period of 5 time units (ns, ps, etc.)

  integer i,j;

  // Initialize/reset the DUT
  initial begin
    for (i=0; i<16; i=i+1) begin
      for (j=0; j<16; j=j+1) begin
        reset = 0; // Assert reset
        BTNU = 0;
        SW_A = i;
        SW_B = j;
        #90; // Wait for 10 time units
        reset = 1; // Deassert reset
        #120; // Simulate for some time
        BTNU = 1;
        #50;
        BTNU = 0;
        #1600;
      end
    end
    $finish; // End simulation
  end

endmodule