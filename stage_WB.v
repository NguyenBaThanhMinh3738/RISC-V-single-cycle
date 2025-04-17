module stage_WB(
    input clk,
    input memtoreg, jump,
    input [31:0] aluout, memdata, pc_plus4,
    output reg [31:0] result
);
    always @(posedge clk) begin
        result <= jump ? pc_plus4 : (memtoreg ? memdata : aluout);
    end
endmodule