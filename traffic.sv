`timescale 1ns/1ps

module traffic_light #(
    parameter int CLK_FREQ_HZ = 50_000_000
)(
    input  logic clk,
    input  logic reset,

    output logic red,
    output logic yellow,
    output logic green
);

    // -----------------------------------------
    // State declaration
    // -----------------------------------------

    typedef enum logic [1:0] {
        RED_STATE,
        GREEN_STATE,
        YELLOW_STATE
    } state_t;

    state_t state;

    // -----------------------------------------
    // Timer
    // -----------------------------------------

    logic [31:0] counter;

    // Number of clock cycles in one second
    localparam int ONE_SECOND = CLK_FREQ_HZ;


    // -----------------------------------------
    // State register and timer
    // -----------------------------------------

    always_ff @(posedge clk) begin

        if (reset) begin
            state   <= RED_STATE;
            counter <= 0;
        end

        else begin

            case (state)

                // -----------------------------
                // RED = 5 seconds
                // -----------------------------

                RED_STATE: begin

                    if (counter == (5 * ONE_SECOND) - 1) begin
                        counter <= 0;
                        state   <= GREEN_STATE;
                    end

                    else begin
                        counter <= counter + 1;
                    end

                end


                // -----------------------------
                // GREEN = 5 seconds
                // -----------------------------

                GREEN_STATE: begin

                    if (counter == (5 * ONE_SECOND) - 1) begin
                        counter <= 0;
                        state   <= YELLOW_STATE;
                    end

                    else begin
                        counter <= counter + 1;
                    end

                end


                // -----------------------------
                // YELLOW = 2 seconds
                // -----------------------------

                YELLOW_STATE: begin

                    if (counter == (2 * ONE_SECOND) - 1) begin
                        counter <= 0;
                        state   <= RED_STATE;
                    end

                    else begin
                        counter <= counter + 1;
                    end

                end


                // -----------------------------
                // Default
                // -----------------------------

                default: begin
                    state   <= RED_STATE;
                    counter <= 0;
                end

            endcase

        end

    end


    // -----------------------------------------
    // Output logic
    // -----------------------------------------

    always_comb begin

        // Default: all lights OFF
        red    = 1'b0;
        yellow = 1'b0;
        green  = 1'b0;

        case (state)

            RED_STATE:
                red = 1'b1;

            GREEN_STATE:
                green = 1'b1;

            YELLOW_STATE:
                yellow = 1'b1;

            default: begin
                red    = 1'b1;
                yellow = 1'b0;
                green  = 1'b0;
            end

        endcase

    end

endmodule