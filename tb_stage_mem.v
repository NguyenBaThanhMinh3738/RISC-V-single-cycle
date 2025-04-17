module tb_stage_mem;
    reg clk;
    reg memwrite;
    reg [31:0] aluout, wd;
    wire [31:0] rd;

    stage_MEM dut (
        .clk(clk),
        .memwrite(memwrite),
        .aluout(aluout),
        .wd(wd),
        .rd(rd)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        memwrite = 1;
        aluout = 32'd0; wd = 32'hAABBCCDD; #10;
        memwrite = 0;
        aluout = 32'd0; #10;
        $stop;
    end
endmodule