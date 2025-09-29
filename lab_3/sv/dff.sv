`timescale 1ns/1ps

module dff #(
    parameter integer W = 8
    ) (
    input logic clk,
    input logic rst,
    input logic [W-1:0] d,
    output logic [W-1:0] q
    );

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
            q <= '0;
        end else begin
            q <= d;
        end
    end

endmodule
