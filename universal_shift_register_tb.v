
//==============================================================
// Project      : 4-Bit Universal Shift Register
// Module       : universal_shift_register_tb
// Date         : 11 October 2026
// Description  : Testbench for a 4-Bit Universal Shift Register
//
// Purpose:
//   1. Verify the Hold operation.
//   2. Verify the Shift Right operation.
//   3. Verify the Shift Left operation.
//   4. Verify the Parallel Load operation.
//   5. Compare actual outputs with expected results.
//   6. Display PASS or FAIL messages during simulation.
//
// Note:
//   This is a simulation-only testbench, not synthesizable
//   FPGA hardware code.
//==============================================================

`timescale 1ns / 1ps

module universal_shift_register_tb;

    //==========================================================
    // 1. Testbench Signals
    //==========================================================

    reg        clk;          // Clock signal for the DUT
    reg  [1:0] sel;          // Selects the register operation
    reg  [3:0] data_input;   // Four-bit parallel input data
    wire [3:0] data_output;  // Four-bit registered output

    //==========================================================
    // 2. Instantiate the Design Under Test (DUT)
    //==========================================================
    // Connect the testbench signals to the inputs and outputs
    // of the Universal Shift Register module.
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
    // Generate a clock with a 10 ns period.
    // 5 ns HIGH + 5 ns LOW = 10 ns period (100 MHz).
    //==========================================================

    initial begin
        clk = 1'b0;

        forever begin
            #5 clk = ~clk;
        end
    end

    //==========================================================
    // 4. Test and Verification Task
    //==========================================================
    // Purpose:
    //   Apply an operation and input data, then verify that
    //   the DUT output matches the expected output.
    //
    // Inputs:
    //   mode     : Operation selector (sel)
    //   input_data: Parallel input data
    //   expected : Expected register output
    //==========================================================

    task check_result;
        input [1:0] mode;
        input [3:0] input_data;
        input [3:0] expected;

        begin
            // Apply test inputs at the falling clock edge.
            // This allows inputs to settle before the next
            // rising clock edge.
            @(negedge clk);
            sel        = mode;
            data_input = input_data;

            // Wait for the rising clock edge, when the DUT
            // performs the selected register operation.
            @(posedge clk);

            // Allow a short time for nonblocking assignments
            // in the DUT to update data_output.
            #1;

            // Compare actual and expected outputs.
            // Case inequality ( !== ) also detects X and Z.
            if (data_output !== expected) begin

                // Report the test failure and stop simulation.
                $display(
                    "FAIL: sel=%b input=%b expected=%b actual=%b",
                    mode, input_data, expected, data_output
                );

                $finish;
            end
            else begin

                // Report a successful test.
                $display(
                    "PASS: sel=%b input=%b output=%b",
                    mode, input_data, data_output
                );
            end
        end
    endtask

    //==========================================================
    // 5. Test Sequence
    //==========================================================
    // Execute all four operating modes and verify the results.
    //==========================================================

    initial begin

        // Initialize testbench inputs.
        sel        = 2'b11;
        data_input = 4'b0000;

        //------------------------------------------------------
        // Test 1: Parallel Load
        //------------------------------------------------------
        // sel = 11 selects parallel load.
        // Expected: data_output = 1011
        check_result(2'b11, 4'b1011, 4'b1011);

        //------------------------------------------------------
        // Test 2: Hold
        //------------------------------------------------------
        // sel = 00 retains the previous register value.
        // Expected: data_output remains 1011.
        check_result(2'b00, 4'b0000, 4'b1011);

        //------------------------------------------------------
        // Test 3: Shift Right
        //------------------------------------------------------
        // Current value: 1011
        // Shift right, insert 0 at the MSB.
        // Expected: 0101
        check_result(2'b01, 4'b0000, 4'b0101);

        //------------------------------------------------------
        // Test 4: Shift Right Again
        //------------------------------------------------------
        // Current value: 0101
        // Shift right, insert 0 at the MSB.
        // Expected: 0010
        check_result(2'b01, 4'b0000, 4'b0010);

        //------------------------------------------------------
        // Test 5: Parallel Load a New Value
        //------------------------------------------------------
        // Load 0110 into the register.
        // Expected: 0110
        check_result(2'b11, 4'b0110, 4'b0110);

        //------------------------------------------------------
        // Test 6: Shift Left
        //------------------------------------------------------
        // Current value: 0110
        // Shift left, insert 0 at the LSB.
        // Expected: 1100
        check_result(2'b10, 4'b0000, 4'b1100);

        //------------------------------------------------------
        // Test 7: Shift Left Again
        //------------------------------------------------------
        // Current value: 1100
        // Shift left, insert 0 at the LSB.
        // Expected: 1000
        check_result(2'b10, 4'b0000, 4'b1000);

        //------------------------------------------------------
        // Test 8: Parallel Load Zeros
        //------------------------------------------------------
        // Load 0000 into the register.
        // Expected: 0000
        check_result(2'b11, 4'b0000, 4'b0000);

        // All test cases completed successfully.
        $display("--------------------------------");
        $display("ALL TESTS PASSED");
        $display("--------------------------------");

        // Stop the simulation.
        $finish;

    end

endmodule
