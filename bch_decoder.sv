module bch_decoder (
    input  logic [14:0] received_codeword,

    output logic [6:0]  corrected_data,
    output logic [14:0] corrected_codeword,

    // 00 = No error
    // 01 = 1-bit error corrected
    // 10 = 2-bit errors corrected
    // 11 = Uncorrectable error
    output logic [1:0]  error_status
);

    logic [3:0] syndrome_s1;
    logic [3:0] syndrome_s3;

    logic [3:0] sigma1;
    logic [3:0] sigma2;

    logic [14:0] corrected_word;

    logic [3:0] root_value;

    integer i;

    // ---------------------------------------------------------
    // GF(16) multiplication
    // Primitive polynomial:
    // x^4 + x + 1
    // ---------------------------------------------------------

    function automatic logic [3:0] gf_mult(
        input logic [3:0] a,
        input logic [3:0] b
    );

        logic [7:0] product;
        logic [3:0] aa;
        logic [3:0] bb;
        integer k;

        begin

            product = 8'b0;
            aa = a;
            bb = b;

            for (k = 0; k < 4; k = k + 1) begin

                if (bb[0])
                    product = product ^ {4'b0000, aa};

                bb = bb >> 1;

                if (aa[3])
                    aa = (aa << 1) ^ 4'b0011;
                else
                    aa = aa << 1;

            end

            gf_mult = product[3:0];

        end

    endfunction


    // ---------------------------------------------------------
    // GF(16) power
    // alpha = 0010
    // ---------------------------------------------------------

    function automatic logic [3:0] gf_pow(
        input logic [3:0] base,
        input integer exponent
    );

        logic [3:0] result;
        logic [3:0] value;
        integer n;

        begin

            result = 4'b0001;
            value  = base;
            n      = exponent;

            while (n > 0) begin

                if (n % 2)
                    result = gf_mult(result, value);

                value = gf_mult(value, value);
                n = n / 2;

            end

            gf_pow = result;

        end

    endfunction


    // ---------------------------------------------------------
    // GF(16) inverse
    // a^-1 = a^14
    // ---------------------------------------------------------

    function automatic logic [3:0] gf_inverse(
        input logic [3:0] a
    );

        begin

            if (a == 4'b0000)
                gf_inverse = 4'b0000;
            else
                gf_inverse = gf_pow(a, 14);

        end

    endfunction


    // ---------------------------------------------------------
    // BCH syndrome calculation
    //
    // S1 = r(alpha)
    // S3 = r(alpha^3)
    //
    // alpha is represented by 0010.
    // ---------------------------------------------------------

    function automatic logic [3:0] calculate_syndrome(
        input logic [14:0] word,
        input integer syndrome_power
    );

        logic [3:0] syndrome;
        integer k;
        integer exponent;

        begin

            syndrome = 4'b0000;

            for (k = 0; k < 15; k = k + 1) begin

                if (word[k]) begin

                    exponent = (k * syndrome_power) % 15;

                    syndrome =
                        syndrome ^
                        gf_pow(4'b0010, exponent);

                end

            end

            calculate_syndrome = syndrome;

        end

    endfunction


    // ---------------------------------------------------------
    // BCH Decoder
    // ---------------------------------------------------------

    always_comb begin

        syndrome_s1 = calculate_syndrome(
            received_codeword, 1
        );

        syndrome_s3 = calculate_syndrome(
            received_codeword, 3
        );

        sigma1 = 4'b0000;
        sigma2 = 4'b0000;

        corrected_word = received_codeword;

        error_status = 2'b11;


        // -----------------------------------------------------
        // CASE 1: No error
        // -----------------------------------------------------

        if (syndrome_s1 == 4'b0000 &&
            syndrome_s3 == 4'b0000) begin

            corrected_word = received_codeword;
            error_status = 2'b00;

        end


        // -----------------------------------------------------
        // CASE 2: Single-bit error
        //
        // For one error:
        // sigma1 = S1
        // sigma2 = 0
        // -----------------------------------------------------

        else if (syndrome_s3 ==
                 gf_pow(syndrome_s1, 3)) begin

            sigma1 = syndrome_s1;
            sigma2 = 4'b0000;

            corrected_word = received_codeword;

            // Chien search
            for (i = 0; i < 15; i = i + 1) begin

                root_value =
                    gf_pow(4'b0010, (15 - i) % 15);

                if ((4'b0001 ^
                     gf_mult(sigma1, root_value)) == 0)

                    corrected_word[i] =
                        ~corrected_word[i];

            end

            error_status = 2'b01;

        end


        // -----------------------------------------------------
        // CASE 3: Two-bit errors
        //
        // sigma1 = S1
        //
        // sigma2 = (S3 + S1^3) / S1
        // -----------------------------------------------------

        else if (syndrome_s1 != 4'b0000) begin

            sigma1 = syndrome_s1;

            sigma2 =
                gf_mult(
                    syndrome_s3 ^
                    gf_pow(syndrome_s1, 3),
                    gf_inverse(syndrome_s1)
                );

            corrected_word = received_codeword;

            // Chien search
            for (i = 0; i < 15; i = i + 1) begin

                root_value =
                    gf_pow(4'b0010, (15 - i) % 15);

                if ((4'b0001 ^
                     gf_mult(sigma1, root_value) ^
                     gf_mult(
                         sigma2,
                         gf_mult(root_value, root_value)
                     )) == 0)

                    corrected_word[i] =
                        ~corrected_word[i];

            end

            error_status = 2'b10;

        end

    end


    // ---------------------------------------------------------
    // Final outputs
    // ---------------------------------------------------------

    always_comb begin

        corrected_codeword = corrected_word;

        corrected_data = corrected_word[14:8];

    end

endmodule