module Main_Decoder_tb();
    // Inputs
    reg [6:0] Op;
    
    // Outputs
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch;
    wire [1:0] ImmSrc, ALUOp;

    // Instantiate the Main_Decoder
    Main_Decoder dut(
        .Op(Op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // Test stimulus
    initial begin
        // Add waveform dumping
        $dumpfile("Main_Decoder_tb.vcd");
        $dumpvars(0, Main_Decoder_tb);
        
        // Test case 1: Load instruction (lw)
        Op = 7'b0000011;
        #10;
        if (RegWrite !== 1'b1 || ALUSrc !== 1'b1 || MemWrite !== 1'b0 || 
            ResultSrc !== 1'b1 || Branch !== 1'b0 || ImmSrc !== 2'b00 || ALUOp !== 2'b00)
            $display("Test 1 Failed");
        
        // Test case 2: Store instruction (sw)
        Op = 7'b0100011;
        #10;
        if (RegWrite !== 1'b0 || ALUSrc !== 1'b1 || MemWrite !== 1'b1 || 
            ResultSrc !== 1'b0 || Branch !== 1'b0 || ImmSrc !== 2'b01 || ALUOp !== 2'b00)
            $display("Test 2 Failed");
        
        // Test case 3: R-type instruction
        Op = 7'b0110011;
        #10;
        if (RegWrite !== 1'b1 || ALUSrc !== 1'b0 || MemWrite !== 1'b0 || 
            ResultSrc !== 1'b0 || Branch !== 1'b0 || ImmSrc !== 2'b00 || ALUOp !== 2'b10)
            $display("Test 3 Failed");
        
        // Test case 4: Branch instruction
        Op = 7'b1100011;
        #10;
        if (RegWrite !== 1'b0 || ALUSrc !== 1'b0 || MemWrite !== 1'b0 || 
            ResultSrc !== 1'b0 || Branch !== 1'b1 || ImmSrc !== 2'b10 || ALUOp !== 2'b01)
            $display("Test 4 Failed");

        // End simulation
        #10;
        $display("Simulation completed");
        $finish;
    end

endmodule