module aludec (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] alucontrol
);
    always @(*) begin
        case (opcode)
            7'b0110011: // R-type
                case (funct3)
                    3'b000: alucontrol = (funct7 == 7'b0000000) ? 4'b0000 : 4'b0001; // ADD, SUB
                    3'b111: alucontrol = 4'b0010; // AND
                    3'b110: alucontrol = 4'b0011; // OR
                    3'b100: alucontrol = 4'b0100; // XOR
                    3'b001: alucontrol = 4'b0101; // SLL
                    3'b101: alucontrol = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0110; // SRL
                    3'b010: alucontrol = 4'b0111; // SLT
                    default: alucontrol = 4'b0000;
                endcase
            7'b0010011: // I-type (addi, etc.)
                case (funct3)
                    3'b000: alucontrol = 4'b0000; // ADDI
                    3'b111: alucontrol = 4'b0010; // ANDI
                    3'b110: alucontrol = 4'b0011; // ORI
                    3'b100: alucontrol = 4'b0100; // XORI
                    3'b001: alucontrol = 4'b0101; // SLLI
                    3'b101: alucontrol = 4'b0110; // SRLI
                    3'b010: alucontrol = 4'b0111; // SLTI
                    default: alucontrol = 4'b0000;
                endcase
            7'b0000011: alucontrol = 4'b0000; // lw
            7'b0100011: alucontrol = 4'b0000; // sw
            7'b1100011: alucontrol = 4'b0001; // beq (SUB for comparison)
            default: alucontrol = 4'b0000;
        endcase
    end
endmodule