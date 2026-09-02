module parking_lot_controller_tb;

    logic clk;
    logic reset;

    logic car_in;
    logic car_out1;
    logic car_out2;

    logic [2:0] count1;
    logic [2:0] count2;

    logic [2:0] available1;
    logic [2:0] available2;

    logic empty1;
    logic empty2;

    logic full1;
    logic full2;
    logic full;


    parking_lot_controller uut (
        .clk(clk),
        .reset(reset),

        .car_in(car_in),

        .car_out1(car_out1),
        .car_out2(car_out2),

        .count1(count1),
        .count2(count2),

        .available1(available1),
        .available2(available2),

        .empty1(empty1),
        .empty2(empty2),

        .full1(full1),
        .full2(full2),

        .full(full)
    );


    //================ CLOCK =========================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    //================ TEST ==========================

    initial begin

        reset = 1;
        car_in = 0;
        car_out1 = 0;
        car_out2 = 0;

        #10;

        reset = 0;


        //------------ 14 VEHICLES ENTER -------------

        car_in = 1;
        #140;

        car_in = 0;
        #10;


        //------ BOTH LOTS EXIT IN PARALLEL ----------

        car_out1 = 1;
        car_out2 = 1;

        #10;

        car_out1 = 0;
        car_out2 = 0;

        #20;


        //------ MORE VEHICLES ENTER -----------------

        car_in = 1;
        #30;

        car_in = 0;

        #20;

        $finish;

    end

endmodule