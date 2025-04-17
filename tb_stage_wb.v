module tb_stage_wb;
    reg memtoreg;
    reg [31:0] aluout, memdata;
    wire [31:0] result;

    stage_WB dut (
        .memtoreg(memtoreg),
        .aluout(aluout),
        .memdata(memdata),
        .result(result)
    );

    initial begin
        aluout = 32'h12345678;
        memdata = 32'h87654321;

        memtoreg = 0; #10;
        memtoreg = 1; #10;
        $stop;
    end
endmodule