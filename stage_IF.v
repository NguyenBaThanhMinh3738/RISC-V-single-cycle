module stage_IF(
    input clk,
    input reset,
    output [31:0] pc,
    output [31:0] instr,
    input [31:0] pc_next
);
    reg [31:0] PC;
    wire [31:0] instruction;

    // Bộ nhớ lệnh
    imem imem_inst (
        .a(PC),
        .rd(instruction)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 0;
        else
            PC <= pc_next;
    end

    assign pc = PC;
    assign instr = instruction;
endmodule
