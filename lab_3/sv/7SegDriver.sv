`timescale 1ns/1ps

module seven_seg_driver (
    input logic clk,
    input logic rst,

    input logic [9:0] bcd_digit,
    input logic sign,
    input logic overflow,
    
    output logic [3:0] digit_anode,
    output logic [6:0] segment
    );
    
    // Registers
    logic [14:0] led_counter, led_counter_next; // refresh every 2^15 cycles
    logic [3:0] anode_temp, anode_temp_next;

    // Combinatorial signals
    logic [3:0] bcd_disp;
    logic [3:0] leftmost;
    logic [6:0] seg_out;

    always_ff @(posedge clk or posedge rst) begin : Sequential
        if (rst) begin
            led_counter <= '0;
            anode_temp <= '0;
        end else begin
            led_counter <= led_counter_next;
            anode_temp <= anode_temp_next;
        end
    end

    bcd_to_7seg uut_bcd_to_7seg(
        .bcd_in(bcd_disp),
        .sev_seg(seg_out)
    );

    always_comb begin : Combinational
        // Default
        led_counter_next = led_counter + 1;
        anode_temp_next = anode_temp;
        leftmost = 4'd12;

        // Anode shifting
        if (led_counter == '0) begin
            if (anode_temp == 4'b0000) begin
                anode_temp_next = 4'b0001; // First time after reset, start with the right-most digit
            end else begin
                anode_temp_next = {anode_temp[2:0], anode_temp[3]};
            end
        end

        // Handle leftmost display
        if (overflow) leftmost = 4'd11; // F, prioritized
        else if (sign) leftmost = 4'd10; // minus

        // Select the corresponding digit to display
        case (anode_temp) 
            4'b0001: bcd_disp = bcd_digit[3:0];
            4'b0010: bcd_disp = bcd_digit[7:4];
            4'b0100: bcd_disp = {'0, bcd_digit[9:8]};
            4'b1000: bcd_disp = leftmost;
            default: bcd_disp = 4'd12; // blank
        endcase
    end

    assign digit_anode = ~anode_temp; // Anode pins on the board are active-low
    assign segment = seg_out;
endmodule 
