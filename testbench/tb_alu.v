
`timescale 1ns / 1ps

module tb_alu;

    // Inputs
    reg cin;
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] opcode;
    reg [2:0] shift_amt;

    // Outputs
    wire [7:0] res;
    wire [3:0] flag; // {Zero, Negative, Overflow, Carry}

    // Instantiate the Unit Under Test (UUT)
    // Note: This testbench assumes the existence of an 'add_sub' module 
    // as instantiated within your ALU.
    alu uut (
        .res(res),
        .flag(flag),
        .cin(cin),
        .opcode(opcode),
        .a(a),
        .b(b),
        .shift_amt(shift_amt)
    );

    initial begin
        // Monitor changes to inputs and outputs
        $monitor("Time=%0t | Op=%b (%s) | a=%h, b=%h, cin=%b, shift=%d -> res=%h | Flags (Z,N,V,C)=%b",
                 $time, opcode, op_to_string(opcode), a, b, cin, shift_amt, res, flag);
    end

    // Test stimulus
    initial begin
        // Initialize Inputs
        a = 0; b = 0; cin = 0; opcode = 4'b0; shift_amt = 0;
        
        // Wait for global reset
        #100;

        // Test Cases
        // ---------- ADD (0000) ----------
        opcode = 4'b0000;
        a = 8'd10; b = 8'd5; cin = 0; #10;   // 10 + 5 = 15
        a = 8'd250; b = 8'd10; cin = 0; #10; // 250 + 10 = 4 (Carry=1)
        a = 8'd100; b = 8'd100; cin = 0; #10; // 100 + 100 = 200 (-56) (Overflow=1, Negative=1)
        a = 8'hFF; b = 8'h01; cin = 0; #10; // -1 + 1 = 0 (Zero=1, Carry=1)

        #20;

        // ---------- SUB (0001) ----------
        opcode = 4'b0001;
        a = 8'd10; b = 8'd5; cin = 0; #10;  // 10 - 5 = 5
        a = 8'd5; b = 8'd10; cin = 0; #10;  // 5 - 10 = -5 (Negative=1, Carry=1 for no borrow)
        a = 8'd131; b = 8'd2; cin = 0; #10; // 127 - (-2) = 129 (-127) (Overflow=1, Negative=1)
        a = 8'd20; b = 8'd20; cin = 0; #10; // 20 - 20 = 0 (Zero=1, Carry=1)
        
        #20;
        
        // ---------- Logical Operations ----------
        opcode = 4'b0010; a = 8'b11001100; b = 8'b10101010; #10; // AND
        opcode = 4'b0011; #10; // OR
        opcode = 4'b0100; #10; // XOR
        opcode = 4'b0101; a = 8'b11001100; #10; // NOT

        #20;
        
        // ---------- INC/DEC ----------
        opcode = 4'b0110; a = 8'd99; #10;  // INC 99 -> 100
        opcode = 4'b0110; a = 8'd255; #10; // INC 255 -> 0
        opcode = 4'b0111; a = 8'd100; #10; // DEC 100 -> 99
        opcode = 4'b0111; a = 8'd0; #10;   // DEC 0 -> 255 (Negative=1)

        #20;
        
        // ---------- Shift/Rotate Operations ----------
        a = 8'b11010010;
        shift_amt = 3;
        opcode = 4'b1000; #10; // Logical Left Shift
        opcode = 4'b1001; #10; // Logical Right Shift
        opcode = 4'b1010; #10; // Rotate Left
        opcode = 4'b1011; #10; // Rotate Right

        #20;
        
        // ---------- Default Case ----------
        opcode = 4'b1111; #10; // Test default case

        #50;
        $finish; // End simulation
    end
    
    // Helper function to convert opcode to string for display
    function [5*8:1] op_to_string(input [3:0] op);
        case(op)
            4'b0000: op_to_string = "ADD";
            4'b0001: op_to_string = "SUB";
            4'b0010: op_to_string = "AND";
            4'b0011: op_to_string = "OR ";
            4'b0100: op_to_string = "XOR";
            4'b0101: op_to_string = "NOT";
            4'b0110: op_to_string = "INC";
            4'b0111: op_to_string = "DEC";
            4'b1000: op_to_string = "SLL";
            4'b1001: op_to_string = "SRL";
            4'b1010: op_to_string = "ROL";
            4'b1011: op_to_string = "ROR";
            default: op_to_string = "---";
        endcase
    endfunction

endmodule
