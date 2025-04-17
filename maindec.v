module maindec (
    input [6:0] opcode,
    output reg memtoreg, memwrite, branch, alusrc, regwrite,
    output reg [1:0] aluop
);
    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-type
                regwrite = 1; memtoreg = 0; memwrite = 0; branch = 0; alusrc = 0; aluop = 2'b10;
            end
            7'b0010011: begin // I-type (addi)
                regwrite = 1; memtoreg = 0; memwrite = 0; branch = 0; alusrc = 1; aluop = 2'b10;
            end
            7'b0000011: begin // lw
                regwrite = 1; memtoreg = 1; memwrite = 0; branch = 0; alusrc = 1; aluop = 2'b00;
            end
            7'b0100011: begin // sw
                regwrite = 0; memtoreg = 0; memwrite = 1; branch = 0; alusrc = 1; aluop = 2'b00;
            end
            7'b1100011: begin // beq
                regwrite = 0; memtoreg = 0; memwrite = 0; branch = 1; alusrc = 0; aluop = 2'b01;
            end
            7'b0110111: begin // lui
                regwrite = 1; memtoreg = 0; memwrite = 0; branch = 0; alusrc = 1; aluop = 2'b00;
            end
            7'b1101111: begin // jal
                regwrite = 1; memtoreg = 0; memwrite = 0; branch = 0; alusrc = 0; aluop = 2'b00;
            end
            default: begin
                regwrite = 0; memtoreg = 0; memwrite = 0; branch = 0; alusrc = 0; aluop = 2'b00;
            end
        endcase
    end
endmodule