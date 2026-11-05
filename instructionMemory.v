`timescale 1ns / 1ps
module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input wire [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);
    // Lab 10 reference structure: 256 bytes of instruction memory.
    reg [7:0] memory [0:255];
    integer i;

    initial begin
        // Fill unused locations with RV32I NOP (addi x0,x0,0).
        for (i = 0; i < 256; i = i + 4) begin
            memory[i]   = 8'h13;
            memory[i+1] = 8'h00;
            memory[i+2] = 8'h00;
            memory[i+3] = 8'h00;
        end
        // program.mem stores bytes in little-endian order, matching RISC-V memory layout.
        $readmemh("program.mem", memory);
    end

    always @(*) begin
        // Corrected byte order matching the memory file format
        instruction = {memory[instAddress[7:0]],
                       memory[instAddress[7:0] + 8'd1],
                       memory[instAddress[7:0] + 8'd2],
                       memory[instAddress[7:0] + 8'd3]};
    end
endmodule
