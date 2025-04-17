module stage_ID(
    input clk,
    input [31:0] instr,
    input [31:0] reg_data1, reg_data2,
    output [4:0] rs1, rs2, rd,
    output [31:0] imm
);

    // Tách trường lệnh
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // Sinh immediate cho I-type, S-type (có thể mở rộng nếu cần)
    assign imm = (opcode == 7'b0010011 || opcode == 7'b0000011) ? 
                    {{20{instr[31]}}, instr[31:20]} :  // I-type
                 (opcode == 7'b0100011) ? 
                    {{20{instr[31]}}, instr[31:25], instr[11:7]} :  // S-type
                 32'b0;

endmodule
