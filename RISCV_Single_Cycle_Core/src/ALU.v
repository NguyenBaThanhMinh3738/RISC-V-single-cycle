module ALU(
    input [31:0] A,          // First operand
    input [31:0] B,          // Second operand
    input [2:0] ALUControl,  // Operation control
    output reg [31:0] Result, // Result
    output Zero,             // Zero flag
    output OverFlow,         // Overflow flag
    output Carry,            // Carry flag
    output Negative          // Negative flag
);

    wire [31:0] Sum;
    wire Cout;

    // Compute Sum for ADD/SUB operations
    assign {Cout,Sum} = (ALUControl[0] == 1'b0) ? A + B : (A + ((~B)+1));

    // Main ALU operation
    always @(*) begin
        case (ALUControl)
            3'b000: Result = Sum;          // ADD
            3'b001: Result = Sum;          // SUB
            3'b010: Result = A & B;        // AND
            3'b011: Result = A | B;        // OR
            3'b100: Result = B;            // LUI: pass immediate directly
            3'b101: Result = {{31{1'b0}},(Sum[31])}; // SLT
            3'b110: Result = A + B;        // AUIPC: PC + immediate
            default: Result = 32'b0;
        endcase
    end

    // Flag generation
    assign Zero = (Result == 32'b0);
    assign OverFlow = ((Sum[31] ^ A[31]) & (~(ALUControl[0] ^ B[31] ^ A[31])) & (~ALUControl[1]));
    assign Carry = ((~ALUControl[1]) & Cout);
    assign Negative = Result[31];

endmodule