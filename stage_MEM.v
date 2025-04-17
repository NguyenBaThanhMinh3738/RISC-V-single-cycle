module stage_MEM(
    input clk,
    input memwrite,
    input [31:0] aluout,
    input [31:0] wd,
    output [31:0] rd
);
    dmem dmem_inst (
        .clk(clk),
        .we(memwrite), // Đảm bảo tên khớp với cổng 'we' trong dmem.v
        .a(aluout),
        .wd(wd),
        .rd(rd)
    );
endmodule