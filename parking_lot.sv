    module parking_lot_controller (
    input  logic clk,
    input  logic reset,

    input  logic car_in,

    input  logic car_out1,
    input  logic car_out2,

    output logic [2:0] count1,
    output logic [2:0] count2,

    output logic [2:0] available1,
    output logic [2:0] available2,

    output logic empty1,
    output logic empty2,

    output logic full1,
    output logic full2,

    output logic full
);

    //================ COUNTER LOGIC =================

    always_ff @(posedge clk) begin

        if (reset) begin
            count1 <= 3'd0;
            count2 <= 3'd0;
        end

        else begin

            //------------- VEHICLE ENTRY -------------

            if (car_in) begin

                // Fill Lot 1 first
                if (count1 < 3'd7)
                    count1 <= count1 + 1'b1;

                // Then use Lot 2
                else if (count2 < 3'd7)
                    count2 <= count2 + 1'b1;

            end


            //------------- VEHICLE EXIT --------------

            // Lot 1 exit
            if (car_out1 && count1 > 3'd0)
                count1 <= count1 - 1'b1;

            // Lot 2 exit
            if (car_out2 && count2 > 3'd0)
                count2 <= count2 - 1'b1;

        end

    end


    //================ STATUS LOGIC ==================

    always_comb begin

        available1 = 3'd7 - count1;
        available2 = 3'd7 - count2;

        empty1 = (count1 == 3'd0);
        empty2 = (count2 == 3'd0);

        full1 = (count1 == 3'd7);
        full2 = (count2 == 3'd7);

        full = full1 && full2;

    end

endmodule
