// TITLE: keyboard_ctrl.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Controller to handle the scan codes

`timescale 1ns/1ps

module keyboard_ctrl (
    input logic clk,
    input logic rst,
    input logic valid_code,
    input logic [7:0] scan_code_in,
    output logic [7:0] code_to_display,
    output logic [3:0] seg_en
    );

endmodule
