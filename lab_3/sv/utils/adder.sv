`timescale 1ns/1ps

module adder( // 9-bit adder
    input logic [8:0] param1,
    input logic [8:0] param2,

    output logic [8:0] sum
);
    assign sum = param1 + param2;

endmodule