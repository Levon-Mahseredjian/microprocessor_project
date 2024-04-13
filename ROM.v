`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 10.04.2024 14:40:16
// Design Name:
// Module Name: ROM
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


module My_ROM #(prog_size = 32) (
    input wire clk,
    input wire clr,
    input wire [ $clog2(prog_size)-1:0] addr,  // N-bits depending on length of program
    output reg [3:0] data   // 4-bits OP-CODE ALWAYS
);

localparam cntr_size = $clog2(prog_size);

always @(posedge clk or posedge clr) begin
    if (clr) begin
        data <= {cntr_size{1'b0}}; // Reset data to 0 when clear signal is asserted
    end else begin
        case(addr)
            5'd0 : data <= 4'b0000; // LD A
            5'd1 : data <= 4'b0001; // LD B
            5'd2 : data <= 4'b0100; // LD SH B
            5'd3 : data <= 4'b0101; // SHR
            5'd4 : data <= 4'b0111; // ACC NZ A
            5'd5 : data <= 4'b0101; // SHR
            5'd6 : data <= 4'b0011; //LD SH A
            5'd7 : data <= 4'b0110; //SHL
            5'd8 : data <= 4'b1000; // ACC NZ SH
            5'd9 : data <= 4'b0100; //LB SH B
            5'd10: data <= 4'b0101; //SHR
            5'd11: data <= 4'b0101; //SHR
            5'd12 : data <= 4'b0101; // SHR
            5'd13 : data <= 4'b0011; //LD SH A
            5'd14 : data <= 4'b0110; //SHL
            5'd15 : data <= 4'b0110; //SHL
            5'd16 : data <= 4'b1000; // ACC NZ SH
            5'd17 : data <= 4'b0100; //LB SH B
            5'd18 : data <= 4'b0101; //SHR
            5'd19 : data <= 4'b0101; //SHR
            5'd20 : data <= 4'b0101; //SHR
            5'd21 : data <= 4'b0101; //SHR
            5'd22 : data <= 4'b0011; //LD SH A
            5'd23 : data <= 4'b0110; //SHL
            5'd24 : data <= 4'b0110; //SHL
            5'd25 : data <= 4'b0110; //SHL
            5'd26 : data <= 4'b1000; // ACC NZ SH
            5'd27 : data <= 4'b0010; // LD O
            5'd28 : data <= 4'b1111; // CLR ACC
            5'd29 : data <= 4'b1111; // CLR ACC
            5'd30 : data <= 4'b1111; //CLR ACC
            5'd31 : data <= 4'b1111; // CLR ACC


            default: data <= {4'b0}; // Default case
        endcase
    end
end

endmodule