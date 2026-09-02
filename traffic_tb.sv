`timescale 1ns/1ps

module traffic_light_tb;

    logic clk;
    logic reset;

    logic red;
    logic yellow;
    logic green;


    // -----------------------------------------
    // Instantiate DUT
    // Use 1 Hz clock for simulation
    // -----------------------------------------

    traffic_light #(
        .CLK_FREQ_HZ(1)
    ) dut (
        .clk    (clk),
        .reset  (reset),
        .red    (red),
        .yellow (yellow),
        .green  (green)
    );


    // -----------------------------------------
    // Clock generation
    // 10 ns period
    // -----------------------------------------

    always #5 clk = ~clk;


    // -----------------------------------------
    // Monitor
    // -----------------------------------------

    initial begin

        $monitor(
            "Time=%0t | clk=%b | reset=%b | RED=%b | GREEN=%b | YELLOW=%b",
            $time,
            clk,
            reset,
            red,
            green,
            yellow
        );

    end


    // -----------------------------------------
    // Test sequence
    // -----------------------------------------

    initial begin

        // Initial values
        clk   = 0;
        reset = 1;

        // Reset for one clock cycle
        #10;

        reset = 0;


        // -------------------------------------
        // RED = 5 seconds
        // GREEN = 5 seconds
        // YELLOW = 2 seconds
        // -------------------------------------

        #120;


        // -------------------------------------
        // Apply reset again
        // -------------------------------------

        reset = 1;

        #10;

        reset = 0;


        // Run again
        #120;


        // End simulation
        $finish;

    end

endmodule