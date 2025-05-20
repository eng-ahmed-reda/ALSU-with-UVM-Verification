`include "uvm_macros.svh"  // Include UVM macros
import uvm_pkg::*;  // Import UVM package
import alsu_test_pkg::*;

module top();
  bit clk, rst;
  alsu_if alsu_vif (clk);  // Instantiate the ALSU interface

  // Instantiate the ALSU Device Under Test (DUT)
  ALSU DUT (
    .A(alsu_vif.A),
    .B(alsu_vif.B),
    .cin(alsu_vif.cin),
    .serial_in(alsu_vif.serial_in),
    .red_op_A(alsu_vif.red_op_A),
    .red_op_B(alsu_vif.red_op_B),
    .opcode(alsu_vif.opcode),
    .bypass_A(alsu_vif.bypass_A),
    .bypass_B(alsu_vif.bypass_B),
    .clk(alsu_vif.clk),
    .rst(alsu_vif.rst),
    .direction(alsu_vif.direction),
    .leds(alsu_vif.leds),
    .out(alsu_vif.out)
  );

  // Instantiate assertions
  alsu_assertions assertions_inst (
    .leds(alsu_vif.leds),
    .out(alsu_vif.out),
    .invalid(DUT.invalid),  // Ensure DUT has a defined 'invalid' signal
    .clk(alsu_vif.clk)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Toggle clock every 5 time units
  end

  // Reset generation
  initial begin
    rst = 1;  // Assert reset
    #10 rst = 0;  // Deassert reset after 10 time units
  end

  // Run UVM test
  initial begin
    uvm_config_db#(virtual alsu_if)::set(null, "uvm_test_top", "ALSU_IF", alsu_vif);
    run_test("alsu_test");
  end
endmodule