module stage_ID(
    input clk,
    input [31:0] instr,
    input [31:0] reg_data1, reg_data2,
    output [4:0] rs1, rs2, rd,
    output reg [31:0] imm
);
    // Tách trường lệnh
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm_comb;

    assign opcode = instr[6:0];
    assign rd     = instr[11:7];
    assign funct3 = instr[14:12];
    assign rs1    = instr[19:15];
    assign rs2    = instr[24:20];
    assign funct7 = instr[31:25];

    // Sinh immediate (tổ hợp)
    assign imm_comb = (opcode == 7'b0010011 || opcode == 7'b0000011) ? 
                      {{20{instr[31]}}, instr[31:20]} :  // I-type
                      (opcode == 7'b0100011) ? 
                      {{20{instr[31]}}, instr[31:25], instr[11:7]} :  // S-type
                      (opcode == 7'b1100011) ? 
                      {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0} : // B-type (beq)
                      (opcode == 7'b0110111) ? 
                      {instr[31:12], 12'b0} : // U-type (lui)
                      (opcode == 7'b1101111) ? 
                      {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0} : // J-type (jal)
                      32'b0;

    // Đồng bộ imm
    always @(posedge clk) begin
        imm <= imm_comb;
    end
endmodule