`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module Control_Unit_Top(
    Op, 
    RegWEn,
    ImmSel,
    BSel,
    MemRW,
    WBSel,
    Branch, 
    funct3, 
    funct7, 
    ALUSel,
    BrEq,
    BrLT,
    PCSel,
    ASel
);

    input [6:0]Op, funct7;
    input [2:0]funct3;
    input BrEq, BrLT;
    output RegWEn, BSel, MemRW, Branch, PCSel, ASel;
    output [1:0]WBSel;
    output [1:0]ImmSel;
    output [3:0]ALUSel;

    wire [1:0]ALUOp;
    wire Jump;
    
    // PCSel = 1 khi là lệnh nhảy (JAL, JALR) hoặc lệnh branch thỏa điều kiện
    // Theo datapath, PCSel quyết định PC_Next = PCTarget hay PC+4
    assign PCSel = Jump | (Branch & BranchTaken);
    
    // BranchTaken dựa vào BrEq, BrLT và funct3
    reg BranchTaken;
    always @(*) begin
        case(funct3)
            3'b000: BranchTaken = BrEq;     // BEQ
            3'b001: BranchTaken = ~BrEq;    // BNE
            3'b100: BranchTaken = BrLT;     // BLT
            3'b101: BranchTaken = ~BrLT;    // BGE
            3'b110: BranchTaken = BrLT;     // BLTU
            3'b111: BranchTaken = ~BrLT;    // BGEU
            default: BranchTaken = 1'b0;
        endcase
    end

    Main_Decoder Main_Decoder(
        .Op(Op),
        .RegWEn(RegWEn),
        .ImmSel(ImmSel),
        .MemRW(MemRW),
        .WBSel(WBSel),
        .Branch(Branch),
        .Jump(Jump),
        .BSel(BSel),
        .ALUOp(ALUOp),
        .ASel(ASel)
    );

    ALU_Decoder ALU_Decoder(
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(Op),
        .ALUSel(ALUSel)
    );

endmodule
