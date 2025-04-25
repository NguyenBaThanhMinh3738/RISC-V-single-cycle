module Instruction_Decode_Stage_tb();
    // Các tín hiệu đầu vào
    reg clk;                   // Tín hiệu xung nhịp
    reg rst;                   // Tín hiệu reset
    reg [31:0] Instr;         // Lệnh từ giai đoạn IF
    reg [31:0] WD3;           // Dữ liệu ghi vào thanh ghi
    reg WE3;                  // Tín hiệu cho phép ghi thanh ghi
    
    // Các tín hiệu đầu ra
    wire [31:0] RD1, RD2;     // Dữ liệu đọc từ thanh ghi
    wire [31:0] ImmExt;       // Giá trị immediate đã được mở rộng
    
    // Các tín hiệu điều khiển
    wire PCSrc;               // Điều khiển chọn PC tiếp theo
    wire [1:0] ResultSrc;     // Chọn nguồn kết quả
    wire MemWrite;            // Cho phép ghi bộ nhớ
    wire ALUSrc;              // Chọn nguồn cho ALU
    wire [1:0] ImmSrc;        // Chọn loại immediate
    wire RegWrite;            // Cho phép ghi thanh ghi
    wire [3:0] ALUControl;    // Điều khiển phép toán ALU
    wire [6:0] op;            // Opcode
    wire [2:0] func3;         // Func3
    wire [6:0] func7;         // Func7

    // Địa chỉ thanh ghi
    wire [4:0] A1, A2, A3;    // Địa chỉ các thanh ghi từ lệnh
    
    // Trích xuất địa chỉ thanh ghi từ lệnh
    assign A1 = Instr[19:15]; // rs1
    assign A2 = Instr[24:20]; // rs2
    assign A3 = Instr[11:7];  // rd

    // Khởi tạo các module
    Register_File reg_file(
        .clk(clk),
        .rst(rst),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .WE3(WE3),
        .RD1(RD1),
        .RD2(RD2)
    );

    Control_Unit control_unit(
        .Instr(Instr),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .op(op),
        .func3(func3),
        .func7(func7)
    );

    Immediate_Extend imm_extend(
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    // Tạo xung nhịp
    always begin
        #5 clk = ~clk;
    end

    // Kịch bản kiểm tra
    initial begin
        // Khởi tạo file lưu kết quả mô phỏng
        $dumpfile("Instruction_Decode_Stage_tb.vcd");
        $dumpvars(0, Instruction_Decode_Stage_tb);

        // Khởi tạo các giá trị ban đầu
        clk = 0;
        rst = 0;
        Instr = 32'h0;
        WD3 = 32'h0;
        WE3 = 0;

        // Tắt reset
        #10 rst = 1;

        // Test Case 1: Kiểm tra lệnh dạng R (add x3, x1, x2)
        // Mục đích: Kiểm tra việc giải mã lệnh dạng R-type
        // Kết quả mong đợi: op=0110011, func3=000, func7=0000000
        #10;
        Instr = 32'h002080b3;  // add x1, x2, x0
        WE3 = 1;
        WD3 = 32'h12345678;    
        #10;
        if (op !== 7'b0110011 || func3 !== 3'b000 || func7 !== 7'b0000000)
            $display("Test 1 Thất bại: Lỗi giải mã lệnh R-type");
        else
            $display("Test 1 Thành công: Giải mã lệnh R-type đúng");

        // Test Case 2: Kiểm tra lệnh dạng I (addi x2, x1, 20)
        // Mục đích: Kiểm tra việc mở rộng giá trị immediate cho lệnh I-type
        // Kết quả mong đợi: ImmExt=20 (0x14), ALUSrc=1
        #10;
        Instr = 32'h01400113;  // addi x2, x0, 20
        #10;
        if (ImmExt !== 32'h00000014 || ALUSrc !== 1'b1)
            $display("Test 2 Thất bại: Lỗi mở rộng immediate cho lệnh I-type");
        else
            $display("Test 2 Thành công: Mở rộng immediate cho lệnh I-type đúng");

        // Test Case 3: Kiểm tra lệnh dạng S (sw x2, 12(x1))
        // Mục đích: Kiểm tra tín hiệu điều khiển cho lệnh store
        // Kết quả mong đợi: MemWrite=1, ImmSrc=01
        #10;
        Instr = 32'h00211623;  // sw x2, 12(x2)
        #10;
        if (MemWrite !== 1'b1 || ImmSrc !== 2'b01)
            $display("Test 3 Thất bại: Lỗi tín hiệu điều khiển cho lệnh S-type");
        else
            $display("Test 3 Thành công: Tín hiệu điều khiển cho lệnh S-type đúng");

        // Test Case 4: Kiểm tra đọc/ghi Register File
        // Mục đích: Kiểm tra hoạt động đọc/ghi của khối Register File
        // Kết quả mong đợi: Đọc được giá trị đã ghi (0xAABBCCDD)
        #10;
        // Ghi giá trị vào x5 bằng cách sử dụng lệnh addi
        Instr = 32'h00028293;  // addi x5, x5, 0
        WE3 = 1;
        WD3 = 32'hAABBCCDD;
        #10;
        // Đọc giá trị từ x5
        Instr = 32'h00028293;  // sử dụng x5 làm rs1
        #10;
        if (RD1 !== 32'hAABBCCDD)
            $display("Test 4 Thất bại: Lỗi đọc/ghi Register File");
        else
            $display("Test 4 Thành công: Đọc/ghi Register File đúng");

        // Test Case 5: Kiểm tra lệnh rẽ nhánh (beq x1, x2, offset)
        // Mục đích: Kiểm tra tín hiệu điều khiển cho lệnh branch
        // Kết quả mong đợi: ImmSrc=10
        #10;
        Instr = 32'h00208063;  // beq x1, x2, 0
        #10;
        if (ImmSrc !== 2'b10)
            $display("Test 5 Thất bại: Lỗi tín hiệu điều khiển cho lệnh branch");
        else
            $display("Test 5 Thành công: Tín hiệu điều khiển cho lệnh branch đúng");

        // Kết thúc mô phỏng
        #10;
        $display("Hoàn thành mô phỏng");
        $finish;
    end

    // Theo dõi các thay đổi
    initial begin
        $monitor("Thời gian=%0d Lệnh=%h RD1=%h RD2=%h ImmExt=%h RegWrite=%b ALUSrc=%b MemWrite=%b",
                 $time, Instr, RD1, RD2, ImmExt, RegWrite, ALUSrc, MemWrite);
    end

endmodule