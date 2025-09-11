// TITLE: sync_keyboard.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Synchronize keyboard clock and data to system clock
// Based on Appendix 3.4

`timescale 1ns/1ps

module sync_keyboard (
    input logic clk,
    input logic kb_clk,
    input logic kb_data,
    output logic kb_clk_sync,
    output logic kb_data_sync
    );

    // Two-stage synchronizer for kb_clk
    logic kb_clk_ff1, kb_clk_ff2;

    // Two-stage synchronizer for kb_data
    logic kb_data_ff1, kb_data_ff2;

    // Synchronize kb_clk
    always_ff @(posedge clk) begin
        kb_clk_ff1 <= kb_clk;
        kb_clk_ff2 <= kb_clk_ff1;
    end
    assign kb_clk_sync = kb_clk_ff2;

    // Synchronize kb_data
    always_ff @(posedge clk) begin
        kb_data_ff1 <= kb_data;
        kb_data_ff2 <= kb_data_ff1;
    end
    assign kb_data_sync = kb_data_ff2;

endmodule
