`timescale 1ns / 1ps

module tb_multiplier;

    // Inputs
    reg signed [7:0] multipliad;
    reg signed [7:0] multiplier;

    // Outputs
    wire signed [15:0] res;
    wire sign_out;

    // Instantiate the multiplier
    multiplier uut (
        .multipliad(multipliad),
        .multiplier(multiplier),
        .product(res),
        .sign_out(sign_out)
    );

    // Task to run a single multiplication
    task run_test;
        input signed [7:0] a;
        input signed [7:0] b;
        begin
            multipliad = a;
            multiplier = b;
            #1; // allow combinational logic to settle
            $display("Multipliad = %0d, Multiplier = %0d, Result = %0d, Sign_out = %b",
                     a, b, res, sign_out);
        end
    endtask

    // Run all four sign combinations
    initial begin
        $display("Starting Booth Multiplier Test...");

        run_test(8'd12, 8'd10);    // ++
        run_test(8'd11, -8'd10);   // +-
        run_test(-8'd10, 8'd10);   // -+
        run_test(-8'd9, -8'd10);  // --

        $display("Test Completed.");
        $stop;
    end

endmodule
