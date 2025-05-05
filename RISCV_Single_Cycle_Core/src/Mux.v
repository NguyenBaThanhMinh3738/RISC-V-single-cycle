module Mux(a, b, s, c);
    input [31:0] a, b;
    input s;
    output [31:0] c;
    
    assign c = s ? b : a;
endmodule

module Mux4(a, b, c, d, s, y);
    input [31:0] a, b, c, d;
    input [1:0] s;
    output reg [31:0] y;
    
    always @(*) begin
        case(s)
            2'b00: y = a;  // ALU Result
            2'b01: y = b;  // Memory
            2'b10: y = c;  // PC+4
            2'b11: y = d;  // Immediate (LUI)
        endcase
    end
endmodule
