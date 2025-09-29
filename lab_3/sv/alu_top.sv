`timescale 1ns/1ps

import alu_common::*;

module alu_top (
    input logic clk,
    input logic rst,

    input logic b_enter,
    input logic b_sign,

    input logic [7:0] alu_input,

    output logic [6:0] seven_seg,
    output logic [3:0] anode
    );

    // SIGNAL DEFINITIONS
    logic enter, sign;
    alu_op_t fn; 
    logic [1:0] reg_ctrl;
    logic [7:0] a, b, result;
    logic overflow, sign_out;
    logic [9:0] bcd_out;

    // DEVELOP THE STRUCTURE OF ALU TOP HERE

    // To provide a clean signal out of a bouncy one coming from a push button:
    debouncer debouncer_enter(
        .clk(clk),
        .rst(rst),
        .button_in(b_enter),
        .button_out(enter)
    );

    debouncer debouncer_sign(
        .clk(clk),
        .rst(rst),
        .button_in(b_sign),
        .button_out(sign)
    );

    // Connect to ALU controller (FSM)
    alu_ctrl uut_alu_ctrl(
        .clk(clk),
        .rst(rst),
        .enter(enter),
        .sign(sign),
        .fn(fn),
        .reg_ctrl(reg_ctrl)
    );


    // Connect to reg. update
    reg_update uut_reg_update(
        .clk(clk),
        .rst(rst),
        .reg_ctrl(reg_ctrl),
        .reg_input(alu_input),
        .a(a),
        .b(b)
    );

    // Connect to ALU (the biggest, main part)
    alu uut_alu(
        .a(a),
        .b(b),
        .fn(fn),
        .result(result),
        .overflow(overflow),
        .sign(sign_out)
    );

    // Connect to BCD converter
    binary2bcd uut_binary2bcd(
        .binary_in(result),
        .bcd_out(bcd_out)
    );

    // Connect to 7-segment display driver
    seven_seg_driver uut_7_seg_driver(
        .clk(clk),
        .rst(rst),
        .bcd_digit(bcd_out),
        .sign(sign_out),
        .overflow(overflow),
        .digit_anode(anode),
        .segment(seven_seg)
    );
endmodule
