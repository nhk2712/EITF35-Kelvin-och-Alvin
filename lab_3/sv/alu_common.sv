`timescale 1ns/1ps

package alu_common;

    typedef enum logic [2:0]
    {
        INPUT_A,
        INPUT_B,
        U_ADD,
        U_SUB,
        U_MOD3,
        S_ADD,
        S_SUB,
        S_MOD3
    } alu_op_t;

endpackage
