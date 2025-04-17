module tb_stage_ex;
    reg [31:0] reg_data1, reg_data2, imm;
    reg alusrc;
    reg [3:0] aluop;
    wire [31:0] aluout;

    stage_EX dut (
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .imm(imm),
        .alusrc(alusrc),
        .aluop(aluop),
        .aluout(aluout)
    );

    initial begin
        reg_data1 = 32'd10;
        reg_data2 = 32'd5;
        imm = 32'd3;

        alusrc = 0; aluop = 4'b0000; #10;
        alusrc = 1; aluop = 4'b0001; #10;
        $stop;
    end
endmodule