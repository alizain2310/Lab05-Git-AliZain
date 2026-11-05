`timescale 1ns / 1ps
module addressDecoderTop(
    input wire clk,
    input wire rst,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] writeData,
    input wire [15:0] switches,
    output wire [31:0] readData,
    output wire [15:0] leds
);
    wire DataMemRead;
    wire DataMemWrite;
    wire LEDWrite;
    wire SwitchReadEnable;
    wire [31:0] memoryReadData;
    wire [31:0] switchReadData;
    wire [31:0] unusedLEDReadData;
    wire [15:0] ledOutput;

    AddressDecoder decoder (
        .address(address[9:0]),
        .MemRead(readEnable),
        .MemWrite(writeEnable),
        .DataMemRead(DataMemRead),
        .DataMemWrite(DataMemWrite),
        .LEDWrite(LEDWrite),
        .SwitchReadEnable(SwitchReadEnable)
    );

    DataMemory data_memory (
        .clk(clk),
        .MemWrite(DataMemWrite),
        .address(address[8:0]),
        .write_data(writeData),
        .read_data(memoryReadData)
    );

    // Reuse the peripheral interfaces documented in the previous Lab 8 worksheet.
    leds switch_interface (
        .clk(clk), .rst(rst), .btns(16'b0),
        .writeData(writeData), .writeEnable(1'b0),
        .readEnable(SwitchReadEnable), .memAddress(address[29:0]),
        .switches(switches), .readData(switchReadData)
    );

    switches led_interface (
        .clk(clk), .rst(rst), .writeData(writeData),
        .writeEnable(LEDWrite), .readEnable(1'b0),
        .memAddress(address[29:0]), .readData(unusedLEDReadData),
        .leds(ledOutput)
    );

    assign leds = ledOutput;
    assign readData = DataMemRead ? memoryReadData :
                      SwitchReadEnable ? switchReadData : 32'b0;
endmodule
