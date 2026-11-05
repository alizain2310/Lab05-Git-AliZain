`timescale 1ns / 1ps
module AddressDecoder(
    input wire [9:0] address,
    input wire MemRead,
    input wire MemWrite,
    output reg DataMemRead,
    output reg DataMemWrite,
    output reg LEDWrite,
    output reg SwitchReadEnable
);
    always @(*) begin
        DataMemRead = 1'b0;
        DataMemWrite = 1'b0;
        LEDWrite = 1'b0;
        SwitchReadEnable = 1'b0;

        // Lab 8 memory map: 0-511 data memory, 512-767 LEDs,
        // 768-1023 switches. address[9:8] selects the device.
        case (address[9:8])
            2'b00, 2'b01: begin
                DataMemRead = MemRead;
                DataMemWrite = MemWrite;
            end
            2'b10: LEDWrite = MemWrite;
            2'b11: SwitchReadEnable = MemRead;
            default: begin end
        endcase
    end
endmodule
