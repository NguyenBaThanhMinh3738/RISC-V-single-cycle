module regfile (
    input clk,
    input we3,
    input [4:0] ra1, ra2, wa3,
    input [31:0] wd3,
    output [31:0] rd1, rd2
);
    reg [31:0] regs [0:31];

    // Khởi tạo thanh ghi x0 = 0
    initial begin
        regs[0] = 32'd0;
    end

    // Ghi đồng bộ tại cạnh xung clock
    always @(posedge clk) begin
        if (we3 && wa3 != 0) // Không ghi vào x0
            regs[wa3] <= wd3;
    end

    // Đọc tổ hợp
    assign rd1 = (ra1 != 0) ? regs[ra1] : 32'd0;
    assign rd2 = (ra2 != 0) ? regs[ra2] : 32'd0;
endmodule