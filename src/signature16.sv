
`timescale 1ns/1ps
module signature16 (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        enable,
    input  logic        data_in,
    output logic [15:0] signature
);

    // Polynomial: x^16 + x^5 + x^3 + x^2 + 1
    localparam logic [15:0] POLY = 16'h002D;

    logic feedback;

    assign feedback = signature[15] ^ data_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            signature <= 16'h0000;
        else if (enable)
            signature <= {signature[14:0], 1'b0}
                         ^ (feedback ? POLY : 16'h0000);
    end

endmodule
