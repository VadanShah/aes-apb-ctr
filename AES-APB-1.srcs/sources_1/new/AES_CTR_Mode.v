module AES_CTR_Mode #(parameter N=128, parameter Nr=10, parameter Nk=4)(
    input clk,
    input rst,
    input start,                             // Trigger signal
    input [127:0] plaintext,                 // 128-bit input block
    input [N-1:0] key,                       // AES key (128/192/256 bits)
    input [127:0] nonce_counter,            // Initial nonce || counter value
    output reg [127:0] ciphertext,          // Output ciphertext
    output reg done                         // High when encryption is done
);

    // Internal signals
    wire [127:0] aes_out;
    reg [127:0] input_block;
    reg trigger;
    
    // State
    reg [1:0] state;
    localparam IDLE = 2'd0,
               LOAD = 2'd1,
               WAIT = 2'd2,
               DONE = 2'd3;

    // Instantiate your AES_Encrypt module
    AES_Encrypt #(.N(N), .Nr(Nr), .Nk(Nk)) aes_core (
        .in(input_block),
        .key(key),
        .out(aes_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            ciphertext <= 0;
            done <= 0;
            input_block <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        input_block <= nonce_counter;  // Nonce + Counter block
                        state <= LOAD;
                    end
                end

                LOAD: begin
                    state <= WAIT;
                end

                WAIT: begin
                    // Assume AES takes 1 cycle after LOAD; adjust for real latency
                    ciphertext <= plaintext ^ aes_out;
                    state <= DONE;
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
