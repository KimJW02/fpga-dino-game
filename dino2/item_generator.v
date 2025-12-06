module item_generator #(
    parameter integer ITEM_SHIFT_DIV = 5
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tick,
    input  wire [15:0] lfsr,
    input  wire [15:0] obs_mask,
    input  wire [31:0] score_in,
    input  wire [15:0] life_interval,  // in shift steps
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

    localparam integer IDW = (ITEM_SHIFT_DIV <= 1) ? 1 : $clog2(ITEM_SHIFT_DIV);
    reg [IDW-1:0] item_shift_div_cnt;

    wire item_shift_pulse = tick && (ITEM_SHIFT_DIV <= 1 || item_shift_div_cnt == ITEM_SHIFT_DIV-1);

    reg [15:0] n_life_top, n_life_bot, n_debuff_top, n_debuff_bot;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            life_top           <= 16'd0;
            life_bot           <= 16'd0;
            debuff_top         <= 16'd0;
            debuff_bot         <= 16'd0;
            spawn_life         <= 1'b0;
            spawn_debuff       <= 1'b0;
            timer              <= 16'd0;
            item_shift_div_cnt <= {IDW{1'b0}};
        end else begin
            spawn_life   <= 1'b0;
            spawn_debuff <= 1'b0;

            if (tick) begin
                // divider
                if (ITEM_SHIFT_DIV <= 1) begin
                    item_shift_div_cnt <= {IDW{1'b0}};
                end else if (item_shift_div_cnt == ITEM_SHIFT_DIV-1) begin
                    item_shift_div_cnt <= {IDW{1'b0}};
                end else begin
                    item_shift_div_cnt <= item_shift_div_cnt + 1'b1;
                end

                if (item_shift_pulse) begin
                    // 1칸 쉬프트
                    n_life_top   = {life_top[14:0], 1'b0};
                    n_life_bot   = {life_bot[14:0], 1'b0};
                    n_debuff_top = {debuff_top[14:0], 1'b0};
                    n_debuff_bot = {debuff_bot[14:0], 1'b0};

                    // 스폰 타이머도 "칸 이동 단위"로 증가
                    if (timer < life_interval) begin
                        timer <= timer + 1'b1;
                    end else begin
                        timer <= 16'd0;

                        if (lfsr[15:8] < life_th && !obs_mask[0]) begin
                            if (lfsr[7]) n_life_top[0] = 1'b1;
                            else         n_life_bot[0] = 1'b1;
                            spawn_life <= 1'b1;
                        end

                        if (score_in >= 32'd50 && lfsr[6:0] < debuff_th && !obs_mask[0]) begin
                            if (lfsr[0]) n_debuff_top[0] = 1'b1;
                            else         n_debuff_bot[0] = 1'b1;
                            spawn_debuff <= 1'b1;
                        end
                    end

                    life_top   <= n_life_top;
                    life_bot   <= n_life_bot;
                    debuff_top <= n_debuff_top;
                    debuff_bot <= n_debuff_bot;
                end
            end
        end
    end
endmodule
