module Data_Memory(clk, rst, WE, WD, A, RD, funct3);
    input clk, rst, WE;
    input [31:0] WD, A;
    input [2:0] funct3;
    output [31:0] RD;
    
    reg [31:0] mem [0:1023];
    wire [9:0] addr = A[11:2];
    reg [31:0] read_data;
    
    // Khởi tạo bộ nhớ
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'b0;
    end
    
    // Đọc dữ liệu
    always @(*) begin
        read_data = mem[addr];
        
        case(funct3)
            3'b000: RD = {{24{read_data[7]}}, read_data[7:0]};     // LB
            3'b001: RD = {{16{read_data[15]}}, read_data[15:0]};   // LH
            3'b010: RD = read_data;                                // LW
            3'b100: RD = {24'b0, read_data[7:0]};                  // LBU
            3'b101: RD = {16'b0, read_data[15:0]};                 // LHU
            default: RD = read_data;
        endcase
    end
    
    // Ghi dữ liệu
    always @(posedge clk) begin
        if (WE) begin
            case(funct3)
                3'b000: mem[addr] = {mem[addr][31:8], WD[7:0]};    // SB
                3'b001: mem[addr] = {mem[addr][31:16], WD[15:0]};  // SH
                3'b010: mem[addr] = WD;                            // SW
                default: mem[addr] = WD;
            endcase
        end
    end
endmodule
