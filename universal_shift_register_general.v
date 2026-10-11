
//==============================================================
// Project     : 4-Bit Universal Shift Register
// Module      : universal_shift_register
// Date        : 11 October 2026
// Description : Performs four operations on 4-bit data.
//
// Purpose:
//   1. Hold the current register value.
//   2. Shift data one bit to the right.
//   3. Shift data one bit to the left.
//   4. Load four input bits simultaneously.
//
// Target      : Xilinx Artix-7 FPGA
// Tool        : Xilinx Vivado
//==============================================================

`timescale 1ns / 1ps

module universal_shift_register (

    input  wire       clk,          // Clock input
    input  wire [1:0] sel,          // Operation selection
    input  wire [3:0] data_input,   // Parallel data input
    output reg  [3:0] data_output   // Stored 4-bit data

);

    //==========================================================
    // Operation Selection
    //==========================================================
    // The selected operation is performed on the rising edge
    // of the clock.
    //
    // sel = 00 : Hold the current data
    // sel = 01 : Shift right, insert 0 at the MSB
    // sel = 10 : Shift left, insert 0 at the LSB
    // sel = 11 : Parallel load data_input
    //==========================================================

    always @(posedge clk) begin

        case (sel)

            2'b00: begin
                // HOLD:
                // Keep the previously stored data unchanged.
                data_output <= data_output;
            end

            2'b01: begin
                // SHIFT RIGHT:
                // Move each bit one position to the right.
                // Insert 0 into the most significant bit.
                data_output <= {1'b0, data_output[3:1]};
            end

            2'b10: begin
                // SHIFT LEFT:
                // Move each bit one position to the left.
                // Insert 0 into the least significant bit.
                data_output <= {data_output[2:0], 1'b0};
            end

            2'b11: begin
                // PARALLEL LOAD:
                // Load all four input bits into the register.
                data_output <= data_input;
            end

            default: begin
                // Retain the current value for unknown selector
                // values during simulation.
                data_output <= data_output;
            end

        endcase

    end

endmodule
