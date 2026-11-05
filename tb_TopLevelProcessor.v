`timescale 1ns / 1ps
module tb_TopLevelProcessor;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg [15:0] switches = 16'hA55A;

    wire [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] ALUResult;
    wire [31:0] WriteBackData;
    wire [15:0] leds;

    TopLevelProcessor dut (
        .clk(clk), .rst(rst), .switches(switches),
        .PC(PC), .instruction(instruction),
        .ALUResult(ALUResult), .WriteBackData(WriteBackData), .leds(leds)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Starting single-cycle processor test...");
        repeat (2) @(posedge clk);
        #1 rst = 1'b0;

        // Execute the 12-word demonstration program in program.mem.
        repeat (12) @(posedge clk);
        #1;

        if (dut.RF.regs[1] !== 32'd5)  $display("FAIL: x1 expected 5, got %h", dut.RF.regs[1]);
        else                           $display("PASS: x1 = 5");

        if (dut.RF.regs[2] !== 32'd7)  $display("FAIL: x2 expected 7, got %h", dut.RF.regs[2]);
        else                           $display("PASS: x2 = 7");

        if (dut.RF.regs[3] !== 32'd12) $display("FAIL: x3 expected 12, got %h", dut.RF.regs[3]);
        else                           $display("PASS: x3 = 12 (ADD)");

        if (dut.RF.regs[4] !== 32'd12) $display("FAIL: x4 expected 12, got %h", dut.RF.regs[4]);
        else                           $display("PASS: x4 = 12 (LW)");

        if (dut.RF.regs[5] !== 32'd9)  $display("FAIL: x5 expected 9, got %h", dut.RF.regs[5]);
        else                           $display("PASS: x5 = 9 (BEQ skipped the 1 assignment)");

        if (leds !== 16'd12)          $display("FAIL: LEDs expected 12, got %h", leds);
        else                           $display("PASS: LED memory-mapped write = 12");

        if (dut.RF.regs[7] !== 32'h0000A55A)
            $display("FAIL: x7 expected 0000A55A, got %h", dut.RF.regs[7]);
        else                           $display("PASS: x7 read switch input A55A");

        if (dut.RF.regs[8] !== 32'hFFFFFFFF)
            $display("FAIL: x8 expected FFFFFFFF, got %h", dut.RF.regs[8]);
        else                           $display("PASS: I-type immediate sign extension");

        if (dut.RF.regs[0] !== 32'b0)  $display("FAIL: x0 is not zero");
        else                           $display("PASS: x0 remains zero");

        $display("Final PC=%h instruction=%h ALUResult=%h WriteBackData=%h LEDs=%h",
                 PC, instruction, ALUResult, WriteBackData, leds);
        $finish;
    end
endmodule
