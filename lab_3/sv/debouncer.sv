`timescale 1ns/1ps

module debouncer (
    input logic clk,
    input logic rst,
    input logic button_in,
    output logic button_out
    );

    // Range to count 20ms with a 50MHz clock
    logic [19:0] count, count_next;
    logic button, button_next;

    always_ff @( posedge clk or posedge rst ) begin
        if (rst) begin
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
