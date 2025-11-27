`timescale 1ns / 1ps

module score_counter (
    input  wire        clk_game,      // game tick clock
    input  wire        rst_n,         // active-low reset
    input  wire        enable,        // only count when PLAY
    input  wire        hit_debuff,    // one-tick pulse when debuff item collected
    input  wire        hit_bonus,     // one-tick pulse when bonus item collected
    output reg  [31:0] score_out
);
    always @(posedge clk_game or negedge rst_n) begin
        if (!rst_n) begin
            score_out <= 32'd0;
        end else begin
            if (!enable) begin
                // hold score when not enabled; not resetting here
                score_out <= score_out;
            end else begin
                // base increment per tick
                score_out <= score_out + 32'd1;
                // apply bonus (additional +10)
                if (hit_bonus) score_out <= score_out + 32'd10;
                // apply debuff (subtract 300 safe-guard)
                if (hit_debuff) begin
                    if (score_out >= 32'd300) score_out <= score_out - 32'd300;
                    else score_out <= 32'd0;
                end
            end
        end
    end
endmodule
