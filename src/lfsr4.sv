module lfsr4 (
    // simple 4-bit linear feedback shift register.
    // primitive polynomial is x^4 + x^3 + 1
    // Author: Peter YK Cheung
    // Version: 1.0, 17-9-25

	input logic         clk,        // clock
    input logic         rst,        // reset
	output logic [3:0]  data_out    // pseudo-random output
);

logic [4:1]     sreg;

always_ff @ (posedge clk, posedge rst)
    if (rst)
        sreg <= 4'b1;
    else 
	sreg <= {sreg[3:1], sreg[3] ^ sreg[4]};

assign data_out = sreg;
endmodule 
