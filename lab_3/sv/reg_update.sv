`timescale 1ns/1ps

module reg_update (
    input logic clk,
    input logic rst,
    input logic [1:0] reg_ctrl,
    input logic [7:0] reg_input,
    output logic [7:0] a,
    output logic [7:0] b
    );

    logic [7:0] reg_a, reg_a_next, reg_b, reg_b_next;

    always_ff @(posedge clk or posedge rst) begin : Sequential
        if (rst) begin
            reg_a <= '0;
            reg_b <= '0;
        end else begin
            reg_a <= reg_a_next;
            reg_b <= reg_b_next;
        end
    end

    always_comb begin : Combinational
        // Default
        reg_a_next = reg_a;
        reg_b_next = reg_b;

        // Conditional
        if (reg_ctrl[0]) reg_a_next = reg_input;
        if (reg_ctrl[1]) reg_b_next = reg_input;
    end

    assign a = reg_a;
    assign b = reg_b;

endmodule
