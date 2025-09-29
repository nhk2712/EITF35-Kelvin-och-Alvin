`timescale 1ns/1ps

import alu_common::*;

module alu (
    input logic [7:0] a,
    input logic [7:0] b,
    input alu_op_t fn,
    output logic [7:0] result,
    output logic overflow,
    output logic sign
    );
    
endmodule
