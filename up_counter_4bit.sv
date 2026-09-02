module up_counter_4bit (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic [3:0] Q
);

    always_ff @(posedge clk) begin
        if (reset)
            Q <= 4'b0000;
        else if (enable)
            Q <= Q + 1'b1;
    end

endmodule
