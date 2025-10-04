`timescale 1ns / 1ps



//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nagateja
// Create Date: 03.10.2025 19:24:40
// Design Name: ALU which performs add, sub, mul and all logical operaitons
// Module Name: alu
//////////////////////////////////////////////////////////////////////////////////



module alu(
    res, MSB, flag, cin, opcode, a, b, shift_amt
);
    input cin;
    input [7:0] a, b;
    input [3:0] opcode;       // 4-bit opcode now
    input [2:0] shift_amt;    // 3-bit shift amount

    
    output reg [7:0] res;
    output reg [3:0] flag;
    output reg [7:0] MSB; 

    wire [7:0] sumout, subout;
    wire sumc, subc;
    wire add = 1'b0;
    wire sub = 1'b1;
    wire [15:0] temp;
    wire mulflag;

    // Add/Sub modules
    add_sub m1(.m(add), .sum(sumout), .cout(sumc), .a(a), .b(b), .cin(cin));
    add_sub m2(.m(sub), .sum(subout), .cout(subc), .a(a), .b(b), .cin(cin));
    
   multiplier mul(.multipliad($signed(a)), .multiplier($signed(b)), .product(temp), .sign_out(mulflag));


   always @(*) begin
    // defaults
    res   = 8'b0;
    MSB   = 8'b0;
    flag  = 4'b0000;

    case(opcode)
        4'b0000: begin // ADD
            res     = sumout;
            flag[0] = sumc; // Carry
        end
        4'b0001: begin // SUB
            res     = subout + 1;
            flag[0] = subc;
        end
        4'b0010: res = a & b;
        4'b0011: res = a | b;
        4'b0100: res = a ^ b;
        4'b0101: res = ~a;
        4'b0110: res = a + 1;
        4'b0111: res = a - 1;

        // Shift/Rotate
        4'b1000: res = a << shift_amt;
        4'b1001: res = a >> shift_amt;
        4'b1010: res = (a << shift_amt) | (a >> (8 - shift_amt));
        4'b1011: res = (a >> shift_amt) | (a << (8 - shift_amt));

        // MUL
        4'b1101: begin
            res     = temp[7:0];
            MSB     = temp[15:8];
            flag[3] = (temp == 16'b0);  // Zero flag from full product
            flag[2] = temp[15];         // Negative flag from MSB of product
            flag[1] = 1'b0;             // Overflow not used
            flag[0] = 1'b0;             // Carry not used
        end
    endcase

    // Overflow (only for add/sub)
    if (opcode == 4'b0000) begin
        flag[1] = (a[7] & b[7] & ~res[7]) | (~a[7] & ~b[7] & res[7]);
    end else if (opcode == 4'b0001) begin
        flag[1] = (a[7] & ~b[7] & ~res[7]) | (~a[7] & b[7] & res[7]);
    end

    // Zero/Negative (skip for MUL because already handled)
    if (opcode != 4'b1101) begin
        flag[3] = (res == 8'b0);
        flag[2] = res[7];
    end
end

endmodule
