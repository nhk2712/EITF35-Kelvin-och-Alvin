`timescale 1ns/1ps

module debouncer (
    input logic clk,
    input logic rst,
    input logic button_in,
    output logic button_out
    );

    // With 100MHz clk, we count for 2^21 clk cycles => ~20.97 ms
    // Appropriate debouncing time should be around 20ms. Src: https://www.ti.com/lit/ab/scea094/scea094.pdf
    logic [20:0] count, count_next;
    logic button, button_next;

    always_ff @( posedge clk or negedge rst ) begin
        if (!rst) begin
            count <= '0;
            button <= 0;
        end else begin
            count <= count_next;
            button <= button_next;
        end
    end

    assign count_next = count + 1;
    assign button_next = (count == 0) ? button_in : button;

    assign button_out = button;

endmodule
