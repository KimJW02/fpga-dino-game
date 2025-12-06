`timescale 1ns / 1ps
module score_counter #(
    parameter BASE_INC    = 10,        // per tick
    parameter DEBUF_SCORE = 300,       // 감점 점수
    parameter MAX_SCORE   = 32'd99999999 // 8-digit limit for BCD display
)(
    input  wire        clk_game,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        hit_debuff,
    output reg [31:0]  score_out
);
    reg [31:0] next_score;
    always @(posedge clk_game or negedge rst_n) begin
        if (!rst_n) begin
            score_out <= 32'd0;
        end else begin
            next_score = score_out;

            if (enable) begin
                if (next_score + BASE_INC > MAX_SCORE) next_score = MAX_SCORE;
                else next_score = next_score + BASE_INC;
            end

            if (hit_debuff) begin
                if (next_score <= DEBUF_SCORE) next_score = 32'd0;
                else next_score = next_score - DEBUF_SCORE;
            end
            
            score_out <= next_score;
        end
    end
endmodule