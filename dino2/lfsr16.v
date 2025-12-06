`timescale 1ns / 1ps
module lfsr16 (
    input  wire clk,
    input  wire rst_n,
    output reg [15:0] q
);
    wire feedback = q[15] ^ q[13] ^ q[12] ^ q[11];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 16'hA5A5;
        else begin
            q <= {q[14:0], feedback};
        end
    end
endmodule
