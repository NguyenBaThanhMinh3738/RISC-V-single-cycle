module Main_Decoder(Op, RegWEn, ImmSel, BSel, MemRW, WBSel, Branch, Jump, ALUOp, ASel);
    input [6:0]Op;
    output reg RegWEn, BSel, MemRW, Branch, Jump, ASel;
    output reg [1:0]WBSel, ImmSel, ALUOp;

    always @(*) begin
        // Giá trị mặc định
        RegWEn = 1'b0;
        ImmSel = 2'b00;
        BSel = 1'b0;
        MemRW = 1'b0;
        WBSel = 2'b00;
        Branch = 1'b0;
        Jump = 1'b0;
        ALUOp = 2'b00;
        ASel = 1'b0;
        
        case(Op)
            7'b0110011: begin // R-type
                RegWEn = 1'b1;
                BSel = 1'b0;    // Chọn Register
                WBSel = 2'b00;  // Chọn ALU
                ALUOp = 2'b10;  // R-type ALU
            end
            
            7'b0010011: begin // I-type ALU
                RegWEn = 1'b1;
                ImmSel = 2'b00; // I-type
                BSel = 1'b1;    // Chọn Immediate
                WBSel = 2'b00;  // Chọn ALU
                ALUOp = 2'b10;  // I-type ALU
            end
            
            7'b0000011: begin // Load (LB, LH, LW, LBU, LHU)
                RegWEn = 1'b1;
                ImmSel = 2'b00; // I-type
                BSel = 1'b1;    // Chọn Immediate
                WBSel = 2'b01;  // Chọn Memory
                ALUOp = 2'b00;  // ADD
            end
            
            7'b0100011: begin // Store (SB, SH, SW)
                RegWEn = 1'b0;
                ImmSel = 2'b01; // S-type
                BSel = 1'b1;    // Chọn Immediate
                MemRW = 1'b1;   // Ghi vào memory
                ALUOp = 2'b00;  // ADD
            end
            
            7'b1100011: begin // Branch (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                RegWEn = 1'b0;
                ImmSel = 2'b10; // B-type
                Branch = 1'b1;
                ALUOp = 2'b01;  // SUB (cho so sánh)
            end
            
            7'b1101111: begin // JAL
                RegWEn = 1'b1;
                ImmSel = 2'b11; // J-type
                WBSel = 2'b10;  // Chọn PC+4
                Jump = 1'b1;
            end
            
            7'b1100111: begin // JALR
                RegWEn = 1'b1;
                ImmSel = 2'b00; // I-type
                BSel = 1'b1;    // Chọn Immediate
                WBSel = 2'b10;  // Chọn PC+4
                Jump = 1'b1;
                ALUOp = 2'b00;  // ADD
            end
            
            7'b0110111: begin // LUI
                RegWEn = 1'b1;
                ImmSel = 2'b11; // U-type
                WBSel = 2'b11;  // Chọn Immediate trực tiếp
            end
            
            7'b0010111: begin // AUIPC
                RegWEn = 1'b1;
                ImmSel = 2'b11; // U-type
                BSel = 1'b1;    // Chọn Immediate
                WBSel = 2'b00;  // Chọn ALU
                ALUOp = 2'b00;  // ADD
                ASel = 1'b1;    // Chọn PC
            end
        endcase
    end
endmodule
