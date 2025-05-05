module ALU_Decoder(ALUOp, funct3, funct7, op, ALUSel);
    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7, op;
    output reg [3:0]ALUSel;

    always @(*) begin
        case(ALUOp)
            2'b00: ALUSel = 4'b0000; // ADD for loads/stores/jumps/AUIPC
            2'b01: ALUSel = 4'b0001; // SUB for branches
            2'b10: begin // R-type or I-type ALU
                case(funct3)
                    3'b000: begin
                        // ADD/SUB for R-type, ADD for I-type
                        if (op[5] && funct7[5]) 
                            ALUSel = 4'b0001; // SUB
                        else
                            ALUSel = 4'b0000; // ADD
                    end
                    3'b001: ALUSel = 4'b0101; // SLL
                    3'b010: ALUSel = 4'b0010; // SLT
                    3'b011: ALUSel = 4'b0011; // SLTU
                    3'b100: ALUSel = 4'b0100; // XOR
                    3'b101: begin
                        if (funct7[5])
                            ALUSel = 4'b0111; // SRA
                        else
                            ALUSel = 4'b0110; // SRL
                    end
                    3'b110: ALUSel = 4'b1000; // OR
                    3'b111: ALUSel = 4'b1001; // AND
                    default: ALUSel = 4'b0000;
                endcase
            end
            2'b11: ALUSel = 4'b0000; // Đặc biệt cho LUI (không quan trọng vì kết quả bị ghi đè)
            default: ALUSel = 4'b0000;
        endcase
    end
endmodule
