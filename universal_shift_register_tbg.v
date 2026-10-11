
//==============================================================
// Project     : 4-Bit Universal Shift Register
// Module      : universal_shift_register_tb
// Date        : 11 October 2026
// Description : Testbench for functional verification
//
// Purpose:
//   1. Verify parallel load operation.
//   2. Verify hold operation.
//   3. Verify shift-right operation.
//   4. Verify shift-left operation.
//   5. Compare actual outputs with expected results.
//   6. Display PASS or FAIL messages.
//
// Note:
//   This testbench is used for simulation only.
//==============================================================

`timescale 1ns / 1ps

module universal_shift_register_tb;

    //==========================================================
    // 1. Testbench Signals
    //==========================================================

    reg        clk;
    reg  [1:0] sel;
    reg  [3:0] data_input;
    wire [3:0] data_output;

    //==========================================================
    // 2. Instantiate the Design Under Test (DUT)
    //==========================================================

    universal_shift_register DUT (
        .clk         (clk),
        .sel         (sel),
        .data_input  (data_input),
        .data_output (data_output)
    );

    //==========================================================
    // 3. Clock Generation
    //==========================================================
    // Clock period = 10 ns
    // Clock frequency = 100 MHz
    //==========================================================

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end

    //==========================================================
    // 4. Verification Task
    //==========================================================
    // Purpose:
    //   Apply inputs, wait for the active clock edge, and
    //   compare the DUT output with the expected output.
    //
    // Arguments:
    //   mode      : Operation selector
    //   input_data: Parallel input data
    //   expected  : Expected register output
    //==========================================================

    task check_result;
        input [1:0] mode;
        input [3:0] input_data;
        input [3:0] expected;

        begin
            // Apply inputs at the falling clock edge.
            @(negedge clk);

            sel        = mode;
            data_input = input_data;

            // Wait for the next rising clock edge.
            @(posedge clk);

            // Allow the nonblocking assignment to complete.
            #1;

            // Compare actual output with expected output.
            if (data_output !== expected) begin

                $display(
                    "FAIL: sel=%b input=%b expected=%b actual=%b",
                    mode, input_data, expected, data_output
                );

                // Stop simulation if the test fails.
                $finish;

            end
            else begin

                $display(
                    "PASS: sel=%b input=%b output=%b",
                    mode, input_data, data_output
                );

            end
        end
    endtask

    //==========================================================
    // 5. Apply Test Cases
    //==========================================================

    initial begin

        // Initialize testbench inputs.
        sel        = 2'b11;
        data_input = 4'b0000;

        //======================================================
        // Test 1: Parallel Load
        // Load 1011; expected output = 1011.
        //======================================================

        check_result(2'b11, 4'b1011, 4'b1011);

        //======================================================
        // Test 2: Hold
        // Retain 1011; expected output = 1011.
        //======================================================

        check_result(2'b00, 4'b0000, 4'b1011);

        //======================================================
        // Test 3: Shift Right
        // 1011 -> 0101; insert 0 at the MSB.
        //======================================================

        check_result(2'b01, 4'b0000, 4'b0101);

        //======================================================
        // Test 4: Shift Right Again
        // 0101 -> 0010.
        //======================================================

        check_result(2'b01, 4'b0000, 4'b0010);

        //======================================================
        // Test 5: Parallel Load
        // Load 0110; expected output = 0110.
        //======================================================

        check_result(2'b11, 4'b0110, 4'b0110);

        //======================================================
        // Test 6: Shift Left
        // 0110 -> 1100; insert 0 at the LSB.
        //======================================================

        check_result(2'b10, 4'b0000, 4'b1100);

        //======================================================
        // Test 7: Shift Left Again
        // 1100 -> 1000.
        //======================================================

        check_result(2'b10, 4'b0000, 4'b1000);

        //======================================================
        // Test 8: Parallel Load Zeros
        // Load 0000; expected output = 0000.
        //======================================================

        check_result(2'b11, 4'b0000, 4'b0000);

        //======================================================
        // Verification Summary
        //======================================================

        $display("================================");
        $display("ALL TESTS PASSED");
        $display("================================");

        // Terminate the simulation.
        $finish;

    end

endmodule
