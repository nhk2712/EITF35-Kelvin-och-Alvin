// TITLE: sync_keyboard.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Synchronize keyboard clock and data to system clock

`timescale 1ns/1ps

module sync_keyboard (
    input logic clk,
    input logic kb_clk,
    input logic kb_data,
    output logic kb_clk_sync,
    output logic kb_data_sync
    );

endmodule
