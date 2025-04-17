module pc (
    input clk, reset,
    input [31:0] pcnext,
    output reg [31:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset) pc <= 32'd0;
        else pc <= pcnext;
    end
endmodule