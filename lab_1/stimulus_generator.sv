`timescale 1ns/1ps

// NOTE: This module contains unsynthesizable code. Can you find it?
module stimulus_generator #(
    parameter string FILE_NAME = "stimuli.txt",
    parameter integer SAMPLE_WIDTH = 4
)(
    input logic clk,
    input logic reset_n,
    output logic data_valid,
    output logic [3:0] stimulus_stream
);

    logic sample_clk = 0;
    integer sample_clk_counter = 0;
    logic valid, valid_next = 0;
    logic [SAMPLE_WIDTH-1:0] stimulus_sample = '0;

    always_ff @(posedge clk or negedge reset_n) begin : registers
        if (!reset_n) begin
            sample_clk_counter <= 0;
            sample_clk <= 0;
            valid <= 0;
        end else begin
            if (sample_clk_counter < SAMPLE_WIDTH-1) begin
                sample_clk_counter <= sample_clk_counter + 1;
            end else begin
                sample_clk_counter <= 0;
            end
            if (sample_clk_counter == 0) begin
                sample_clk <= 1;
            end else begin
                sample_clk <= 0;
            end
            valid <= valid_next;
        end
    end

    int stimulus_file;
    string line;
    int stimulus_raw;

    initial begin
        stimulus_sample = '0;
        valid_next = 0;
        stimulus_file = $fopen(FILE_NAME, "r");

        if (stimulus_file == 0) begin
            $fatal("Failed to open stimulus file: %s", FILE_NAME);
        end

        wait (reset_n == 1)

        forever begin
            @(posedge sample_clk);
            if (!$feof(stimulus_file)) begin
                line = "";
                // Cast the result of $fgets to void, in order to ignore the returned value without any warnings
                void'($fgets(line, stimulus_file));
                if ($sscanf(line, "%d", stimulus_raw) == 1) begin
                    stimulus_sample <= stimulus_raw[SAMPLE_WIDTH-1:0];
                    valid_next <= 1;
                end else begin
                    valid_next <= 0;
                end
            end else begin
                valid_next <= 0;
                // Close the stimulus file for clean exit
                $fclose(stimulus_file);
            end
        end
    end

    assign data_valid = valid;
    assign stimulus_stream = stimulus_sample[3:0];

endmodule
