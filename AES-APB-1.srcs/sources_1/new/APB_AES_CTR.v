`timescale 1ns/1ps
`define DATAWIDTH 32
`define ADDRWIDTH 8

module APB_AES_CTR #(
    parameter N = 128, Nr = 10, Nk = 4
)(
    input PCLK,
    input PRESETn,
    input [`ADDRWIDTH-1:0] PADDR,
    input PWRITE,
    input PSEL,
    input PENABLE,
    input [`DATAWIDTH-1:0] PWDATA,
    output reg [`DATAWIDTH-1:0] PRDATA,
    output reg PREADY
);

    // Internal registers
    reg [127:0] plaintext_reg;
    reg [127:0] nonce_counter_reg;
    reg [127:0] key_reg;
    reg start_reg;

    wire done_wire;
    wire [127:0] ciphertext_wire;

    reg [`ADDRWIDTH-1:0] setup_addr;
    reg [`DATAWIDTH-1:0] setup_data;
    reg setup_write;

    reg [1:0] state;
    localparam IDLE = 2'd0, WRITE = 2'd1, READ = 2'd2;

    // AES CTR core
    AES_CTR_Mode #(.N(N), .Nr(Nr), .Nk(Nk)) aes_ctr_core (
        .clk(PCLK),
        .rst(~PRESETn),
        .start(start_reg),
        .plaintext(plaintext_reg),
        .key(key_reg),
        .nonce_counter(nonce_counter_reg),
        .ciphertext(ciphertext_wire),
        .done(done_wire)
    );

    // APB FSM
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PRDATA <= 0;
            PREADY <= 0;
            start_reg <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    PREADY <= 0;
                    PRDATA <= 0;
                    if (PSEL && !PENABLE) begin
                        setup_addr <= PADDR;
                        setup_data <= PWDATA;
                        setup_write <= PWRITE;
                        state <= (PWRITE ? WRITE : READ);
                    end
                end

                WRITE: begin
                    if (PSEL && PENABLE) begin
                        case (setup_addr)
                            8'h00: start_reg <= setup_data[0]; // trigger
                            // Plaintext
                            8'h04: plaintext_reg[127:96] <= setup_data;
                            8'h08: plaintext_reg[95:64]  <= setup_data;
                            8'h0C: plaintext_reg[63:32]  <= setup_data;
                            8'h10: plaintext_reg[31:0]   <= setup_data;
                            // Nonce + Counter
                            8'h14: nonce_counter_reg[127:96] <= setup_data;
                            8'h18: nonce_counter_reg[95:64]  <= setup_data;
                            8'h1C: nonce_counter_reg[63:32]  <= setup_data;
                            8'h20: nonce_counter_reg[31:0]   <= setup_data;
                            // AES Key
                            8'h24: key_reg[127:96] <= setup_data;
                            8'h28: key_reg[95:64]  <= setup_data;
                            8'h2C: key_reg[63:32]  <= setup_data;
                            8'h30: key_reg[31:0]   <= setup_data;
                        endcase
                        PREADY <= 1;
                        state <= IDLE;
                    end
                end

                READ: begin
                    if (PSEL && PENABLE) begin
                        case (setup_addr)
                            8'h00: PRDATA <= {31'd0, done_wire}; // status
                            8'h34: PRDATA <= ciphertext_wire[127:96];
                            8'h38: PRDATA <= ciphertext_wire[95:64];
                            8'h3C: PRDATA <= ciphertext_wire[63:32];
                            8'h40: PRDATA <= ciphertext_wire[31:0];
                            default: PRDATA <= 32'hDEADDEAD;
                        endcase
                        PREADY <= 1;
                        state <= IDLE;
                    end
                end
            endcase

            // Clear start once encryption is done
            if (done_wire)
                start_reg <= 0;
        end
    end

endmodule
