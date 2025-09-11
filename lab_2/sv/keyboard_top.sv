// TITLE: keyboard_top.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Keyboard top level. Functionality of all modules are mentioned in the manual. All the required interconnects are already done, students only have to fill in SV code in the sub-modules!

`timescale 1ns/1ps

module keyboard_top (
    input logic clk,
    input logic rst,
    input logic kb_data,
    input logic kb_clk,
    output logic [7:0] sc,
    output logic [7:0] num,
    output logic [3:0] seg_en
    );

    // Interconnect signals
    logic kb_clk_sync, kb_data_sync;
    logic edge_found;
    logic [7:0] scan_code;
    logic valid_scan_code;
    logic [3:0] binary_num;
    logic [7:0] code_to_display;

    // Synchronize all input signals from keyboard
    sync_keyboard sync_keyboard_inst (
        .clk(clk),
        .kb_clk(kb_clk),
        .kb_data(kb_data),
        .kb_clk_sync(kb_clk_sync),
        .kb_data_sync(kb_data_sync)
        );

    // Detect the falling edge of kb_clk_sync.
    // Make sure to double check that this module is synthesizable!
    edge_detector edge_detector_inst (
        .clk(clk),
        .rst(rst),
        .kb_clk_sync(kb_clk_sync),
        .edge_found(edge_found)
        );

    // Convert serial kb_data_sync to parallel scan code
    // Make sure to not use edge_found as clock! (i.e. @(posedge edge_found))
    convert_scancode convert_scancode_inst (
        .clk(clk),
        .rst(rst),
        .edge_found(edge_found),
        .serial_data(kb_data_sync),
        .valid_scan_code(valid_scan_code),
        .scan_code_out(scan_code)
        );
    // Drive the LEDs with the shifted output
    assign sc = scan_code;

    // Controller, based on a state machine
    keyboard_ctrl keyboard_ctrl_inst (
        .clk(clk),
        .rst(rst),
        .valid_code(valid_scan_code),
        .scan_code_in(scan_code),
        .code_to_display(code_to_display),
        .seg_en(seg_en)
        );

    convert_to_binary convert_to_binary_inst (
        .scan_code_in(code_to_display),
        .binary_out(binary_num)
        );

    binary_to_sg binary_to_sg_inst (
        .binary_in(binary_num),
        .sev_seg(num)
        );


endmodule
