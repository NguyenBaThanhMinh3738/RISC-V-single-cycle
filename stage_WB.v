module stage_WB(
    input memtoreg,
    input [31:0] aluout,
    input [31:0] memdata,
    output [31:0] result
);

    assign result = memtoreg ? memdata : aluout;

endmodule
