module item_generator(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tick,
    input  wire [15:0] lfsr,
    input  wire [15:0] obs_mask,
    input  wire [15:0] score_in,
    input  wire [15:0] life_interval,
    input  wire [7:0]  life_th,
    input  wire [7:0]  debuff_th,
    output reg  [15:0] life_top,
    output reg  [15:0] life_bot,
    output reg  [15:0] debuff_top,
    output reg  [15:0] debuff_bot,
    output reg         spawn_life,
    output reg         spawn_debuff
);
    reg [15:0] timer;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            life_top <= 0; life_bot <= 0; debuff_top <= 0; debuff_bot <= 0;
            spawn_life <= 0; spawn_debuff <= 0; timer <= 0;
        end else begin
            spawn_life <= 0; spawn_debuff <= 0;
            if (tick) begin
                // 이동 시 비트 이동
                life_top <= {life_top[14:0], 1'b0};
                life_bot <= {life_bot[14:0], 1'b0};
                debuff_top <= {debuff_top[14:0], 1'b0};
                debuff_bot <= {debuff_bot[14:0], 1'b0};
                if (timer < life_interval) begin
                    timer <= timer + 1;
                end else begin
                    timer <= 0;
                    if (lfsr[15:8] < life_th && !obs_mask[0]) begin
                        if (lfsr[7]) life_top[0] <= 1'b1;
                        else         life_bot[0] <= 1'b1;
                        spawn_life <= 1;
                    end
                    if (score_in >= 32'd50 && lfsr[6:0] < debuff_th && !obs_mask[0]) begin
                        if (lfsr[0]) debuff_top[0] <= 1'b1;
                        else         debuff_bot[0] <= 1'b1;
                        spawn_debuff <= 1;
                    end
                end
            end
        end
    end
endmodule
