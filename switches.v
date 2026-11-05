`timescale 1ns / 1ps
// Lab 8 interface module: stores the value sent to the LED peripheral.
module switches(
    input wire clk,
    input wire rst,
    input wire [31:0] writeData,
    input wire writeEnable,
    input wire readEnable,
    input wire [29:0] memAddress,
    output wire [31:0] readData,
    output reg [15:0] leds
);
    assign readData = 32'b0;

    always @(posedge clk) begin
        if (rst)
            leds <= 16'b0;
        else if (writeEnable)
            leds <= writeData[15:0];
    end
endmodule
