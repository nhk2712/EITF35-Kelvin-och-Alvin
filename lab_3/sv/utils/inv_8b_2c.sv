`timescale 1ns/1ps

module inv_8b_2c(
    input logic [7:0] in_8b,
    
    output logic [8:0] out_9b
);

    logic [8:0] in_9b, one_c_9b;

    assign in_9b = {in_8b[7], in_8b};
    assign one_c_9b = ~in_9b;
    assign out_9b = one_c_9b + 9'd1;

endmodule