`timescale 1ns/1ps

module sequence_detector_mealy (
    input logic clk,
    input logic reset_n,
    input logic data_serial,
    input logic data_valid,
    output logic data_out
    );

    // Define an enumeration type for the states
    typedef enum {s_init, s_0, s_01, s_010} state_type;

    // Define the needed internal signals
    state_type state_current, state_next;

    // For output signal
    logic detected;

    // Type: sequential
    // Purpose: Implement the registers for the sequence decoder
    always_ff @(posedge clk or negedge reset_n) begin : registers
        if (!reset_n) begin
            state_current <= s_init;
        end else begin
            state_current <= state_next;
        end
    end

    // Type: combinational
    // Purpose: Implement the state_next logic, as well as the output logic
    always_comb begin : combinational
        // default values
        state_next = state_current;
        detected = 0;

        case (state_current)
            s_init : begin // S0
                if (data_serial == 1) begin
                    // is this line necessary? => not, bcuz we put default values alr. put here for safety and readability
                    state_next = s_init;
                end else begin
                    state_next = s_0;
                end
            end

            s_0 : begin // S1
                if (data_serial == 0) begin
                    state_next = s_0;
                end else begin
                    state_next = s_01;
                end
            end
            
            s_01 : begin // S2
                if (data_serial == 0) begin
                    state_next = s_010;
                end else begin
                    state_next = s_init;
                end
            end

            s_010 : begin // S3
                if (data_serial == 0) begin
                    detected = 1; // catch the correct sequence, jumping to next state of overlapping
                    state_next = s_0;
                end else begin
                    state_next = s_01;
                end
            end

            default : state_next = s_init; // default case
        endcase
    end

    // Assign output signal
    assign data_out = detected;

endmodule
