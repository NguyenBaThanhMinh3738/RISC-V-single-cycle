module tb_stage_id;
    reg clk;
    reg [31:0] instr;
    reg [31:0] regfile [0:31];        // mô phỏng thanh ghi
    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm;
    wire [31:0] reg_data1, reg_data2;

    // Kết nối dữ liệu từ regfile thủ công (bên ngoài stage_ID)
    assign reg_data1 = regfile[rs1];
    assign reg_data2 = regfile[rs2];

    // Thiết bị kiểm tra (DUT)
    stage_ID dut (
        .clk(clk),
        .instr(instr),
        .reg_data1(reg_data1),
        .reg_data2(reg_data2),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm)
    );

    // Clock toggle
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Kiểm tra
    initial begin
        // Khởi tạo regfile
        regfile[1] = 32'h11111111;
        regfile[2] = 32'h22222222;

        // Lệnh addi x1, x1, 2 (opcode 0010011)
        instr = 32'b00000000001000001000000010010011;
        #10;

        // Lệnh sw x4, 8(x2) (opcode 0100011)
        instr = 32'b00000000010000010010000100100011;
        #10;

        $stop;
    end
endmodule
