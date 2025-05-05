`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"
`include "Branch_Comparator.v"

module Single_Cycle_Top(clk,rst);

    input clk,rst;

    // Khai báo các dây tín hiệu
    wire [31:0] PC_Top, RD_Instr, RD1_Top, RD2_Top, Imm_Ext_Top;
    wire [31:0] ALUResult, ReadData, PCPlus4, SrcB, Result;
    wire [31:0] PCTarget, JALRTarget; // PC cho lệnh nhảy
    
    // Tín hiệu điều khiển theo datapath
    wire RegWEn, BSel, MemRW, PCSel, ASel, Branch;
    wire [1:0] WBSel;
    wire [1:0] ImmSel;
    wire [3:0] ALUSel;
    wire BrEq, BrLT;
    
    // Xác định loại lệnh nhảy (JALR hoặc JAL/Branch)
    wire isJALR = (RD_Instr[6:0] == 7'b1100111);
    
    // PC Next Mux (theo datapath)
    wire [31:0] PC_Next;
    wire [31:0] PC_Target_Final = isJALR ? {JALRTarget[31:1], 1'b0} : PCTarget;
    assign PC_Next = PCSel ? PC_Target_Final : PCPlus4;
    
    // PC Module
    PC_Module PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_Next(PC_Next)
    );

    // PC+4 Adder
    PC_Adder PC_Adder(
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4)
    );
    
    // PC Target Adder (PC + Imm) cho JAL và Branch
    PC_Adder PC_Target_Adder(
        .a(PC_Top),
        .b(Imm_Ext_Top),
        .c(PCTarget)
    );
    
    // JALR Target (rs1 + imm)
    PC_Adder JALR_Target_Adder(
        .a(RD1_Top),
        .b(Imm_Ext_Top),
        .c(JALRTarget)
    );
    
    // Instruction Memory (IMEM)
    Instruction_Memory Instruction_Memory(
        .rst(rst),
        .A(PC_Top),
        .RD(RD_Instr)
    );

    // Register File
    Register_File Register_File(
        .clk(clk),
        .rst(rst),
        .WE3(RegWEn),
        .WD3(Result),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),
        .A3(RD_Instr[11:7]),
        .RD1(RD1_Top),
        .RD2(RD2_Top)
    );

    // Immediate Generator
    Sign_Extend Sign_Extend(
        .In(RD_Instr),
        .ImmSrc(ImmSel),
        .Imm_Ext(Imm_Ext_Top)
    );

    // B Mux (ALU input B)
    Mux Mux_B(
        .a(RD2_Top),
        .b(Imm_Ext_Top),
        .s(BSel),
        .c(SrcB)
    );

    // A Mux (ALU input A)
    wire [31:0] SrcA;
    Mux Mux_A(
        .a(RD1_Top),
        .b(PC_Top),
        .s(ASel),
        .c(SrcA)
    );

    // ALU
    ALU ALU(
        .A(SrcA),
        .B(SrcB),
        .Result(ALUResult),
        .ALUControl(ALUSel),
        .OverFlow(),
        .Carry(),
        .Zero(),
        .Negative()
    );

    // Branch Comparator
    Branch_Comparator Branch_Comp(
        .A(RD1_Top),
        .B(RD2_Top),
        .funct3(RD_Instr[14:12]),
        .BrEq(BrEq),
        .BrLT(BrLT)
    );

    // Control Unit
    Control_Unit_Top Control_Unit_Top(
        .Op(RD_Instr[6:0]),
        .RegWEn(RegWEn),
        .ImmSel(ImmSel),
        .BSel(BSel),
        .MemRW(MemRW),
        .WBSel(WBSel),
        .Branch(Branch),
        .funct3(RD_Instr[14:12]),
        .funct7(RD_Instr[31:25]),
        .ALUSel(ALUSel),
        .BrEq(BrEq),
        .BrLT(BrLT),
        .PCSel(PCSel),
        .ASel(ASel)
    );

    // Data Memory (DMEM)
    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .WE(MemRW),
        .WD(RD2_Top),
        .A(ALUResult),
        .RD(ReadData),
        .funct3(RD_Instr[14:12])
    );

    // WB Mux (4 đầu vào theo datapath)
    Mux4 Mux_Result(
        .a(ALUResult),    // ALU result
        .b(ReadData),     // Memory
        .c(PCPlus4),      // PC+4
        .d(Imm_Ext_Top),  // Immediate (cho LUI)
        .s(WBSel),
        .y(Result)
    );

endmodule
