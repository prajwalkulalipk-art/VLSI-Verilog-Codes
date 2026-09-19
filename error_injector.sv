module error_injector (
    input  logic [14:0] codeword_in,

    input  logic [1:0]  error_type,
    input  logic [3:0]  error_pos1,
    input  logic [3:0]  error_pos2,

    output logic [14:0] corrupted_codeword
);

    always_comb begin

        // Start with the original BCH codeword
        corrupted_codeword = codeword_in;

        case (error_type)

            // 00 = No error
            2'b00: begin
                corrupted_codeword = codeword_in;
            end

            // 01 = Single-bit error
            2'b01: begin
                corrupted_codeword =
                    codeword_in ^ (15'b000000000000001 << error_pos1);
            end

            // 10 = Two-bit error
            2'b10: begin
                corrupted_codeword =
                    codeword_in ^
                    (15'b000000000000001 << error_pos1) ^
                    (15'b000000000000001 << error_pos2);
            end

            // Other values = no error
            default: begin
                corrupted_codeword = codeword_in;
            end

        endcase

    end

endmodule