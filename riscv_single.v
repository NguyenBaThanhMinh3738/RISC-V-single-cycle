module riscv_single (
    input clk, reset,
    output [31:0] pc, instr,
    output [31:0] aluout, writedata, readdata,
    output memwrite
);
    // WIRE DÙNG CHUNG TOÀN MODULE
    wire [31:0] pc_next_comb, pc_plus4, pc_branch;
    reg [31:0] pc_next;
    wire branch, jump, zero;

    // Stage ID
    wire [31:0] regfile [0:31];
    wire [4:0] rs1, rs2, rd;
    wire [31:0] reg_data1, reg_data2, imm;

    // Stage EX
    wire alusrc;
    wire [3:0] aluop;

    // Stage MEM
    wire [31:0] memdata;
    wire [31:0] wd;

    // Stage WB
    wire memtoreg;
    wire [31:0] result;
    wire [31:0] pc_plus4_wb; // For jal

    // Control signals
    wire regwrite;

    // GIAI ĐOẠN IF
    stage_IF stage_if (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .pc_next(pc_next)
    );

    // Tính toán PC tiếp theo
    assign pc_plus4 = pc + 4;
    assign pc_branch = pc + imm;
    assign pc_next_comb = (branch && zero) ? pc_branch : (jump ? pc_branch : pc_plus4);

    // Đồng bộ pc_next
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_next <= 32'd0;
        else
            pc_next <= pc_next_comb;
    end

    // GIAI ĐOẠN ID
    maindec maindec_inst (
        .clk(clk),
        .opcode(instr[6:0]),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .branch(branch),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .jump(jump),
        .aluop(aluop)
    );

    stage_ID stage_id (
        .clk(clk),
        .instr(instr),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm)
    );

    regfile regfile_inst (
        .clk(clk),
        .we3(regwrite),
        .ra1(rs1),
        .ra2(rs2),
        .wa3(rd),
        .wd3(result),
        .rd1(reg_data1),
        .rd2(reg_data2)
    );

    // GIAI ĐOẠN EX
    stage_EX stage_ex (
        .clk(clk),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .imm(imm),
        .alusrc(alusrc),
        .aluop(aluop),
        .aluout(aluout),
        .zero(zero)
    );

    // GIAI ĐOẠN MEM
    assign wd = reg_data2;
    assign writedata = wd;
    assign readdata = memdata;
    stage_MEM stage_mem (
        .clk(clk),
        .memwrite(memwrite),
        .aluout(aluout),
        .wd(wd),
        .rd(memdata)
    );

    // GIAI ĐOẠN WB
    assign pc_plus4_wb = pc_plus4; // Pass pc+4 for jal
    stage_WB stage_wb (
        .clk(clk),
        .memtoreg(memtoreg),
        .aluout(aluout),
        .memdata(memdata),
        .pc_plus4(pc_plus4_wb),
        .jump(jump),
        .result(result)
    );
endmodule