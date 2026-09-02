module register_8bit (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [7:0] D,
    output logic [7:0] Q
);

    always_ff @(posedge clk) begin
        if (reset)
            Q <= 8'b00000000;
        else if (enable)
            Q <= D;
    end

endmodule
