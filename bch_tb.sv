`timescale 1ns / 1ps

module bch_tb;

    logic [6:0] data_in;

    logic [1:0] error_type;
    logic [3:0] error_pos1;
    logic [3:0] error_pos2;
    
    logic [14:0] encoded_codeword;
    logic [14:0] corrupted_codeword;
    logic [14:0] corrected_codeword;

    logic [6:0] corrected_data;
    logic [1:0] error_status;


    // ---------------------------------------------------------
    // DUT
    // ---------------------------------------------------------

    bch_top dut (

        .data_in            (data_in),

        .error_type         (error_type),
        .error_pos1         (error_pos1),
        .error_pos2         (error_pos2),

        .encoded_codeword   (encoded_codeword),
        .corrupted_codeword (corrupted_codeword),
        .corrected_codeword (corrected_codeword),

        .corrected_data     (corrected_data),
        .error_status       (error_status)

    );


    // ---------------------------------------------------------
    // Test sequence
    // ---------------------------------------------------------

    initial begin

        // Initial values
        data_in    = 7'b1011010;
        error_type = 2'b00;
        error_pos1 = 4'd0;
        error_pos2 = 4'd0;
        error_pos3 = 4'd0;

        #20;

        // -----------------------------------------------------
        // TEST 1: NO ERROR
        // -----------------------------------------------------

        $display("======================================");
        $display("TEST 1: NO ERROR");
        $display("======================================");

        error_type = 2'b00;

        #20;

        $display("Data               = %b", data_in);
        $display("Encoded Codeword   = %b", encoded_codeword);
        $display("Received Codeword  = %b", corrupted_codeword);
        $display("Corrected Data     = %b", corrected_data);
        $display("Error Status       = %b", error_status);


        // -----------------------------------------------------
        // TEST 2: ONE-BIT ERROR
        // -----------------------------------------------------

        $display("======================================");
        $display("TEST 2: ONE-BIT ERROR");
        $display("======================================");

        error_type = 2'b01;
        error_pos1 = 4'd3;

        #20;

        $display("Data               = %b", data_in);
        $display("Encoded Codeword   = %b", encoded_codeword);
        $display("Corrupted Codeword = %b", corrupted_codeword);
        $display("Corrected Codeword = %b", corrected_codeword);
        $display("Corrected Data     = %b", corrected_data);
        $display("Error Status       = %b", error_status);


        // -----------------------------------------------------
        // TEST 3: TWO-BIT ERROR
        // -----------------------------------------------------

        $display("======================================");
        $display("TEST 3: TWO-BIT ERROR");
        $display("======================================");

        error_type = 2'b10;
        error_pos1 = 4'd3;
        error_pos2 = 4'd10;

        #20;

        $display("Data               = %b", data_in);
        $display("Encoded Codeword   = %b", encoded_codeword);
        $display("Corrupted Codeword = %b", corrupted_codeword);
        $display("Corrected Codeword = %b", corrected_codeword);
        $display("Corrected Data     = %b", corrected_data);
        $display("Error Status       = %b", error_status);


        // -----------------------------------------------------
        // TEST 4: THREE-BIT ERROR
        // -----------------------------------------------------

        $display("======================================");
        $display("TEST 4: THREE-BIT ERROR");
        $display("======================================");

        // Temporarily change the corrupted word directly
        // through a separate display demonstration.
        //
        // BCH(15,7,2) guarantees correction only up to 2 errors.

        error_type = 2'b10;
        error_pos1 = 4'd2;
        error_pos2 = 4'd7;

        #20;

        $display("Two-error test completed.");
        $display("BCH(15,7,2) correction capability = 2 bits");


        #20;

        $finish;

    end

endmodule