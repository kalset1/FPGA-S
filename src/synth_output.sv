

module audio_output(
    input logic clock,
    input logic [15:0] data_in,
    output logic sclk, lrclk, sdin, mclk
);
    logic sclk_inter, lrclk_inter, mclk_inter;
    logic [10:0] sclk_counter, lrclk_counter, mclk_counter;
    logic [15:0] data_temp;

    initial begin
        mclk_counter <= 0;
        lrclk_counter <= 0;
        sclk_counter <= 0;
        data_temp <= data_in;
    end

    always_ff @(posedge clock) begin
        sclk <= sclk_inter;
        lrclk <= lrclk_inter;
        mclk <= mclk_inter;
    end

    always_ff @(posedge clock) begin
        if (mclk_counter == 1000) begin
            mclk_counter <= 0;
            mclk_inter <= ~mclk_inter;
        end
        if (lrclk_counter == 100000) begin
            lrclk_counter <= 0;
            lrclk_inter <= ~lrclk_inter;
            data_temp <= data_in;
        end
        if (sclk_counter == 1000000) begin
            sclk_counter <= 0;
            sclk_inter <= ~sclk_inter;
            if (sclk_inter == 0) begin
                sdin <= data_temp[15];
                data_temp <= data_temp << 1;
        end
        sclk_counter <= sclk_counter + 1;
        lrclk_counter <= lrclk_counter + 1;
        mclk_counter <= mclk_counter + 1;
    end
    
endmodule: audio_output