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
    logic enter;

    // DEVELOP THE STRUCTURE OF ALU TOP HERE

    // To provide a clean signal out of a bouncy one coming from a push button:
    // debouncer debouncer_enter (
    //      .clk(clk),
    //      .rst(rst),
    //      .button_in(b_enter),
    //      .button_out(enter)
    //      );
endmodule
