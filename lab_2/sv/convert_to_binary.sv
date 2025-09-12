// TITLE: convert_to_binary.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Look-up-table

`timescale 1ns/1ps

module convert_to_binary (
    input logic [7:0] scan_code_in,
    output logic [3:0] binary_out
    );
    
    localparam logic [3:0] LUT [0:255] = '{
        default:4'hA, // Not numerical key, make it equivalent to number 10 (hex A)
        8'h16: 4'd1, 
        8'h1E: 4'd2, 
        8'h26: 4'd3, 
        8'h25: 4'd4, 
        8'h2E: 4'd5,
        8'h36: 4'd6,
        8'h3D: 4'd7,
        8'h3E: 4'd8,
        8'h46: 4'd9,
        8'h45: 4'd0,
        8'h00: 4'hB, // Can be idle at high or low idk
        8'hFF: 4'hB // When no key is pressed, treat is as number 11 (hex B)
    };

    assign binary_out = LUT[scan_code_in];
endmodule
