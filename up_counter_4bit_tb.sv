module up_counter_4bit_tb;

    logic clk;
    logic reset;
    logic enable;
    logic [3:0] Q;

    up_counter_4bit uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .Q(Q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test
    initial begin

        reset = 1;
        enable = 0;
        #10;

        reset = 0;
        enable = 1;
        #80;

        // Stop counting
        enable = 0;
        #20;

        // Start counting again
        enable = 1;
        #40;

        // Reset
        reset = 1;
        #10;

        reset = 0;
        enable = 1;
        #30;

        $finish;

    end

endmodule