`timescale 1ns / 1ps


module testbench_top();

    localparam string INPUT_FILE = "stimuli.txt";

    typedef enum {INIT, SHIFT, WAIT, WAIT2, FINISH} state_t;
    
    localparam int NUM_KEYS = 12;
    
    state_t state;
    
    logic [7:0] memory [0:NUM_KEYS-1]; // 8 bit memory with 16 entries
    integer memory_index = 0;
    
    logic clk = 0;
    logic rst = 1;
    
    logic clk_slow = 0;
    logic clk_keyboard = 1;
    logic data_keyboard = 0;
    
    logic [7:0] scan_code_debug;
    logic [7:0] seven_segment_number;
    logic [7:0] seven_segment_enable;
       
    logic [31:0] key_all;
    logic start_shifting = 0;
    integer bit_index = 0;
    
    
    keyboard_top inst_keyboard_top(
        .clk(clk),
        .rst(rst),
        .kb_data(data_keyboard),
        .kb_clk(clk_keyboard),
        .sc(scan_code_debug),
        .num(seven_segment_number),
        .seg_en(seven_segment_enable[3:0])
    );
    
    
    always #10 clk = ~clk;              
    always #1000 clk_slow = ~clk_slow;   
       
    
    initial begin
        $readmemh(INPUT_FILE, memory);
        
        rst = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        rst = 0;        
    end


    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            data_keyboard <= 0;
            key_all <= 0;
            memory_index <= 0; 
            start_shifting <= 0;
            bit_index <= 0; 
            clk_keyboard <= 1;  
            state <= INIT;        
        end else begin
            case (state)
                INIT:
                begin
                    key_all <= {2'b11, memory[memory_index], 1'b0, 2'b11, 8'hf0, 1'b0, 2'b11, memory[memory_index], 1'b0};
                    memory_index <= memory_index + 1;
                    state <= SHIFT;
                    bit_index <= 0;                    
                end
                
                SHIFT:
                begin
                    data_keyboard <= key_all[bit_index];
                    bit_index <= bit_index + 1;
                    state <= WAIT;
                end 
                
                WAIT:
                begin
                    if (!clk_slow) begin
                        clk_keyboard <= 0;
                        state <= WAIT2;
                    end
                end   

                WAIT2:
                begin
                    if (clk_slow) begin
                        clk_keyboard <= 1;
                        state <= SHIFT;
                        if (bit_index == 32) begin     
                            state <= INIT;
                            if (memory_index == NUM_KEYS) begin
                                state <= FINISH;   
                            end
                        end                                                    
                    end
                end 
                
                FINISH:
                begin
                    $display("Finished!");
                    $finish;
                end                                           
            endcase
        end
    end
   
    
    always @(posedge clk_keyboard)
    begin
        if (bit_index == 12 & scan_code_debug != memory[memory_index-1]) begin
            $display("Failure!");
            $display("DUT Scan code = %x is not equal to expected = %x!", scan_code_debug, memory[memory_index-1]);
            $stop; 
        end
    end
    
endmodule
