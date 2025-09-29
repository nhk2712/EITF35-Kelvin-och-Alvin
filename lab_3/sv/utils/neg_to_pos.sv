`timescale 1ns/1ps

module neg_to_pos( // 8-bit converter
    input logic [7:0] neg_2c,

    output logic [7:0] pos
);
    logic [7:0] pre_pos;

    assign pre_pos = ~neg_2c;
    assign pos = pre_pos + 8'd1;
endmodule