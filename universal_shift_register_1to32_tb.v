`timescale 1ns/1ps

//================================================================
// Project Name : Universal Shift Register Testbench
// Developer    : Ghulam Yaseen Nangraj
// Date         : 11 October 2026
//
// Purpose:
//   Verify the four operating modes of the universal shift register.
//   The testbench width can be changed from 1 to 32 bits.
//================================================================

module universal_shift_register_tb;

    // Select the width to test: any value from 1 to 32.
    parameter N = 8;

    // Generate the clock signal for the DUT.
    reg clk;

    // Drive the operation selector and parallel input data.
    reg [1:0]   sel;
    reg [N-1:0] data_input;

    // Observe the data stored in the device under test (DUT).
    wire [N-1:0] data_output;

    // Expected value used to check the DUT output.
    reg [N-1:0] expected_output;

    // Instantiate the generalized Universal Shift Register.
    universal_shift_register #(
        .N(N)
    ) DUT (
        .clk(clk),
        .sel(sel),
        .data_input(data_input),
        .data_output(data_output)
    );

    // Generate a clock with a 10 ns period.
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Apply input values and verify each operation.
    initial begin

        // Initialize all testbench inputs.
        sel = 2'b00;
        data_input = {N{1'b0}};
        expected_output = {N{1'b0}};

        // Allow signals to settle before the first test.
        #2;

        // --------------------------------------------------------
        // TEST 1: Parallel Load
        // Load a pattern with all bits set to one.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b11;
        data_input = {N{1'b1}};
        expected_output = {N{1'b1}};

        @(posedge clk);
        #1;
        check_result("Parallel Load");

        // --------------------------------------------------------
        // TEST 2: Hold
        // The register must retain the previously loaded value.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b00;

        @(posedge clk);
        #1;
        check_result("Hold");

        // --------------------------------------------------------
        // TEST 3: Shift Right
        // A zero enters the MSB after shifting right.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b01;
        expected_output = expected_output >> 1;

        @(posedge clk);
        #1;
        check_result("Shift Right");

        // --------------------------------------------------------
        // TEST 4: Shift Left
        // A zero enters the LSB after shifting left.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b10;
        expected_output = expected_output << 1;

        @(posedge clk);
        #1;
        check_result("Shift Left");

        // --------------------------------------------------------
        // TEST 5: Load a single high bit at the LSB.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b11;
        data_input = {{(N-1){1'b0}}, 1'b1};
        expected_output = data_input;

        @(posedge clk);
        #1;
        check_result("Load Single Bit");

        // --------------------------------------------------------
        // TEST 6: Shift Left
        // The single high bit moves one position toward the MSB.
        // For N=1, the high bit shifts out and the result is zero.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b10;
        expected_output = expected_output << 1;

        @(posedge clk);
        #1;
        check_result("Shift Left Single Bit");

        // --------------------------------------------------------
        // TEST 7: Shift Right
        // The high bit returns to the LSB for N greater than 1.
        // For N=1, the result remains zero after the previous shift.
        // --------------------------------------------------------
        @(negedge clk);
        sel = 2'b01;
        expected_output = expected_output >> 1;

        @(posedge clk);
        #1;
        check_result("Shift Right Single Bit");

        // Report completion after all tests have passed.
        $display("----------------------------------------");
        $display("All test cases completed for N = %0d", N);
        $display("----------------------------------------");

        // Stop the simulation.
        $finish;
    end

    // ------------------------------------------------------------
    // Task: Compare the DUT output with the expected result.
    // Display PASS when they match; otherwise display FAIL.
    // ------------------------------------------------------------
    task check_result;
        input [8*32-1:0] test_name;
        begin
            if (data_output === expected_output) begin
                $display(
                    "PASS: %0s | sel=%b | output=%b",
                    test_name, sel, data_output
                );
            end
            else begin
                $display(
                    "FAIL: %0s | sel=%b | expected=%b | actual=%b",
                    test_name, sel, expected_output, data_output
                );
            end
        end
    endtask

endmodule