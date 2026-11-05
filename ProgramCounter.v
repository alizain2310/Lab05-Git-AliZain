`timescale 1ns / 1ps
module ProgramCounter(
    input wire clk,
    input wire rst,
    input wire [31:0] PC_Next,
    output reg [31:0] PC
);
    // Synchronous reset, consistent with the lab manual.
    always @(posedge clk) begin
        if (rst)
            PC <= 32'b0;
        else
            PC <= PC_Next;
    end
endmodule
