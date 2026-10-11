
`timescale 1ns / 1ps

//==============================================================
// Project      : 4-Bit Universal Shift Register
// Description  : Hold, Shift Right, Shift Left, Parallel Load
// Target FPGA  : Xilinx Artix-7
// Tool         : Xilinx Vivado
// Date         : 11 October 2026
//==============================================================

module universal_shift_register (
    input  wire       clk,          // Clock input
    input  wire [1:0] sel,          // Operation selector
    input  wire [3:0] data_input,   // Parallel data input
    output reg  [3:0] data_output   // Registered output
);

    // All operations occur on the rising edge of the clock.
    always @(posedge clk) begin
        case (sel)

            2'b00: begin
                // Hold: retain the current register value
                data_output <= data_output;
            end

            2'b01: begin
                // Shift right: insert 0 at the MSB
                data_output <= {1'b0, data_output[3:1]};
            end

            2'b10: begin
                // Shift left: insert 0 at the LSB
                data_output <= {data_output[2:0], 1'b0};
            end

            2'b11: begin
                // Parallel load: load all four input bits
                data_output <= data_input;
            end

            default: begin
                // No action for unknown simulation values
                data_output <= data_output;
            end

        endcase
    end

endmodule
