module testbench_single;
reg clk, reset;
wire [31:0] pc, instr, aluout, writedata, readdata;
wire memwrite;

// Kết nối đúng các cổng với module riscy_single
riscy_single dut (
    .clk(clk),
    .reset(reset),
    .pc(pc),
    .instr(instr),
    .aluout(aluout),
    .writedata(writedata),
    .readdata(readdata),
    .memwrite(memwrite)
);

// Khởi tạo clock
initial begin
    clk = 0;
    forever #50 clk = ~clk; // Chu kỳ 100 ps
end

// Khởi tạo reset
initial begin
    reset = 1;
    #100 reset = 0;
end

// Hiển thị kết quả
initial begin
    $monitor("Time=%0t PC=%h Instr=%h x1=%h x5=%h x6=%h x10=%h x15=%h Mem[6]=%h",
             $time, dut.pc, dut.instr,
             dut.myreg.regs[1], dut.myreg.regs[5], dut.myreg.regs[6],
             dut.myreg.regs[10], dut.myreg.regs[15],
             dut.dmem.RAM[6]);
end

// Dừng mô phỏng sau 10000 ps
initial begin
    #10000 $stop; // Tăng thời gian để chạy hết chương trình
end

endmodule