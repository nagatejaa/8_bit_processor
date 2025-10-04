`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Nagateja
// Create Date:  03.10.2025 10:45:54
// Design Name: 8 bit register file
// Module Name: reg_file
//////////////////////////////////////////////////////////////////////////////////


module reg_file(
    clk, w, wdata, ra, rb, radda, raddb, wadd
);
    input             clk;
    input             w;
    input      [7:0]  wdata;
    output reg [7:0]  ra, rb;
    input      [2:0]  radda, raddb, wadd;

    // Internal 8x8 memory array
    reg [7:0] R [0:7];

    // --- Synchronous Write Logic ---
    always @(posedge clk) begin
        if (w) begin
            R[wadd] <= wdata;
        end
    end

    // --- Asynchronous Read Logic (This is the essential part) ---
    // This block ensures the read ports are always outputting the correct data.
    always @(*) begin
        ra = R[radda];
        rb = R[raddb];
    end

endmodule
