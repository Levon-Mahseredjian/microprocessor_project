`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2024 14:35:41
// Design Name: 
// Module Name: ALU
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

module ALU #(
    parameter DATA_SIZE = 8,
    parameter OP_CODE_SIZE = 4
) (
    input [(DATA_SIZE)-1:0]         A, B,                   // Data Inputs
//    input                           CARRY_IN,               // Carry In
    input [(OP_CODE_SIZE)-1:0]      OP_CODE,                // ALU Operator Instruction
    input                           CLOCK, RESET, ENABLE,   // Enable = ALL Inputs Valid i.e. A, B, CARRY_IN & OP_CODE!
    output reg [(DATA_SIZE)-1:0]    RESULT,                 // ALU Operation Output
    output reg                      VALID_OUT              // ALU Result is Valid
//    output reg                      CARRY_OUT               // Carry Out
);
   
reg CARRY_IN = 0;
reg CARRY_OUT = 0;

always @ (posedge CLOCK, posedge RESET) begin
    if (RESET == 1'b1) begin
        RESULT      <= {DATA_SIZE{1'b0}};
        VALID_OUT   <= 1'b0;
        CARRY_OUT   <= 1'b0;
    end
    else if (CLOCK == 1'b1) begin
        if (ENABLE == 1'b1) begin
            case(OP_CODE)
                4'b0000: /* AND */ begin
                    {CARRY_OUT,RESULT}  <= {1'b0,A} & {CARRY_IN,B};  
                    VALID_OUT           <= 1'b1;                     
                end
                4'b0001: /* OR */ begin
                    RESULT <= A | B;
                    VALID_OUT <= 1'b1;
                end
                4'b0010: /* XOR */ begin
                    RESULT <= A ^ B;
                    VALID_OUT <= 1'b1;
                end
                4'b0011: /* ADD */ begin
                    {CARRY_OUT,RESULT} <= {1'b0,A} + {CARRY_IN,B}; 
                    VALID_OUT <= 1'b1;   
                end
                4'b0100: /* SUBB */ begin
                    {CARRY_OUT,RESULT} <= {1'b0,A} - {CARRY_IN,B};  
                    VALID_OUT <= 1'b1;
                end
                4'b0101: /* BIT-WISE INVERSION A */ begin          
                    RESULT <= ~A;
                    VALID_OUT <= 1'b1;
                end
                4'b0110: /* BIT-WISE INVERSION B */ begin
                    RESULT <= ~B;
                    VALID_OUT <= 1'b1;
                end
                4'b0111: /* Push B to Result */ begin
                    RESULT <= B;
                    VALID_OUT <= 1'b1;
                end
                default: VALID_OUT <= 1'b0;
            endcase
        end else begin
            VALID_OUT <= 1'b0;
        end
    end
end

endmodule
