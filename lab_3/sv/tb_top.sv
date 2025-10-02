`timescale 1ns/1ps

// Before doing simulation:
// - Put debouncer to Count for 4 clk cycles
// - Put 7-seg driver to refresh every 4 clk cycles

module tb_top();
    // DUT inputs
    logic clk;
    logic rst;
    logic b_enter;
    logic b_sign;
    logic [7:0] alu_input;

    // DUT outputs
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

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Refresh-safe wait macro (4 refresh cycles)
    task wait_refresh;
        #(640); // 640ns = 64 clk cycles
    endtask

    // Button press
    task press_button(ref logic button);
        button = 1;
        #10;   // pressed for 1 cycles
        button = 0;
    endtask

    initial begin
        // ---- Reset ----
        rst = 1;
        b_enter = 0;
        b_sign = 0;
        alu_input = 0;
        wait_refresh();   // let reset state display settle
        rst = 0;
        wait_refresh();

        // ---- Show switches directly (operand A candidate) ----
        alu_input = 8'd25;
        wait_refresh();

        // ---- Latch Operand A ----
        press_button(b_enter);
        wait_refresh();

        // ---- Show operand B ----
        alu_input = 8'd10;
        wait_refresh();

        // ---- Latch Operand B ----
        press_button(b_enter);
        wait_refresh();

        // ---- ADD result ----
        wait_refresh();

        // ---- Cycle to SUB ----
        press_button(b_enter);
        wait_refresh();

        // ---- Cycle to MOD ----
        press_button(b_enter);
        wait_refresh();

        // ---- Cycle back to ADD ----
        press_button(b_enter);
        wait_refresh();

        // ---- Toggle SIGN view ----
        press_button(b_sign);
        wait_refresh();

        // ---- Cycle operations in signed mode ----
        press_button(b_enter); // SUB
        wait_refresh();
        press_button(b_enter); // MOD
        wait_refresh();

        // ---- Overflow case ----
        alu_input = 8'd200;
        press_button(b_enter); // latch new A
        wait_refresh();
        alu_input = 8'd200;
        press_button(b_enter); // latch new B
        wait_refresh();        // observe ADD overflow

        // ---- End simulation ----
        $finish;
    end

endmodule