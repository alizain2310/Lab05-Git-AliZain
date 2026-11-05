`timescale 1ns / 1ps
module RegisterFile(
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);
    reg [31:0] regs [0:31];
    integer i;

    // Two asynchronous read ports. x0 is hardwired to zero.
    always @(*) begin
        ReadData1 = (rs1 == 5'd0) ? 32'b0 : regs[rs1];
        ReadData2 = (rs2 == 5'd0) ? 32'b0 : regs[rs2];
    end

    // One synchronous write port. Reset clears every register.
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (WriteEnable && (rd != 5'd0)) begin
            regs[rd] <= WriteData;
        end
    end
endmodule
