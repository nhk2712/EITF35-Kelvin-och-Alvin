`timescale 1ns/1ps

module sequence_detector_tb();
    
    localparam int CLOCK_PERIOD_NS = 100;
    localparam int RESET_STOP_NS = 150;

    logic clk;
    logic reset_n;

    // Output signals from modules
    logic [3:0] bit_stream;
    logic data_serial;
    logic data_valid;
    logic moore_detected;
    logic mealy_detected;

    int moore_count = 0;
    int mealy_count = 0; 

    // Clock generation
    initial begin : clock_gen
        clk = 0;
        forever #(CLOCK_PERIOD_NS/2) clk = ~clk;
    end

    initial begin : rst_gen
        reset_n = 0;
        // Assert reset after the set amount of ns
        // (since it's active low reset, 1 will disable it)
        #RESET_STOP_NS reset_n = 1;

        // Data starts being streamed
        @(data_valid)
        // Wait for data to finish streaming
        @(!data_valid)
        // Finish the simulation
        $finish;
    end

    //always_comb begin : counters
        // Create counters here to count sequence occurrences for both Mealy and Moore implementations
        // ???
    //end
    always_ff @(posedge clk or negedge reset_n) begin : counters
        if (!reset_n) begin
            moore_count <= 0;
            mealy_count <= 0;
        end else begin
            // Count Moore detections
            if (moore_detected)
                moore_count <= moore_count + 1;

            // Count Mealy detections
            if (mealy_detected)
                mealy_count <= mealy_count + 1;
        end
    end

    // Display counts at the end of simulation
    final begin
        $display("========================================");
        $display("Simulation finished");
        $display("Moore detections: %0d", moore_count);
        $display("Mealy detections: %0d", mealy_count);
        $display("========================================");
    end


    // Module instantiations
    stimulus_generator #(.FILE_NAME("stimuli.txt"), .SAMPLE_WIDTH(4)) stim_gen (
        // inputs
        .clk(clk),
        .reset_n(reset_n),
        // outputs
        .data_valid(data_valid),
        .stimulus_stream(bit_stream)
        );

    par2ser p2s_conv (
        // inputs
        .clk(clk),
        .reset_n(reset_n),
        .data_parallel(bit_stream),
        // outputs
        .data_serial(data_serial)
        );

    sequence_detector_moore uut_moore (
        // inputs
        .clk(clk),
        .reset_n(reset_n),
        .data_serial(data_serial),
        .data_valid(data_valid),
        // outputs
        .data_out(moore_detected)
        );

    sequence_detector_mealy uut_mealy (
        // inputs
        .clk(clk),
        .reset_n(reset_n),
        .data_serial(data_serial),
        .data_valid(data_valid),
        // outputs
        .data_out(mealy_detected)
        );

endmodule
