// TITLE: keyboard_ctrl.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Controller to handle the scan codes

`timescale 1ns/1ps

module keyboard_ctrl (
    input logic clk,
    input logic rst,

    input logic valid_code,
    input logic [7:0] scan_code_in,

    output logic [7:0] code_to_display, // scan code of numerical digits
    output logic [3:0] seg_en
    );

    logic [7:0] scan_code_prev, scan_code_prev_next;

    logic [7:0] digit_0, digit_0_next; // right-most
    logic [7:0] digit_1, digit_1_next;
    logic [7:0] digit_2, digit_2_next;
    logic [7:0] digit_3, digit_3_next; // left-most

    logic [3:0] seg_en_temp, seg_en_temp_next;
    logic [7:0] code_to_display_temp;

    logic [15:0] counter, counter_next; // for the LED lighting up, refresh after 2^16 cycles

    always_ff @(posedge clk or posedge rst) begin : blockName
        if (rst) begin
            digit_0 <= '0;
            digit_1 <= '0;
            digit_2 <= '0;
            digit_3 <= '0;
            seg_en_temp <= '0;
            scan_code_prev <= '0;
            counter <= 0;
        end else begin
            digit_0 <= digit_0_next;
            digit_1 <= digit_1_next;
            digit_2 <= digit_2_next;
            digit_3 <= digit_3_next;
            seg_en_temp <= seg_en_temp_next;
            scan_code_prev <= scan_code_prev_next;
            counter <= counter_next;
        end
    end

    always_comb begin
        // Default
        digit_0_next = digit_0;
        digit_1_next = digit_1;
        digit_2_next = digit_2;
        digit_3_next = digit_3;
        seg_en_temp_next = seg_en_temp;
        counter_next = counter + 1;
        code_to_display_temp = '0;
        scan_code_prev_next = scan_code_prev;

        // Shifting
        if (valid_code) begin
            if (scan_code_prev == 8'hF0) begin
                digit_3_next = digit_2;
                digit_2_next = digit_1;
                digit_1_next = digit_0;
                digit_0_next = scan_code_in; // use current input directly
            end

            scan_code_prev_next = scan_code_in; // update AFTER using it
        end

        if (counter == '0) begin
            if (seg_en_temp == 4'b0000) begin
                seg_en_temp_next = 4'b0001; // First time after reset, start with the right-most digit
            end else begin
                seg_en_temp_next = {seg_en_temp[2:0], seg_en_temp[3]};
            end
        end

        case (seg_en_temp) // cannot use LUT for this bcuz LUT requires constants
            4'b0001: code_to_display_temp = digit_0;
            4'b0010: code_to_display_temp = digit_1;
            4'b0100: code_to_display_temp = digit_2;
            4'b1000: code_to_display_temp = digit_3;
            default: code_to_display_temp = 8'h00;
        endcase

    end

    assign code_to_display = code_to_display_temp;
    assign seg_en = ~seg_en_temp; // the anodes are active-low
endmodule
