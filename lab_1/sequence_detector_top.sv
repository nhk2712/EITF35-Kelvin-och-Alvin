`timescale 1ns/1ps

// Top module, only includes interconnects between all modules. No need to change anything in this!
module sequence_detector_top (
    input logic clk,
    input logic reset_n,
    input logic [3:0] bit_stream,
    input logic data_valid,
    output logic moore_detected,
    output logic mealy_detected
    );

    // Interconnect signals
    logic data_serial;

    // Instantiate all modules
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
