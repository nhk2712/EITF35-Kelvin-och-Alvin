module cond_add (
    input  logic [3:0] in,
    output logic [3:0] out
);
    assign out = (in >= 5) ? (in + 4'd3) : in;
endmodule
