module d_flip_flop_tb;

    logic clk;
    logic d;
    logic q;

    // Instantiate the D flip-flop
    d_flip_flop uut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;

        forever #5 clk = ~clk;
    end

    // Test inputs
    initial begin

        d = 0;

        #12;
        d = 1;

        #10;
        d = 0;

        #10;
        d = 1;

        #10;
        d = 0;

        #10;

        $finish;
    end

endmodule