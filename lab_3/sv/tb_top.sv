`timescale 1ns/1ps

module tb_top();
    // DUT signals
    logic clk;
    logic rst;
    logic b_enter, b_sign;
    logic [7:0] alu_input;
    logic [6:0] seven_seg;
    logic [3:0] anode;

    // Instantiate DUT
    alu_top dut (
        .clk(clk),
        .rst(rst),
        .b_enter(b_enter),
        .b_sign(b_sign),
        .alu_input(alu_input),
        .seven_seg(seven_seg),
        .anode(anode)
    );

    // Clock
    always #5 clk = ~clk; // 100MHz

    // Simple button press task
    task press_button(input logic btn, ref logic btn_signal);
        begin
            btn_signal = 1;
            @(posedge clk);
            btn_signal = 0;
            repeat(5) @(posedge clk); // wait for debounce FSM to settle
        end
    endtask

    // Stimulus
    initial begin
        // Init
        clk = 0;
        rst = 1;
        b_enter = 0;
        b_sign  = 0;
        alu_input = 0;

        // Release reset
        #20 rst = 0;

        // Example: load A = 25
        alu_input = 8'd25;
        press_button(b_enter, b_enter); // enter value into A

        // Example: load B = 17
        alu_input = 8'd17;
        press_button(b_enter, b_enter); // enter value into B

        // Example: toggle function (depends on alu_ctrl FSM design)
        press_button(b_sign, b_sign);   // cycle fn

        // Wait to observe
        repeat(50) @(posedge clk);

        // Example: another operand, A = 200
        alu_input = 8'd200;
        press_button(b_enter, b_enter);

        // Observe output
        repeat(200) @(posedge clk);

        $finish;
    end

endmodule