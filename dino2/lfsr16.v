`timescale 1ns / 1ps
module lfsr16 (
    input  wire clk,
    input  wire rst_n,
    output reg [15:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) q <= 16'hA5A5;
        else begin
            q <= {q[14:0], q[15] ^ q[14]}; // simple x^16 + x^15 tap
        end
    end
endmodule
