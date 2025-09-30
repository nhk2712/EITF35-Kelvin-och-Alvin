`timescale 1ns/1ps

module binary2bcd (
    input logic [7:0] binary_in,
    output logic [9:0] bcd_out
    );


    logic [8:0] padded_in;
    assign padded_in = {1'b0, binary_in};
    
    logic [3:0] c1_out, c2_out, c3_out, c4_out, c5_out, c6_out, c7_out;
    

    cond_add c1 (
        .in(padded_in[8:5]),
        .out(c1_out)
    );

    cond_add c2 (
        .in({c1_out[2:0], padded_in[4]}),
        .out(c2_out)
    );

    cond_add c3 (
        .in({c2_out[2:0], padded_in[3]}),
        .out(c3_out)
    );

    cond_add c4 (
        .in({c3_out[2:0], padded_in[2]}),
        .out(c4_out)
    );

    cond_add c5 (
        .in({c4_out[2:0], padded_in[1]}),
        .out(c5_out)
    );

    cond_add c6 (
        .in({1'b0, c1_out[3], c2_out[3], c3_out[3]}),
        .out(c6_out)
    );

    cond_add c7 (
        .in({c6_out[2:0], c4_out[3]}),
        .out(c7_out)
    );

    assign bcd_out = {c6_out[3], c7_out[3:0], c5_out[3:0], binary_in[0]};



endmodule
