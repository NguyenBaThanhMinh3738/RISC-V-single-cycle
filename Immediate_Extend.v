module Immediate_Extend(
    input [31:0] Instr,
    input [1:0] ImmSrc,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case(ImmSrc)
            2'b00: // I-type
                ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            2'b01: // S-type
                ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            2'b10: // B-type
                ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            2'b11: // J-type
                ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
            default:
                ImmExt = 32'h0;
        endcase
    end

endmodule