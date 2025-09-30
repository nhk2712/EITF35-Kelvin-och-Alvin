`timescale 1ns/1ps

module bcd_to_7seg(
    input logic [3:0] bcd_in,
    output logic [6:0] sev_seg
);
    logic [6:0] sev_seg_temp;

    always_comb begin
        case (bcd_in)
            4'd0: sev_seg_temp = 7'b1111110; // 0
            4'd1: sev_seg_temp = 7'b0110000; // 1
            4'd2: sev_seg_temp = 7'b1101101; // 2
            4'd3: sev_seg_temp = 7'b1111001; // 3
            4'd4: sev_seg_temp = 7'b0110011; // 4
            4'd5: sev_seg_temp = 7'b1011011; // 5
            4'd6: sev_seg_temp = 7'b1011111; // 6
            4'd7: sev_seg_temp = 7'b1110000; // 7
            4'd8: sev_seg_temp = 7'b1111111; // 8
            4'd9: sev_seg_temp = 7'b1111011; // 9
            4'd10: sev_seg_temp = 7'b0000001; // minus sign (-)
            4'd11: sev_seg_temp = 7'b1000111; // letter F, overflow
            default: sev_seg_temp = 7'b0000000; // blank/error
        endcase
    end

    assign sev_seg = sev_seg_temp;
endmodule