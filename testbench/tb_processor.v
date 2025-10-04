`timescale 1ns / 1ps


module tb_processor_test;
    reg clk;
    reg rst;
    wire [3:0] processor_flags;

    processor_test my_cpu_ut (
        .clk(clk),
        .rst(rst),
        .flags(processor_flags)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    // Monitor registers and flags (after they update)
    initial begin
        @(negedge rst);
        @(posedge clk);

        $display("Time(ns) | PC | R0 R1 R2 R3 R4 R5 R6 R7 | Flags(Z,N,V,C)");
        $display("---------------------------------------------------------");

        forever @(posedge clk) begin
            $display("%0t | %d | %3d %3d %3d %3d %3d %3d %3d %3d | %b",
                     $time,
                     my_cpu_ut.pc,
                     my_cpu_ut.regfile.R[0],
                     my_cpu_ut.regfile.R[1],
                     my_cpu_ut.regfile.R[2],
                     my_cpu_ut.regfile.R[3],
                     my_cpu_ut.regfile.R[4],
                     my_cpu_ut.regfile.R[5],
                     my_cpu_ut.regfile.R[6],
                     my_cpu_ut.regfile.R[7],
                     processor_flags);
        end
    end

    // Simulation stop
    initial begin
        #200;
        $finish;
    end

endmodule 
