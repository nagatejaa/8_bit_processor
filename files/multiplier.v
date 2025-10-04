`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nagateja
// Create Date: 03.10.2025 23:21:15
// Design Name: 8bit Booths multiplier
// Module Name: multiplier
//////////////////////////////////////////////////////////////////////////////////


module multiplier(
    input  signed [7:0] multipliad,
    input  signed [7:0] multiplier,
    output reg signed [15:0] product,
    output reg sign_out
);

    reg [7:0] AC;
    reg [7:0] Q;
    reg qn1;
    reg signed [7:0] BR;
    reg signed [7:0] BR1;
    integer i;

    always @(*) begin
        // Initialize
        AC = 8'd0;
        Q  = multiplier;
        qn1 = 0;
        BR  = multipliad;
        BR1 = -multipliad;

        // Booth Algorithm (combinational loop)
        for (i = 0; i < 8; i = i + 1) begin
            case ({Q[0], qn1})
                2'b01: AC = AC + BR;   // add multiplicand
                2'b10: AC = AC + BR1;  // subtract multiplicand
            endcase

            // Arithmetic shift right {AC,Q,qn1}
            qn1 = Q[0];
            Q   = {AC[0], Q[7:1]};
            AC  = {AC[7], AC[7:1]};

        end

        // Combine result
        product = {AC, Q};
        sign_out = product[15];  // MSB indicates sign
    end

endmodule
