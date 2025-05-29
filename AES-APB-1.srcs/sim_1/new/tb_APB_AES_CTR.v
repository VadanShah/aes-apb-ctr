//`timescale 1ns / 1ps

//module tb_APB_AES_CTR;

//    reg PCLK;
//    reg PRESETn;
//    reg [7:0] PADDR;
//    reg PWRITE;
//    reg PSEL;
//    reg PENABLE;
//    reg [31:0] PWDATA;
//    wire [31:0] PRDATA;
//    wire PREADY;

//    reg [31:0] status;
//    reg [31:0] c0, c1, c2, c3;
//    integer i;
//    reg done_flag;

//    // Instantiate the DUT
//    APB_AES_CTR dut (
//        .PCLK(PCLK),
//        .PRESETn(PRESETn),
//        .PADDR(PADDR),
//        .PWRITE(PWRITE),
//        .PSEL(PSEL),
//        .PENABLE(PENABLE),
//        .PWDATA(PWDATA),
//        .PRDATA(PRDATA),
//        .PREADY(PREADY)
//    );

//    // Clock generation
//    initial begin
//        PCLK = 0;
//        forever #5 PCLK = ~PCLK;
//    end

//    // APB write task
//    task apb_write;
//        input [7:0] addr;
//        input [31:0] data;
//        begin
//            @(posedge PCLK);
//            PADDR   = addr;
//            PWDATA  = data;
//            PWRITE  = 1;
//            PSEL    = 1;
//            PENABLE = 0;

//            @(posedge PCLK);
//            PENABLE = 1;

//            wait (PREADY);
//            @(posedge PCLK);

//            PSEL    = 0;
//            PENABLE = 0;
//            PWRITE  = 0;
//        end
//    endtask

//    // APB read task
//    task apb_read;
//        input [7:0] addr;
//        output [31:0] data_out;
//        begin
//            @(posedge PCLK);
//            PADDR   = addr;
//            PWRITE  = 0;
//            PSEL    = 1;
//            PENABLE = 0;

//            @(posedge PCLK);
//            PENABLE = 1;

//            wait (PREADY);
//            data_out = PRDATA;

//            @(posedge PCLK);
//            PSEL    = 0;
//            PENABLE = 0;
//        end
//    endtask

//    // Test Sequence
//    initial begin
//        PRESETn = 0;
//        PADDR = 0;
//        PWRITE = 0;
//        PSEL = 0;
//        PENABLE = 0;
//        PWDATA = 0;
//        done_flag = 0;

//        #20;
//        PRESETn = 1;

//        // Input Data (128-bit plaintext)
//        apb_write(8'h04, 32'h00112233);
//        apb_write(8'h08, 32'h44556677);
//        apb_write(8'h0C, 32'h8899aabb);
//        apb_write(8'h10, 32'hccddeeff);

//        // Nonce + Counter (128-bit)
//        apb_write(8'h14, 32'h00010203);
//        apb_write(8'h18, 32'h04050607);
//        apb_write(8'h1C, 32'h08090a0b);
//        apb_write(8'h20, 32'h0c0d0e0f);

//        // Key (128-bit AES)
//        apb_write(8'h24, 32'h2b7e1516);
//        apb_write(8'h28, 32'h28aed2a6);
//        apb_write(8'h2C, 32'habf71588);
//        apb_write(8'h30, 32'h09cf4f3c);

//        // Start encryption
//        apb_write(8'h00, 32'h1);

//        // Poll for done flag
//        i = 0;
//        while (i < 20 && done_flag == 0) begin
//            apb_read(8'h00, status);
//            if (status[0] == 1'b1) begin
//                done_flag = 1;
//            end
//            #10;
//            i = i + 1;
//        end

//        // Read ciphertext
//        apb_read(8'h34, c0);
//        apb_read(8'h38, c1);
//        apb_read(8'h3C, c2);
//        apb_read(8'h40, c3);

//        $display("Ciphertext:");
//        $display("%h %h %h %h", c0, c1, c2, c3);

//        $finish;
//    end

//endmodule

`timescale 1ns / 1ps

module tb_APB_AES_CTR;

    reg PCLK;
    reg PRESETn;
    reg [7:0] PADDR;
    reg PWRITE;
    reg PSEL;
    reg PENABLE;
    reg [31:0] PWDATA;
    wire [31:0] PRDATA;
    wire PREADY;

    reg [31:0] status;
    integer i;
    reg done_flag;
  reg [31:0] c0, c1, c2, c3;
    // Instantiate the DUT
    APB_AES_CTR dut (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY)
    );

    // Clock generation
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end

    // APB write task
    task apb_write;
        input [7:0] addr;
        input [31:0] data;
        begin
            @(posedge PCLK);
            PADDR   = addr;
            PWDATA  = data;
            PWRITE  = 1;
            PSEL    = 1;
            PENABLE = 0;

            @(posedge PCLK);
            PENABLE = 1;

            wait (PREADY);
            @(posedge PCLK);

            PSEL    = 0;
            PENABLE = 0;
            PWRITE  = 0;
        end
    endtask

    // APB read task
    task apb_read;
        input [7:0] addr;
        output [31:0] data_out;
        begin
            @(posedge PCLK);
            PADDR   = addr;
            PWRITE  = 0;
            PSEL    = 1;
            PENABLE = 0;

            @(posedge PCLK);
            PENABLE = 1;

            wait (PREADY);
            data_out = PRDATA;

            @(posedge PCLK);
            PSEL    = 0;
            PENABLE = 0;
        end
    endtask

    // Test process
    initial begin
        // Reset and initialize
        PRESETn = 0;
        PADDR = 0;
        PWRITE = 0;
        PSEL = 0;
        PENABLE = 0;
        PWDATA = 0;
        done_flag = 0;

        #20;
        PRESETn = 1;

        // Plaintext (128-bit)
        apb_write(8'h04, 32'h6bc1bee2);
        apb_write(8'h08, 32'h2e409f96);
        apb_write(8'h0C, 32'he93d7e11);
        apb_write(8'h10, 32'h7393172a);

        // Nonce + Counter (128-bit)
        apb_write(8'h14, 32'hf0f1f2f3);
        apb_write(8'h18, 32'hf4f5f6f7);
        apb_write(8'h1C, 32'hf8f9fafb);
        apb_write(8'h20, 32'hfcfdfeff);

        // AES-128 Key
        apb_write(8'h24, 32'h2b7e1516);
        apb_write(8'h28, 32'h28aed2a6);
        apb_write(8'h2C, 32'habf71588);
        apb_write(8'h30, 32'h09cf4f3c);

        // Start encryption
        apb_write(8'h00, 32'h1);

        // Wait for done flag
        i = 0;
        while (i < 20 && !done_flag) begin
            apb_read(8'h00, status);
            if (status[0]) begin
                done_flag = 1;
            end
            #10;
            i = i + 1;
        end

        // Read ciphertext
      
        apb_read(8'h34, c0);
        apb_read(8'h38, c1);
        apb_read(8'h3C, c2);
        apb_read(8'h40, c3);

        $display("Ciphertext:");
        $display("%h %h %h %h", c0, c1, c2, c3);
        $display("Expected : 874d6191 b620e326 1bef6864 990db6ce");

        $finish;
    end

endmodule
