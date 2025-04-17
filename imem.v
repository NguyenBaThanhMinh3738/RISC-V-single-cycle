module imem (
    input [31:0] a,
    output [31:0] rd
);
reg [31:0] RAM[31:0];  // Đúng kích thước cho 32 lệnh

// Đọc chương trình từ program.hex
initial begin
    $readmemh("D:/riscv_project_new/src/program.hex", RAM);
end

// Đọc dữ liệu từ RAM tại địa chỉ a[31:2]
assign rd = RAM[a[31:2]];
endmodule
