module Instruction_Fetch_Stage_tb();
    // Inputs
    reg clk;
    reg rst;
    reg PCSrc;          // Signal to select between PCPlus4 and PCTarget
    reg [31:0] PCTarget;  // Branch target address

    // Outputs
    wire [31:0] PC;        // Current instruction address
    wire [31:0] PCPlus4;   // PC + 4
    wire [31:0] Instr;     // Fetched instruction
    wire [31:0] PCNext;    // Next PC value

    // Instantiate the modules
    PC_Module Program_Counter(
        .clk(clk),
        .rst(rst),
        .PC(PC),
        .PC_Next(PCNext)
    );

    PC_Adder PC_Plus_4(
        .a(PC),
        .b(32'd4),
        .c(PCPlus4)
    );

    Instruction_Memory Instr_Memory(
        .rst(rst),
        .A(PC),
        .RD(Instr)
    );

    // Multiplexer for selecting next PC value
    assign PCNext = PCSrc ? PCTarget : PCPlus4;

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Add waveform dumping
        $dumpfile("Instruction_Fetch_Stage_tb.vcd");
        $dumpvars(0, Instruction_Fetch_Stage_tb);

        // Initialize inputs
        clk = 0;
        rst = 0;
        PCSrc = 0;
        PCTarget = 32'h0;
        
        // Release reset
        #10 rst = 1;

        // Test case 1: Sequential instruction fetch
        // Let it run for a few cycles with PCSrc = 0
        #20;
        if(PC !== 32'h0 || PCPlus4 !== 32'h4)
            $display("Test 1 Failed: Sequential fetch not working");
        else
            $display("Test 1 Passed: Sequential fetch working");

        // Test case 2: Branch instruction
        PCSrc = 1;
        PCTarget = 32'h1000;
        #10;
        if(PCNext !== 32'h1000)
            $display("Test 2 Failed: Branch target not selected");
        else
            $display("Test 2 Passed: Branch target selected");

        // Test case 3: Return to sequential execution
        PCSrc = 0;
        #10;
        if(PCNext !== (PC + 32'h4))
            $display("Test 3 Failed: Not returned to sequential execution");
        else
            $display("Test 3 Passed: Returned to sequential execution");

        // Test case 4: Reset behavior
        rst = 0;
        #10;
        if(PC !== 32'h0)
            $display("Test 4 Failed: Reset not working");
        else
            $display("Test 4 Passed: Reset working");

        // End simulation
        #10;
        $display("Simulation completed");
        $finish;
    end

    // Optional: Monitor changes
    initial begin
        $monitor("Time=%0d rst=%b PC=%h PCPlus4=%h Instr=%h PCSrc=%b PCTarget=%h PCNext=%h",
                 $time, rst, PC, PCPlus4, Instr, PCSrc, PCTarget, PCNext);
    end

endmodule