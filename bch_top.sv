module bch_top (
    input  logic [6:0]  data_in,

    input  logic [1:0]  error_type,
    input  logic [3:0]  error_pos1,
    input  logic [3:0]  error_pos2,

    output logic [14:0] encoded_codeword,
    output logic [14:0] corrupted_codeword,
    output logic [14:0] corrected_codeword,

    output logic [6:0]  corrected_data,
    output logic [1:0]  error_status
);

    // ---------------------------------------------------------
    // BCH Encoder
    // ---------------------------------------------------------

    bch_encoder encoder_inst (
        .data_in  (data_in),
        .codeword (encoded_codeword)
    );


    // ---------------------------------------------------------
    // Error Injector
    // ---------------------------------------------------------

    error_injector injector_inst (
        .codeword_in       (encoded_codeword),
        .error_type        (error_type),
        .error_pos1        (error_pos1),
        .error_pos2        (error_pos2),
        .corrupted_codeword(corrupted_codeword)
    );


    // ---------------------------------------------------------
    // BCH Decoder
    // ---------------------------------------------------------

    bch_decoder decoder_inst (
        .received_codeword(corrupted_codeword),
        .corrected_data   (corrected_data),
        .corrected_codeword(corrected_codeword),
        .error_status     (error_status)
    );

endmodule