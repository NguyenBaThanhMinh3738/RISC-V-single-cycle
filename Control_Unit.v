module Control_Unit(
    input [31:0] Instr,
    output reg PCSrc,
    output reg [1:0] ResultSrc,
    output reg MemWrite,
    output reg ALUSrc,
    output reg [1:0] ImmSrc,
    output reg RegWrite,
    output reg [3:0] ALUControl,
    output [6:0] op,
    output [2:0] func3,
    output [6:0] func7
);

    // Trích xuất các trường từ lệnh
    assign op = Instr[6:0];
    assign func3 = Instr[14:12];
    assign func7 = Instr[31:25];

    // Giải mã lệnh và tạo tín hiệu điều khiển
    always @(*) begin
        // Giá trị mặc định
        PCSrc = 0;
        ResultSrc = 2'b00;
        MemWrite = 0;
        ALUSrc = 0;
        ImmSrc = 2'b00;
        RegWrite = 0;
        ALUControl = 4'b0000;

        case(op)
            7'b0110011: begin // R-type
                RegWrite = 1;
                ALUSrc = 0;
                case(func3)
                    3'b000: ALUControl = (func7[5]) ? 4'b0001 : 4'b0000; // add/sub
                    3'b111: ALUControl = 4'b0010; // and
                    3'b110: ALUControl = 4'b0011; // or
                    default: ALUControl = 4'b0000;
                endcase
            end

            7'b0010011: begin // I-type
                RegWrite = 1;
                ALUSrc = 1;
                ImmSrc = 2'b00;
                ALUControl = 4'b0000; // addi
            end

            7'b0000011: begin // lw
                RegWrite = 1;
                ALUSrc = 1;
                ImmSrc = 2'b00;
                ResultSrc = 2'b01;
            end

            7'b0100011: begin // sw
                MemWrite = 1;
                ALUSrc = 1;
                ImmSrc = 2'b01;
            end

            7'b1100011: begin // beq
                PCSrc = 1;
                ALUSrc = 0;
                ImmSrc = 2'b10;
            end

            default: begin
                PCSrc = 0;
                ResultSrc = 2'b00;
                MemWrite = 0;
                ALUSrc = 0;
                ImmSrc = 2'b00;
                RegWrite = 0;
                ALUControl = 4'b0000;
            end
        endcase
    end

endmodule