`timescale 1ns / 1ps
module tb_PC_Update;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg PCSrc = 1'b0;
    reg [31:0] instruction = 32'b0;

    wire [31:0] PC;
    wire [31:0] PC_Plus4;
    wire [31:0] Imm;
    wire [31:0] BranchTarget;
    wire [31:0] PC_Next;

    ProgramCounter PC_reg(.clk(clk), .rst(rst), .PC_Next(PC_Next), .PC(PC));
    pcAdder PC_add(.PC(PC), .PC_Plus4(PC_Plus4));
    immGen IMM_GEN(.instruction(instruction), .Imm(Imm));
    branchAdder BR_ADD(.PC(PC), .Imm(Imm), .BranchTarget(BranchTarget));
    mux2 PC_MUX(.in0(PC_Plus4), .in1(BranchTarget), .sel(PCSrc), .out(PC_Next));

    always #5 clk = ~clk;

    initial begin
        // Reset and sequential PC increments.
        repeat (2) @(posedge clk);
        #1 rst = 1'b0;
        repeat (3) @(posedge clk);
        #1;
        if (PC !== 32'd12) $display("FAIL: sequential PC expected 12, got %h", PC);
        else $display("PASS: PC increments by 4");

        // Positive B-type displacement of +16.
        @(negedge clk);
        instruction = 32'b0000000_00000_00000_000_10000_1100011;
        PCSrc = 1'b1;
        @(posedge clk);
        #1;
        if (Imm !== 32'd16 || PC !== 32'd28)
            $display("FAIL: positive branch immediate/target Imm=%h PC=%h", Imm, PC);
        else $display("PASS: positive B-type branch target");

        // Negative B-type displacement of -4.
        @(negedge clk);
        instruction = 32'hFE000EE3;
        PCSrc = 1'b1;
        @(posedge clk);
        #1;
        if (Imm !== 32'hFFFFFFFC || PC !== 32'd24)
            $display("FAIL: negative branch immediate/target Imm=%h PC=%h", Imm, PC);
        else $display("PASS: negative B-type sign extension");

        PCSrc = 1'b0;
        instruction = 32'h00500093; // addi x1,x0,5
        #1;
        if (Imm !== 32'd5) $display("FAIL: I-type positive immediate %h", Imm);
        else $display("PASS: I-type positive immediate");

        instruction = 32'hFFF00093; // addi x1,x0,-1
        #1;
        if (Imm !== 32'hFFFFFFFF) $display("FAIL: I-type negative immediate %h", Imm);
        else $display("PASS: I-type negative sign extension");

        instruction = 32'h00802223; // sw x8,4(x0)
        #1;
        if (Imm !== 32'd4) $display("FAIL: S-type positive immediate %h", Imm);
        else $display("PASS: S-type positive immediate");

        instruction = 32'hFE302C23; // sw x3,-8(x0)
        #1;
        if (Imm !== 32'hFFFFFFF8) $display("FAIL: S-type negative immediate %h", Imm);
        else $display("PASS: S-type negative sign extension");

        $finish;
    end
endmodule
