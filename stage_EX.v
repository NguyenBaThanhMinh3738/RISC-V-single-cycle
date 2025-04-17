module stage_EX(
    input [31:0] reg_data1, reg_data2, imm,
    input alusrc,
    input [3:0] aluop,
    output reg [31:0] aluout
);

    wire [31:0] b_input;

    assign b_input = alusrc ? imm : reg_data2;

    always @(*) begin
        case (aluop)
            4'b0000: aluout = reg_data1 + b_input;
            4'b0001: aluout = reg_data1 - b_input;
            4'b0010: aluout = reg_data1 & b_input;
            4'b0011: aluout = reg_data1 | b_input;
            default: aluout = 32'b0;
        endcase
    end

endmodule
