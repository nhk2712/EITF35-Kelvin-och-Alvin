`timescale 1ns/1ps

import alu_common::*;

// Task/function to check if result is correct. You can call it like a function, as such:
// check_correct(result, expected_result, expected_overflow, expected_sign, a, b, fn, overflow, sign, `__LINE__);
// And fill out the expected result, overflow, and sign to be what you expect based on a, b, fn.
// `__LINE__ is used to get the line number of the function call, so you can easily find what test is performed.
task check_correct;
    input logic [7:0] result;
    input logic [7:0] expected_result;
    input logic expected_overflow;
    input logic expected_sign;
    input logic [7:0] a;
    input logic [7:0] b;
    input alu_op_t fn;
    input logic overflow;
    input logic sign;
    input int line_num;
    begin
        if (result != expected_result) begin
            $display("Error in operation %s with operands a=%b and b=%b on line %d", fn, a, b, line_num);
            $display("Wrong result, got %b but expected %b", result, expected_result);
            $stop;
        end
        if (overflow != expected_overflow) begin
            $display("Error in operation %s with operands a=%b and b=%b on line %d", fn, a, b, line_num);
            $display("Overflow signal is wrong. Expected: %b, actual: %b", expected_overflow, overflow);
            $stop;
        end
        if (sign != expected_sign) begin
            $display("Error in operation %s with operands a=%b and b=%b on line %d", fn, a, b, line_num);
            $display("Sign signal is wrong. Expected: %b, actual: %b", expected_sign, sign);
            $stop;
        end
    end
endtask

module tb_alu ();

    logic [7:0] a;
    logic [7:0] b;
    alu_op_t fn;
    logic [7:0] result;
    logic overflow;
    logic sign;

    // Can be made shorter if you wish
    localparam int PERIOD = 2500;

    initial begin
        
        a = 8'd5;
        b = 8'd3;
        fn = INPUT_A;
        #(PERIOD/2)
        check_correct(result, a, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd9;
        b = 8'd3;
        fn = INPUT_B;
        #(PERIOD/2)
        check_correct(result, b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd17;
        b = 8'd145;
        fn = INPUT_A;
        #(PERIOD/2)
        check_correct(result, a, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd145;
        b = 8'd124;
        fn = INPUT_B;
        #(PERIOD/2)
        check_correct(result, b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd148;
        b = 8'd249;
        fn = U_ADD;
        #(PERIOD/2)
        check_correct(result, a+b, 1, 0, a, b, fn, overflow, sign, `__LINE__);


        #(PERIOD/2)

        a = 8'd213;
        b = 8'd105;
        fn = U_SUB;
        #(PERIOD/2)
        check_correct(result, a-b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd35;
        b = 8'd35;
        fn = U_SUB;
        #(PERIOD/2)
        check_correct(result, a-b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd242;
        b = 8'd104;
        fn = U_ADD;
        #(PERIOD/2)
        check_correct(result, a+b, 1, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd49;
        b = 8'd45;
        fn = U_SUB;
        #(PERIOD/2)
        check_correct(result, a-b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd85;
        b = 8'd36;
        fn = U_MOD3;
        #(PERIOD/2)
        check_correct(result, 1, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        fn = S_ADD;
        #(PERIOD/2)
        check_correct(result, a+b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        fn = S_SUB;
        #(PERIOD/2)
        check_correct(result, a-b, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        fn = S_MOD3;
        #(PERIOD/2)
        check_correct(result, 1, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        // 127
        a = 8'b01111111;
        // -128
        b = 8'b10000000;
        fn = S_SUB;
        #(PERIOD/2)
        check_correct(result, 1, 1, 1, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd10;
        b = 8'd20;
        fn = S_SUB;
        #(PERIOD/2)
        check_correct(result, 10, 0, 1, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        // -1
        a = 8'b11111111;
        fn = S_MOD3;
        #(PERIOD/2)
        check_correct(result, 2, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        // -2
        a = 8'b11111110;
        fn = S_MOD3;
        #(PERIOD/2)
        check_correct(result, 1, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'b11111111;
        b = 8'b00000001;
        fn = S_ADD;
        #(PERIOD/2)
        check_correct(result, 0, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'b00000000;
        b = 8'b11111111;
        fn = S_SUB;
        #(PERIOD/2)
        check_correct(result, 1, 0, 0, a, b, fn, overflow, sign, `__LINE__);

        #(PERIOD/2)

        a = 8'd120;
        b = 8'd50;
        fn = S_ADD;
        #(PERIOD/2)
        check_correct(result, 86, 1, 1, a, b, fn, overflow, sign, `__LINE__);

        // Fill out with more test cases if you want, to make sure you cover all corner cases!
        // Make sure you use blocking operators, and wait slightly before checking so that all signals can change
        // a = ...
        // b = ...
        // fn = ...

        $display("All tests passed!");
        $finish;
    end

    alu uut(
        .a(a),
        .b(b),
        .fn(fn),
        .result(result),
        .overflow(overflow),
        .sign(sign)
    );

endmodule
