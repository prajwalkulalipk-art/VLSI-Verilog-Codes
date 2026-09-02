module register_8bit_tb;

    logic clk;
    logic reset;
    logic enable;
    logic [7:0] D;
    logic [7:0] Q;

    register_8bit uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .D(D),
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
        D = 8'b00000000;
        #10;

        reset = 0;
        enable = 1;
        D = 8'b10101010;
        #10;

        D = 8'b11001100;
        #10;

        // Enable OFF - Q holds previous value
        enable = 0;
        D = 8'b11111111;
        #10;

        // Enable ON
        enable = 1;
        D = 8'b01010101;
        #10;

        D = 8'b00110011;
        #10;

        $finish;

    end

endmodule