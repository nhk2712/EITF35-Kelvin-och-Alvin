`timescale 1ns/1ps

module reg_update (
    input logic clk,
    input logic rst,
    input logic [1:0] reg_ctrl,
    input logic [7:0] reg_input,
    output logic [7:0] a,
    output logic [7:0] b
    );

endmodule
