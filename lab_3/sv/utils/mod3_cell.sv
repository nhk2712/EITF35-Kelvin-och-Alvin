`timescale 1ns/1ps

module mod3_cell(
    input logic [7:0] inp_A,
    input logic [7:0] inp_theta,

    output logic [7:0] out_x
);

    // 9-bit adder signals
    logic [8:0] adder_param1;
    logic [8:0] adder_param2;
    logic [8:0] adder_sum;
    logic adder_carry_out;

    adder uut_adder(
        .param1(adder_param1),
        .param2(adder_param2),

        .sum(adder_sum),
        .carry_out(adder_carry_out)
    );

    // pos to neg 2c signals (used for U_SUB)
    logic [7:0] p2n_pos; // unsigned 8-bit input, range 0-255 // Internal B
    logic [8:0] p2n_neg_2c; // 9-bit output, 2C

    pos_to_2c uut_pos_to_2c(
        .pos(p2n_pos),

        .neg_2c(p2n_neg_2c)
    );

    assign adder_param1 = {'0, inp_A};
    assign p2n_pos = (inp_A >= inp_theta) ? inp_theta : '0;
    assign adder_param2 = p2n_neg_2c;

    assign out_x = adder_sum[7:0];

endmodule