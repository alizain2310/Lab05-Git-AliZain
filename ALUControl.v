`timescale 1ns / 1ps
module ALUControl(
    input wire [6:0] opcode,
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] ALUControlSignal
);
    // Encodings match ALU_32bit.v and the Lab 6 ALU.
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControlSignal = 4'b0011; // ADD for address / ADDI
            2'b01: ALUControlSignal = 4'b0110; // SUB for BEQ comparison
            2'b10: begin
                case (funct3)
                    3'b000: begin
                        if ((opcode == 7'b0110011) && (funct7 == 7'b0100000))
                            ALUControlSignal = 4'b0110; // SUB
                        else
                            ALUControlSignal = 4'b0011; // ADD
                    end
                    3'b001: begin
                        if (funct7 == 7'b0000000) ALUControlSignal = 4'b0100; // SLL
                        else ALUControlSignal = 4'b0011;
                    end
                    3'b101: begin
                        if (funct7 == 7'b0000000) ALUControlSignal = 4'b0101; // SRL
                        else ALUControlSignal = 4'b0011; // SRA not implemented
                    end
                    3'b111: begin
                        if (funct7 == 7'b0000000) ALUControlSignal = 4'b0000; // AND
                        else ALUControlSignal = 4'b0011;
                    end
                    3'b110: begin
                        if (funct7 == 7'b0000000) ALUControlSignal = 4'b0001; // OR
                        else ALUControlSignal = 4'b0011;
                    end
                    3'b100: begin
                        if (funct7 == 7'b0000000) ALUControlSignal = 4'b0010; // XOR
                        else ALUControlSignal = 4'b0011;
                    end
                    default: ALUControlSignal = 4'b0011;
                endcase
            end
            default: ALUControlSignal = 4'b0011;
        endcase
    end
endmodule
