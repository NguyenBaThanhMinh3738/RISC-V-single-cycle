module Execute_Stage_tb();
    // Inputs
    reg [31:0] PC;
    reg [31:0] RD1;          // SrcA
    reg [31:0] RD2;
    reg [31:0] ImmExt;
    reg ALUSrc;
    reg [2:0] ALUControl;

    // Outputs
    wire [31:0] PCTarget;
    wire [31:0] ALUResult;
    wire Zero;
    wire [31:0] SrcB;

    // Instantiate the modules
    Mux Mux_ALU(
        .a(RD2),
        .b(ImmExt),
        .s(ALUSrc),
        .c(SrcB)
    );

    PC_Adder Branch_Adder(
        .a(PC),
        .b(ImmExt),
        .c(PCTarget)
    );

    ALU ALU(
        .A(RD1),
        .B(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .Zero(Zero),
        .OverFlow(),  // Not testing these outputs
        .Carry(),
        .Negative()
    );

    // Test stimulus
    initial begin
        // Add waveform dumping
        $dumpfile("Execute_Stage_tb.vcd");
        $dumpvars(0, Execute_Stage_tb);

        // Initialize inputs
        PC = 32'h0;
        RD1 = 32'h0;
        RD2 = 32'h0;
        ImmExt = 32'h0;
        ALUSrc = 0;
        ALUControl = 3'b000;
        #10;

         // Test case 1: R-type ADD operation (ALUSrc = 0)
        PC = 32'h1000;
        RD1 = 32'hA;         // SrcA = 10
        RD2 = 32'h7;         // RD2 = 7
        ImmExt = 32'h10;     // Not used when ALUSrc = 0
        ALUSrc = 0;          // Select RD2
        ALUControl = 3'b000; // ADD operation
        #10;
        // Check results
        if(SrcB !== 32'h7 || ALUResult !== 32'h11 || PCTarget !== 32'h1010)
            $display("Test 1 Failed");
        else
            $display("Test 1 Passed");

        // Test case 2: I-type ADD operation (ALUSrc = 1)
        PC = 32'h2000;
        RD1 = 32'h8;         // SrcA = 8
        RD2 = 32'h3;         // Not used when ALUSrc = 1
        ImmExt = 32'h4;      // Immediate = 4
        ALUSrc = 1;          // Select immediate
        ALUControl = 3'b000; // ADD operation
        #10;
        // Check results
        if(SrcB !== 32'h4 || ALUResult !== 32'hC || PCTarget !== 32'h2004)
            $display("Test 2 Failed");
        else
            $display("Test 2 Passed");

        // Test case 3: SUB operation
        PC = 32'h3000;
        RD1 = 32'hA;         // SrcA = 10
        RD2 = 32'h4;         // RD2 = 4
        ImmExt = 32'h8;      // Not used when ALUSrc = 0
        ALUSrc = 0;          // Select RD2
        ALUControl = 3'b001; // SUB operation
        #10;
        // Check results
        if(SrcB !== 32'h4 || ALUResult !== 32'h6 || PCTarget !== 32'h3008)
            $display("Test 3 Failed");
        else
            $display("Test 3 Passed");

        // Test case 4: Zero flag test
        RD1 = 32'h5;
        RD2 = 32'h5;
        ALUSrc = 0;
        ALUControl = 3'b001; // SUB operation
        #10;
        // Check Zero flag
        if(!Zero)
            $display("Test 4 Failed");
        else
            $display("Test 4 Passed");

        // Test case 5: LUI instruction
        // lui x1, 0xABCDE
        PC = 32'h1000;
        RD1 = 32'h0;         // Not used
        RD2 = 32'h0;         // Not used
        ImmExt = 32'hABCDE000; // Upper immediate << 12
        ALUSrc = 1;          // Select immediate
        ALUControl = 3'b100; // LUI operation
        #10;
        // Check results
        if(ALUResult !== 32'hABCDE000)
            $display("Test 5 (LUI) Failed: Expected 0xABCDE000, got %h", ALUResult);
        else
            $display("Test 5 (LUI) Passed");

        // Test case 6: AUIPC instruction
        // auipc x1, 0x1234
        PC = 32'h2000;
        RD1 = PC;            // PC value
        RD2 = 32'h0;         // Not used
        ImmExt = 32'h1234000; // Upper immediate << 12
        ALUSrc = 1;          // Select immediate
        ALUControl = 3'b110; // AUIPC operation
        #10;
        // Check results
        if(ALUResult !== 32'h3234000) // 0x2000 + 0x1234000
            $display("Test 6 (AUIPC) Failed: Expected 0x3234000, got %h", ALUResult);
        else
            $display("Test 6 (AUIPC) Passed");

        // End simulation
        #10;
        $display("Simulation completed");
        $finish;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time=%0d PC=%h RD1=%h RD2=%h ImmExt=%h ALUSrc=%b ALUControl=%b SrcB=%h ALUResult=%h Zero=%b PCTarget=%h",
                 $time, PC, RD1, RD2, ImmExt, ALUSrc, ALUControl, SrcB, ALUResult, Zero, PCTarget);
    end

endmodule
