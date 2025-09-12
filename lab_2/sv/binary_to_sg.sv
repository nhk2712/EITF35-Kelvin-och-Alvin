// TITLE: binary_to_sgd.sv
// PROJECT: Keyboard VLSI lab
// DESCRIPTION: Simple look-up table

`timescale 1ns/1ps

module binary_to_sg (
    input logic [3:0] binary_in,
    output logic [7:0] sev_seg
    );

    localparam [7:0] LUT [0:15] = '{
        8'b1100_0000, // 0
        8'b1111_1001, // 1
        8'b1010_0100, // 2
        8'b1011_0000, // 3
        8'b1001_1001, // 4
        8'b1001_0010, // 5
        8'b1000_0010, // 6
        8'b1111_1000, // 7
        8'b1000_0000, // 8
        8'b1001_0000, // 9
        8'b1000_0110, // 10 → show E
        8'b1111_1111, // 11 → blank
        8'b1111_1111, // 12 → blank
        8'b1111_1111, // 13 → blank
        8'b1111_1111, // 14 → blank
        8'b1111_1111  // 15 → blank
    };

    // Output assigned from LUT
    assign sev_seg = LUT[binary_in];

endmodule
