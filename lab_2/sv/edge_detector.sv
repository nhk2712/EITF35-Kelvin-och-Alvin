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

logic kb_clk_q;

always_ff @( posedge clk ) begin : flipflop
    if (rst) begin
        kb_clk_q <= 1'b0;
    end else begin
        kb_clk_q <= kb_clk_sync;
    end
end

assign edge_found = (~kb_clk_sync) & kb_clk_q;

endmodule
