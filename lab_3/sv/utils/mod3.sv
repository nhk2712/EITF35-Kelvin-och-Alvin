`timescale 1ns/1ps

module mod3(
    input logic [7:0] inp_A,

    output logic [1:0] out_r // mod 3 remainder
);
    logic [7:0] x1, x2, x3, x4, x5, x6, x7; // Internal signals after each cell, there are 7 cascading cells
    
    mod3_cell cell_1(.inp_A(inp_A), .inp_theta(8'd192), .out_x(x1));
    mod3_cell cell_2(.inp_A(x1), .inp_theta(8'd96), .out_x(x2));
    mod3_cell cell_3(.inp_A(x2), .inp_theta(8'd48), .out_x(x3));
    mod3_cell cell_4(.inp_A(x3), .inp_theta(8'd24), .out_x(x4));
    mod3_cell cell_5(.inp_A(x4), .inp_theta(8'd12), .out_x(x5));
    mod3_cell cell_6(.inp_A(x5), .inp_theta(8'd6), .out_x(x6));
    mod3_cell cell_7(.inp_A(x6), .inp_theta(8'd3), .out_x(x7));

    assign out_r = x7[1:0];
endmodule