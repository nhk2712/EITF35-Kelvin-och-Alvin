`timescale 1ns/1ps

import alu_common::*;

module alu_ctrl (
    input logic clk,
    input logic rst,
    input logic enter,
    input logic sign,
    output alu_op_t fn,
    output logic [1:0] reg_ctrl
    );

    alu_op_t current_state, next_state;.

    always_ff @(posedge clk or posedge rst) begin 
        if (rst) begin
            current_state <= INPUT_A;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin : comb
        next_state = current_state;
        reg_ctrl = 2'b00;

        case (current_state)
            INPUT_A: begin
                reg_ctrl = 2'b01;
                if (enter) begin
                    next_state = INPUT_B;
                end 
            end
            LATCH_B: begin
                reg_ctrl = 2'b10;
                if (enter) begin
                    next_state = U_ADD;
                end 
            end
            U_ADD: begin
                if (enter) begin
                    next_state = U_SUB;
                end else begin
                    if (sign) begin
                        next_state = S_ADD;
                    end else begin
                        next_state = U_ADD;
                    end
                end
            end
            U_SUB: begin
                if (enter) begin
                    next_state = U_MOD3;
                end else begin
                    if (sign) begin
                        next_state = S_SUB;
                    end else begin
                        next_state = U_SUB;
                    end
                end

            end
            U_MOD3: begin
                if (enter) begin
                    next_state = U_ADD;
                end else begin
                    if (sign) begin
                        next_state = S_MOD3;
                    end else begin
                        next_state = U_MOD3
                    end
                end
            end
            S_ADD: begin
                if (enter) begin
                    next_state = S_SUB;
                end else begin
                    if (sign) begin
                        next_state = U_ADD;
                    end else begin
                        next_state = S_ADD;
                    end
                end
            end
            S_SUB: begin
                if (enter) begin
                    next_state = S_MOD3;
                end else begin
                    if (sign) begin
                        next_state = U_SUB;
                    end else begin
                        next_state = S_SUB;
                    end
                end

            end
            S_MOD3: begin
                if (enter) begin
                    next_state = S_ADD;
                end else begin
                    if (sign) begin
                        next_state = U_MOD3
                    end else begin
                        next_state = S_MOD3;
                    end
                end
            end
            default: begin
                
            end 
        endcase
    end

    assign fn = current_state;
    
    

endmodule
