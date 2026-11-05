`timescale 1ns / 1ps
module TopLevelProcessor(
    input wire clk,
    input wire rst,
    input wire [15:0] switches,
    output wire [31:0] PC,
    output wire [31:0] instruction,
    output wire [31:0] ALUResult,
    output wire [31:0] WriteBackData,
    output wire [15:0] leds
);
    // Internal datapath wires
    wire [31:0] PC_Next;
    wire [31:0] PC_Plus4;
    wire [31:0] BranchTarget;
    wire [31:0] Imm;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] ALU_B;
    wire [31:0] MemReadData;

    wire RegWrite;
    wire [1:0] ALUOp;
    wire MemRead;
    wire MemWrite;
    wire ALUSrc;
    wire MemtoReg;
    wire Branch;
    wire Zero;
    wire PCSrc;
    wire [3:0] ALUControlSignal;

    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rd = instruction[11:7];
    wire [2:0] funct3 = instruction[14:12];
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [6:0] funct7 = instruction[31:25];

    assign PCSrc = Branch & Zero;

    ProgramCounter PC_reg (
        .clk(clk), .rst(rst), .PC_Next(PC_Next), .PC(PC)
    );

    pcAdder PC_add (
        .PC(PC), .PC_Plus4(PC_Plus4)
    );

    instructionMemory IMEM (
        .instAddress(PC), .instruction(instruction)
    );

    immGen IMM_GEN (
        .instruction(instruction), .Imm(Imm)
    );

    MainControl CONTROL (
        .opcode(opcode),
        .RegWrite(RegWrite), .ALUOp(ALUOp),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .Branch(Branch)
    );

    RegisterFile RF (
        .clk(clk), .rst(rst), .WriteEnable(RegWrite),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteBackData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALUControl ALU_CTRL (
        .opcode(opcode), .ALUOp(ALUOp), .funct3(funct3), .funct7(funct7),
        .ALUControlSignal(ALUControlSignal)
    );

    mux2 ALU_SRC_MUX (
        .in0(ReadData2), .in1(Imm), .sel(ALUSrc), .out(ALU_B)
    );

    ALU_32bit ALU (
        .A(ReadData1), .B(ALU_B), .ALUControl(ALUControlSignal),
        .Result(ALUResult), .Zero(Zero)
    );

    addressDecoderTop DATA_MEMORY_SYSTEM (
        .clk(clk), .rst(rst), .address(ALUResult),
        .readEnable(MemRead), .writeEnable(MemWrite),
        .writeData(ReadData2), .switches(switches),
        .readData(MemReadData), .leds(leds)
    );

    mux2 WRITE_BACK_MUX (
        .in0(ALUResult), .in1(MemReadData), .sel(MemtoReg),
        .out(WriteBackData)
    );

    branchAdder BRANCH_ADD (
        .PC(PC), .Imm(Imm), .BranchTarget(BranchTarget)
    );

    mux2 PC_MUX (
        .in0(PC_Plus4), .in1(BranchTarget), .sel(PCSrc), .out(PC_Next)
    );
endmodule
