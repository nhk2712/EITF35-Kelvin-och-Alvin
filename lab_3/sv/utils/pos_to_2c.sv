`timescale 1ns/1ps

module pos_to_2c(
    input logic [7:0] pos, // unsigned, range 0-255
    output logic [8:0] neg_2c // use 9-bit 2c, so that we can use full range of 8-bit unsigned pos
);
    logic [8:0] temp_pos;
    logic [8:0] neg_1c;

    assign temp_pos = {'0, pos};
    assign neg_1c = ~temp_pos;
    assign neg_2c = neg_1c + 9'd1;

endmodule