module bch_encoder (
    input  logic [6:0]  data_in,
    output logic [14:0] codeword
);

    logic [14:0] temp;
    logic [7:0]  remainder;

    integer i;

    always_comb begin
        // Place the 7 data bits in the upper part
        temp = {data_in, 8'b0};

        // Initialize remainder
        remainder = 8'b0;

        // Polynomial division using:
        // g(x) = x^8 + x^7 + x^6 + x^4 + 1

        for (i = 14; i >= 8; i = i - 1) begin
            if (temp[i]) begin
                temp[i]     = temp[i]     ^ 1'b1;
                temp[i-1]   = temp[i-1]   ^ 1'b1;
                temp[i-2]   = temp[i-2]   ^ 1'b1;
                temp[i-4]   = temp[i-4]   ^ 1'b1;
                temp[i-8]   = temp[i-8]   ^ 1'b1;
            end
        end

        // Remaining 8 bits are BCH parity bits
        remainder = temp[7:0];

        // Final 15-bit BCH codeword
        codeword = {data_in, remainder};
    end

endmodule