module Branch_Comparator(A, B, funct3, BrEq, BrLT);
    input [31:0] A, B;
    input [2:0] funct3;
    output BrEq, BrLT;
    
    // BrEq = 1 khi A == B
    assign BrEq = (A == B);
    
    // BrLT phụ thuộc vào loại so sánh (có dấu hoặc không dấu)
    assign BrLT = (funct3 == 3'b110 || funct3 == 3'b111) ? (A < B) : ($signed(A) < $signed(B));
endmodule

