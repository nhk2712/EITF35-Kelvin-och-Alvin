`timescale 1ns/1ps

module seven_seg_driver (
    input logic clk,
    input logic rst,
    input logic [9:0] bcd_digit,
    input logic sign,
    input logic overflow,
    output logic [3:0] digit_anode,
    output logic [6:0] segment
    );
    
endmodule 
