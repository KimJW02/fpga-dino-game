`timescale 1ns / 1ps
module score_counter (
    input  wire        clk_game,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        hit_debuff,
    output reg [31:0]  score_out
);
    parameter BASE_INC    = 1;        // per tick
    parameter DEBUF_SCORE = 30;       // 감점 점수
    parameter MAX_SCORE   = 32'd99999999; // 8-digit limit for BCD display
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

            // 최종 반영
            score_out <= next_score;
        end
    end
endmodule