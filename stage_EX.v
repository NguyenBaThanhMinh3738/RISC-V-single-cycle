module stage_EX(
    input clk,
    input [31:0] reg_data1, reg_data2, imm,
    input alusrc,
    input [3:0] aluop,
    output reg [31:0] aluout,
    output reg zero
);
    wire [31:0] b_input;
    wire [31:0] alu_result;
    wire alu_zero;

    assign b_input = alusrc ? imm : reg_data2;

    alu alu_inst (
        .a(reg_data1),
        .b(b_input),
        .alucontrol(aluop),
        .result(alu_result),
        .zero(alu_zero)
    );

    always @(posedge clk) begin
        aluout <= alu_result;
        zero <= alu_zero;
    end
endmodule