`timescale 1ns / 1ps
module DataMemory(
    input wire clk,
    input wire MemWrite,
    input wire [8:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] memory [0:511];
    integer i;

    // Initialize memory for deterministic simulation. The write port is synchronous.
    initial begin
        for (i = 0; i < 512; i = i + 1)
            memory[i] = 32'b0;
    end

    assign read_data = memory[address];

    always @(posedge clk) begin
        if (MemWrite)
            memory[address] <= write_data;
    end
endmodule
