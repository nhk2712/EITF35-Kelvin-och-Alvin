// TITLE: edge_detector.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Make sure not to use posedge/negedge on any other signal than clk

`timescale 1ns/1ps

module edge_detector (
    input logic clk,
    input logic rst,
    input logic kb_clk_sync,
    output edge_found
    );

    logic kb_clk_prev, kb_clk_now; // FFs
    logic edge_found_temp; // Combinatorial, result of the comparison of the FFs

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin // reset
            kb_clk_prev <= '0;
            kb_clk_now <= '0;
        end else begin // pos clock edge
            kb_clk_prev <= kb_clk_now;
            kb_clk_now <= kb_clk_sync;
        end
    end

    always_comb begin
        // Default
        edge_found_temp = 1'b0;

        if (kb_clk_now < kb_clk_prev) begin
            edge_found_temp = 1'b1;
        end else begin
            edge_found_temp = 1'b0;
        end
    end

    assign edge_found = edge_found_temp;

endmodule
