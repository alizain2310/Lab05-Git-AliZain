`timescale 1ns / 1ps
module branchAdder(
    input wire [31:0] PC,
    input wire [31:0] Imm,
    output wire [31:0] BranchTarget
);
    // For B-type instructions immGen already appends the required bit 0.
    // Therefore Imm is the sign-extended, byte-aligned branch displacement.
    assign BranchTarget = PC + Imm;
endmodule
