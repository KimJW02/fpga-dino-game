`timescale 1ns / 1ps
module lfsr16 (
    input  wire clk,
    input  wire rst_n,
    input  wire [3:0] user_src, 
    output reg [15:0] q
);
    wire feedback = q[15] ^ q[13] ^ q[12] ^ q[11];
    
    reg [15:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 16'hA5A5;
            cnt <= 16'd0;
        end else begin
            if (cnt == 16'hFFFF || user_src != 4'b0000) cnt <= 16'd0;
            else cnt <= cnt + 16'd1;
            q <= {q[14:0], feedback} ^ cnt[3:0] ^ user_src;
        end
    end
endmodule
