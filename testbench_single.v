module testbench_single;
    reg clk, reset;
    wire [31:0] pc, instr, aluout, writedata, readdata;
    wire memwrite;

    riscv_single dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .aluout(aluout),
        .writedata(writedata),
        .readdata(readdata),
        .memwrite(memwrite)
    );

    // Sửa xung clock
    initial begin
        clk = 0;
        forever #50 clk = ~clk; // Chu kỳ 100 ns (50 ns cao, 50 ns thấp)
    end

    initial begin
        reset = 1;
        #100 reset = 0;
    end

    initial begin
        $monitor("Time=%0t PC=%h Instr=%h x1=%h x2=%h x5=%h x6=%h x10=%h x15=%h Mem[6]=%h",
                 $time, dut.pc, dut.instr,
                 dut.regfile_inst.regs[1], dut.regfile_inst.regs[2],
                 dut.regfile_inst.regs[5], dut.regfile_inst.regs[6],
                 dut.regfile_inst.regs[10], dut.regfile_inst.regs[15],
                 dut.stage_mem.dmem_inst.RAM[6]);
    end

    initial begin
        #10000 $stop;
    end
endmodule