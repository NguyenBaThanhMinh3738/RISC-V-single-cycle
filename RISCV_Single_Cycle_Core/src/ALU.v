module ALU(A, B, Result, ALUControl, OverFlow, Carry, Zero, Negative);
    input [31:0]A, B;
    input [3:0]ALUControl;  // Mở rộng thành 4 bit
    output [31:0]Result;
    output OverFlow, Carry, Zero, Negative;
    
    reg [31:0]Result;
    wire [31:0]Sum;
    wire Cout;

    // Compute Sum for ADD/SUB operations
    assign {Cout, Sum} = (ALUControl == 4'b0000) ? A + B : (A + ((~B)+1));
    
    // Flags
    assign Zero = (Result == 32'b0);
    assign Negative = Result[31];
    assign Carry = Cout;
    assign OverFlow = (A[31] == B[31]) && (Result[31] != A[31]);

    // Main ALU operation
    always @(*) begin
        case (ALUControl)
            4'b0000: Result = Sum;          // ADD
            4'b0001: Result = Sum;          // SUB
            4'b0010: Result = {{31{1'b0}}, $signed(A) < $signed(B)}; // SLT
            4'b0011: Result = {{31{1'b0}}, A < B}; // SLTU
            4'b0100: Result = A ^ B;        // XOR
            4'b0101: Result = A << B[4:0];  // SLL
            4'b0110: Result = A >> B[4:0];  // SRL
            4'b0111: Result = $signed(A) >>> B[4:0]; // SRA
            4'b1000: Result = A | B;        // OR
            4'b1001: Result = A & B;        // AND
            default: Result = 32'b0;
        endcase
    end
endmodule
