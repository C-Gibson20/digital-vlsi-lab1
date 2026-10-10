
`timescale 1ns/1ps

module signature16_tb;

    logic clk;
    logic rst_n;
    logic enable;
    logic data_in;
    wire [15:0] signature;

    // Instantiate the DUT
    signature16 dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .data_in(data_in),
        .signature(signature)
    );

    // Clock: 1 ns period (1 GHz)
    initial clk = 1'b0;
    always #0.5 clk = ~clk;

    // Expected signature
    logic [15:0] expected;
    logic feedback;
    logic next_bit;

    initial begin
        $display("Start signature16 testbench ....");

        rst_n = 0;
        enable = 0;
        data_in = 0;
        expected = 0;

        #2;
        @(negedge clk);
        rst_n = 1;
        enable = 1;

        // Apply 64 test bits
        for (int i = 0; i < 64; i++) begin
            @(negedge clk);

            // Deterministic input sequence
            next_bit = ((i * 7 + 3) % 11) < 5;
            data_in = next_bit;

            // Calculate expected signature
            feedback = expected[15] ^ next_bit;
            expected = {expected[14:0], 1'b0}
                     ^ (feedback ? 16'h002D : 16'h0000);

            @(posedge clk);
            #0.2;  // Allow propagation delay

            if (signature !== expected) begin
                $display("FAIL at bit %0d", i);
                $display("Expected: %h, Got: %h",
                         expected, signature);
                $fatal(1, "Signature mismatch");
            end
        end

        $display("PASS: Final signature = %h", signature);
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, signature16_tb);
    end

endmodule
