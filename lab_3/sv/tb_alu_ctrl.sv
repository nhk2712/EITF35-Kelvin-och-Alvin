`timescale 1ns/1ps

import alu_common::*;  // must define alu_op_t enum (e.g., INPUT_A, U_ADD, etc.)

module tb_alu_ctrl;

  // DUT signals
  logic clk, rst;
  logic enter, sign;
  alu_op_t fn;
  logic [1:0] reg_ctrl;

  // Device Under Test
  alu_ctrl dut (
    .clk(clk),
    .rst(rst),
    .enter(enter),
    .sign(sign),
    .fn(fn),
    .reg_ctrl(reg_ctrl)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Task to simulate a button press (enter)
  task automatic press_enter;
    begin
      enter = 1'b1;
      @(posedge clk);
      enter = 1'b0;
      @(posedge clk);
    end
  endtask

  // Task to simulate a sign toggle
  task automatic press_sign;
    begin
      sign = 1'b1;
      @(posedge clk);
      sign = 1'b0;
      @(posedge clk);
    end
  endtask

  // Monitor for debugging
  always_ff @(posedge clk) begin
    $display("[%0t] fn=%s reg_ctrl=%b enter=%b sign=%b",
             $time, fn.name(), reg_ctrl, enter, sign);
  end

  // initial begin
  //   $dumpfile("wave.vcd");
  //   $dumpvars(0, tb_alu_ctrl);
  // end


  // Main stimulus
  initial begin
    $display("=== Starting alu_ctrl testbench ===");

    // Initialize
    clk = 0;
    rst = 0;
    enter = 0;
    sign = 0;
    @(posedge clk);
    #1 rst = 1; // release reset

    // Test sequence through unsigned states
    press_enter();  // INPUT_A → INPUT_B
    press_enter();  // INPUT_B → U_ADD
    press_enter();  // U_ADD → U_SUB
    press_enter();  // U_SUB → U_MOD3
    press_enter();  // U_MOD3 → U_ADD (wrap around)

    // Now toggle sign to switch to signed modes
    press_sign();  // U_ADD → S_ADD
    press_enter();  // S_ADD → S_SUB
    press_enter();  // S_SUB → S_MOD3
    press_enter();  // S_MOD3 → S_ADD (wrap around)

    // Toggle sign back to unsigned
    press_sign();  // S_ADD → U_ADD

    // Few more enter presses to confirm proper looping
    press_enter();
    press_enter();

    $display("=== alu_ctrl testbench completed ===");
    $finish;
  end

endmodule
