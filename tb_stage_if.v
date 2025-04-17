module tb_stage_if;
    reg clk, reset;
    wire [31:0] pc, instr;
    reg [31:0] pc_next;

    stage_IF dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .instr(instr),
        .pc_next(pc_next)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1; pc_next = 0;
        #10 reset = 0;
        pc_next = 4; #10;
        pc_next = 8; #10;
        pc_next = 12; #10;
        $stop;
    end
endmodule