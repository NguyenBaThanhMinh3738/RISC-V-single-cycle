module stage_MEM(
    input clk,
    input memwrite,
    input [31:0] aluout,
    input [31:0] wd,         // dữ liệu cần ghi
    output [31:0] rd         // dữ liệu đọc ra
);

    dmem dmem_inst (
        .clk(clk),
        .memwrite(memwrite),
        .a(aluout),
        .wd(wd),
        .rd(rd)
    );

endmodule
