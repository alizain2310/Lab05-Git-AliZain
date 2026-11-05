`timescale 1ns / 1ps
module ALU_32bit(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUControl,
    output reg [31:0] Result,
    output wire Zero
);
    // Operation codes are kept consistent with Lab 6:
    // AND=0, OR=1, XOR=2, ADD=3, SLL=4, SRL=5, SUB=6.
    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A & B;
            4'b0001: Result = A | B;
            4'b0010: Result = A ^ B;
            4'b0011: Result = A + B;
            4'b0100: Result = A << B[4:0];
            4'b0101: Result = A >> B[4:0];
            4'b0110: Result = A - B;
            default: Result = 32'b0;
        endcase
    end
    assign Zero = (Result == 32'b0);
endmodule
