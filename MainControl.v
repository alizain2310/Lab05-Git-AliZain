`timescale 1ns / 1ps
module MainControl(
    input wire [6:0] opcode,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg Branch
);
    always @(*) begin
        // 1. Set safe defaults for ALL signals to prevent latching and carry-over bugs
        RegWrite = 1'b0;
        ALUOp    = 2'b00;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        Branch   = 1'b0;

        // 2. Override only the signals required for each instruction type
        case (opcode)
            7'b0110011: begin // R-type arithmetic/logical instructions (add, sub, etc.)
                RegWrite = 1'b1;
                ALUOp    = 2'b10;
            end
            7'b0010011: begin // I-type arithmetic (ADDI)
                RegWrite = 1'b1;
                ALUOp    = 2'b00;
                ALUSrc   = 1'b1;
            end
            7'b0000011: begin // Loads (LW)
                RegWrite = 1'b1;
                ALUOp    = 2'b00;
                MemRead  = 1'b1;
                ALUSrc   = 1'b1;
                MemtoReg = 1'b1;
            end
            7'b0100011: begin // Stores (SW)
                ALUOp    = 2'b00;
                MemWrite = 1'b1;
                ALUSrc   = 1'b1;
            end
            7'b1100011: begin // BEQ (Branch)
                ALUOp    = 2'b01;
                Branch   = 1'b1;
            end
            default: begin
                // Defaults are already handled at the top
            end
        endcase
    end
endmodule