module riscv_single (
    input clk, reset,
    output [31:0] pc, instr
);

    // =========================
    // WIRE DÙNG CHUNG TOÀN MODULE
    // =========================
    wire [31:0] pc_next;

    // Stage ID
    wire [31:0] regfile [0:31];
    wire [4:0] rs1, rs2, rd;
    wire [31:0] reg_data1, reg_data2, imm;

    // Stage EX
    wire [31:0] aluout;
    wire alusrc;
    wire [3:0] aluop;

    // Stage MEM
    wire [31:0] memdata;
    wire [31:0] wd;
    wire memwrite;

    // Stage WB
    wire memtoreg;
    wire [31:0] result;

    // =========================
    // GIAI ĐOẠN IF
    // =========================
    stage_IF stage_if (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .pc_next(pc_next)
    );

    // Tăng PC để lấy lệnh tiếp theo
    assign pc_next = pc + 4;

    // =========================
    // GIAI ĐOẠN ID
    // =========================
    stage_ID stage_id (
        .clk(clk),
        .instr(instr),
        .regfile(regfile),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .imm(imm),
        .wd(result)  // Dữ liệu ghi ngược từ WB
    );

    // =========================
    // GIAI ĐOẠN EX
    // =========================
    stage_EX stage_ex (
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .imm(imm),
        .alusrc(alusrc),
        .aluop(aluop),
        .aluout(aluout)
    );

    // =========================
    // GIAI ĐOẠN MEM
    // =========================
    assign wd = reg_data2;

    stage_MEM stage_mem (
        .clk(clk),
        .memwrite(memwrite),
        .aluout(aluout),
        .wd(wd),
        .rd(memdata)
    );

    // =========================
    // GIAI ĐOẠN WB
    // =========================
    stage_WB stage_wb (
        .memtoreg(memtoreg),
        .aluout(aluout),
        .memdata(memdata),
        .result(result)
    );

endmodule
