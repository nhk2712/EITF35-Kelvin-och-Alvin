`timescale 1ns/1ps

import alu_common::*;

// Purely combinatorial
module alu (
    input logic [7:0] a,
    input logic [7:0] b,
    input alu_op_t fn,

    output logic [7:0] result,
    output logic overflow,
    output logic sign
    );

    // Internal signals for the ALU operation
    logic [7:0] result_temp;
    logic overflow_temp;
    logic sign_temp;

    // 9-bit adder signals
    logic [8:0] adder_param1;
    logic [8:0] adder_param2;
    logic [8:0] adder_sum;

    adder uut_adder(
        .param1(adder_param1),
        .param2(adder_param2),

        .sum(adder_sum)
    );

    // neg to pos signals (used to invert result if it's negative)
    logic [7:0] n2p_neg_2c;
    logic [7:0] n2p_pos;

    neg_to_pos uut_neg_to_pos(
        .neg_2c(n2p_neg_2c),

        .pos(n2p_pos)
    );

    // pos to neg 2c signals (used for U_SUB)
    logic [7:0] p2n_pos; // unsigned 8-bit input, range 0-255
    logic [8:0] p2n_neg_2c; // 9-bit output, 2C

    pos_to_2c uut_pos_to_2c(
        .pos(p2n_pos),

        .neg_2c(p2n_neg_2c)
    );

    // inv 8bit 2C signals (used for B in S_SUB)
    logic [7:0] inv_in_8b;
    logic [8:0] inv_out_9b;

    inv_8b_2c uut_inv_8b_2c(
        .in_8b(inv_in_8b),

        .out_9b(inv_out_9b)
    );

    // mod3 signals
    logic [7:0] mod3_in;
    logic [1:0] mod3_out;

    mod3 uut_mod3(
        .inp_A(mod3_in),

        .out_r(mod3_out)
    );

    always_comb begin : Computation
        // Default (to avoid latches)
        adder_param1 = '0;
        adder_param2 = '0;

        n2p_neg_2c = '0;

        p2n_pos = '0;

        inv_in_8b = '0;

        mod3_in = '0;

        result_temp = '0;
        overflow_temp = '0;
        sign_temp = '0;

        // Conditional
        case (fn)
            U_ADD: begin // unsigned addition
                adder_param1 = {'0, a};
                adder_param2 = {'0, b};

                result_temp = adder_sum[7:0];
                overflow_temp = adder_sum[8];
                sign_temp = '0;
            end 

            S_ADD: begin // 2C signed addition
                adder_param1 = {'0, a};
                adder_param2 = {'0, b};

                n2p_neg_2c = adder_sum[7:0];

                result_temp = (adder_sum[7]) ? n2p_pos : adder_sum[7:0];
                overflow_temp = (a[7] & b[7] & ~adder_sum[7]) | (~a[7] & ~b[7] & adder_sum[7]);
                sign_temp = adder_sum[7];
            end

            U_SUB: begin // unsigned subtraction
                adder_param1 = {'0, a};
                p2n_pos = b;
                adder_param2 = p2n_neg_2c;

                n2p_neg_2c = adder_sum[7:0];

                result_temp = (adder_sum[8]) ? n2p_pos : adder_sum[7:0];
                overflow_temp = '0;
                sign_temp = adder_sum[8];
            end

            S_SUB: begin // signed subtraction
                adder_param1 = {a[7], a};
                inv_in_8b = b;
                adder_param2 = inv_out_9b;

                n2p_neg_2c = adder_sum[7:0];

                result_temp = (adder_sum[8]) ? n2p_pos : adder_sum[7:0];
                overflow_temp = (a[7] ^ b[7]) & (adder_sum[8] ^ a[7]);
                sign_temp = adder_sum[8]; // result becomes 9-bit here
            end

            U_MOD3: begin // unsigned A mod 3
                mod3_in = a;

                result_temp = {'0, mod3_out};
                overflow_temp = '0;
                sign_temp = '0;
            end

            S_MOD3: begin // signed A mod 3
                mod3_in = a;

                logic [1:0] mod3_out_A_neg = {~mod3_out[1] & ~mod3_out[0], mod3_out[1] & ~mod3_out[0]};
                logic [1:0] mod3_out_processed = (a[7]) ? mod3_out_A_neg : mod3_out;

                result_temp = {'0, mod3_out_processed};
                overflow_temp = '0;
                sign_temp = '0;
            end
        endcase
    end
    
    assign result = result_temp;
    assign overflow = overflow_temp;
    assign sign = sign_temp;
endmodule
