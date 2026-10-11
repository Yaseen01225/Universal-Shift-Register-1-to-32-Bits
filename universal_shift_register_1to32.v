//================================================================
// Project Name : Generalized Universal Shift Register
// Description  : Parameterized 1-bit to 32-bit shift register
// Developer    : Ghulam Yaseen Nangraj
// Date         : 11 October 2026
// Language     : Verilog HDL
// Target       : FPGA / Xilinx Vivado
//
// Purpose:
//   1. Hold the current register data.
//   2. Shift data one bit to the right.
//   3. Shift data one bit to the left.
//   4. Load all input bits simultaneously.
//
// Operation Selection:
//   sel = 2'b00 : Hold
//   sel = 2'b01 : Shift Right
//   sel = 2'b10 : Shift Left
//   sel = 2'b11 : Parallel Load
//
// Note:
//   Set parameter N to a value between 1 and 32.
//   All operations occur on the rising edge of clk.
//================================================================

module universal_shift_register #(
    parameter N = 8                 // Select register width: 1 to 32
)(
    input  wire         clk,        // Clock input
    input  wire [1:0]   sel,        // Operation selection input
    input  wire [N-1:0] data_input, // Data to load into the register
    output reg  [N-1:0] data_output // Current stored register data
);

    // Execute the selected register operation on the rising clock edge.
    always @(posedge clk) begin

        // Select the required operation using the two control bits.
        case (sel)

            2'b00: begin
                // HOLD: Keep the current register contents unchanged.
                data_output <= data_output;
            end

            2'b01: begin
                // SHIFT RIGHT: Move every bit one position to the right.
                // A zero enters the most significant bit (MSB).
                data_output <= data_output >> 1;
            end

            2'b10: begin
                // SHIFT LEFT: Move every bit one position to the left.
                // A zero enters the least significant bit (LSB).
                data_output <= data_output << 1;
            end

            2'b11: begin
                // PARALLEL LOAD: Store all input bits simultaneously.
                data_output <= data_input;
            end

            default: begin
                // For completeness, retain the current register contents.
                data_output <= data_output;
            end

        endcase
    end

endmodule