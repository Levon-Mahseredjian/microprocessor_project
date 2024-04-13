`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 21:51:13
// Design Name: 
// Module Name: rst_cntrl
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


module rst_cntrl(
    input clock,
    input reset_in_n,
    output reset_out
    );
    
    reg [7:0] reset_debounce;
    reg reset_out_n;
    
    always @(posedge clock)
        begin
            if (reset_in_n == 1'b0)
                begin
                    reset_out_n <= 1'b0; // Reset is active
                    reset_debounce <= 'b0;
                end
            else
                begin
                    {reset_out_n,reset_debounce} <= {reset_debounce, reset_in_n};
                end
        end
    
    assign reset_out = ~reset_out_n;
    
endmodule
