`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 14:37:32
// Design Name: 
// Module Name: Ring Counter
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


module Ring_counter(q, clk, clr, en, calc_done);
  input clk, clr, en, calc_done;
  output [3:0] q;
  reg [3:0] q;

  reg [3:0] start_counter;
  reg go;
  
  always @(posedge clk) begin
    begin
        // Reset counter enable
        if (clr == 1'b1)
            begin
                go <= 1'b0;
                start_counter <= 'b0;
            end
        else
            begin            
            // Use shift-register to debounce button input
            {start_counter} <= {start_counter[2:0], en};
            
            // Start timer on settled button input
            if (start_counter[3] == 1'b1)
                go <= 1'b1;
            else if (calc_done == 1'b1)
                go <= 1'b0;
            end
    end
  end

  always @(posedge clk) begin
    if (clr == 1) // Active-high clear
      q <= 4'b1000;
    else begin
       if (go)
            q <= {q[0],q[3:1]};
    end
  end
endmodule