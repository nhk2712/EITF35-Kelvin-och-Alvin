// TITLE: convert_scancode.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Implement a shift register to convert serial to parallel
// A counter to flag when the valid code is shifted in

`timescale 1ns/1ps

module convert_scancode (
    input logic clk,
    input logic rst,

    input logic edge_found,
    input logic serial_data, // kb_data_sync

    output logic valid_scan_code,
    output logic [7:0] scan_code_out // only 8 bits
    );

    logic [4:0] counter, counter_next; // modulo-11 counter
    logic [9:0] scan_code_temp, scan_code_temp_next; // stop, parity, 8 bits
    logic valid_scan_code_temp;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin // rst
            scan_code_temp <= '0;
            counter <= '0;
        end else begin // pos clk edge
            scan_code_temp <= scan_code_temp_next;
            counter <= counter_next;
        end
    end

    always_comb begin
        // Default
        counter_next = counter;
        scan_code_temp_next = scan_code_temp;
        valid_scan_code_temp = 1'b0;

        if (counter == 4'd11) begin : counter_logic
            counter_next = '0;
            valid_scan_code_temp= 1'b1;
        end else begin
            valid_scan_code_temp = 1'b0;
        end

        if (edge_found) begin : shift_logic // do the shifting here
            scan_code_temp_next = {serial_data, scan_code_temp[9:1]}; // right shift
            counter_next = counter + 1;
        end
    end

    assign scan_code_out = scan_code_temp[7:0];
    assign valid_scan_code = valid_scan_code_temp;

endmodule
