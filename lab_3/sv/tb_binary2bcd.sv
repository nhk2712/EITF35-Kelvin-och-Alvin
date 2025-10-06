`timescale 1ns/1ps

module tb_binary2bcd;

    logic [7:0] binary_in;
    logic [9:0] bcd_out;

    // DUT (Device Under Test)
    binary2bcd dut (
        .binary_in(binary_in),
        .bcd_out(bcd_out)
    );

    // Task to display results nicely
    task show_result(input [7:0] bin, input [9:0] bcd);
        $display("Binary = %0d (%08b) --> BCD = %0d%0d%0d (raw=%010b)",
                 bin, bin,
                 bcd[9:8], bcd[7:4], bcd[3:0], bcd);
    endtask

    initial begin
        // Run a few sample tests
        binary_in = 8'd0;  #1 show_result(binary_in, bcd_out);
        binary_in = 8'd5;  #1 show_result(binary_in, bcd_out);
        binary_in = 8'd9;  #1 show_result(binary_in, bcd_out);
        binary_in = 8'd12; #1 show_result(binary_in, bcd_out);
        binary_in = 8'd37; #1 show_result(binary_in, bcd_out);
        binary_in = 8'd99; #1 show_result(binary_in, bcd_out);
        binary_in = 8'd123;#1 show_result(binary_in, bcd_out);
        binary_in = 8'd255;#1 show_result(binary_in, bcd_out);

        // Optionally, sweep through all values (might be a lot of output)
        /*
        for (int i = 0; i < 256; i++) begin
            binary_in = i;
            #1 show_result(binary_in, bcd_out);
        end
        */

        $finish;
    end

endmodule
