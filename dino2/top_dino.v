`timescale 1ns / 1ps
module top_dino (
    input  wire clk_50m,
    input  wire rst_n,

    // Mode switches
    input  wire sw1_easy,
    input  wire sw2_normal,
    input  wire sw3_hard,

    // Jump button
    input  wire btn_jump,

    // 7-segment segment
    output wire AR_SEG_A,
    output wire AR_SEG_B,
    output wire AR_SEG_C,
    output wire AR_SEG_D,
    output wire AR_SEG_E,
    output wire AR_SEG_F,
    output wire AR_SEG_G,
    output wire AR_SEG_DP,

    // 7-segment digit select
    output wire AR_SEG_S0,
    output wire AR_SEG_S1,
    output wire AR_SEG_S2,
    output wire AR_SEG_S3,
    output wire AR_SEG_S4,
    output wire AR_SEG_S5,
    output wire AR_SEG_S6,
    output wire AR_SEG_S7,

    // LCD (8-bit mode)
    output wire [7:0] TLCD_D,
    output wire       TLCD_RS,
    output wire       TLCD_RW,
    output wire       TLCD_E,

    // Life LEDs
    output wire LED_D1,
    output wire LED_D2,
    output wire LED_D3,
    output wire LED_D4,
    output wire LED_D5,
    output wire LED_D6,
    output wire LED_D7,
    output wire LED_D8
);
    wire rst_core_n = ~rst_n;

    reg clk_main;
    reg [5:0] div_main_cnt;
    always @(posedge clk_50m or negedge rst_core_n) begin
        if (!rst_core_n) begin
            div_main_cnt <= 6'd0;
            clk_main     <= 1'b0;
        end else begin
            if (div_main_cnt == 6'd24) begin
                div_main_cnt <= 6'd0;
                clk_main <= ~clk_main;  // 50MHz / (2*25) = 1MHz
            end else begin
                div_main_cnt <= div_main_cnt + 1'b1;
            end
        end
    end

    // ---------------------------
    // lcd clock (~1 MHz) and 7-seg scan (~1 kHz), derived from clk_main (5 MHz)
    // We'll produce single-cycle pulses (posedge events) at approx. desired rates
    // ---------------------------

    // lcd_clk pulse: 5MHz / 5 = 1 MHz -> produce one-cycle pulse every 5 clk_main cycles
    reg [2:0] lcd_div_cnt;
    reg lcd_clk_pulse;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            lcd_div_cnt <= 3'd0;
            lcd_clk_pulse <= 1'b0;
        end else begin
            if (lcd_div_cnt == 3'd4) begin
                lcd_div_cnt <= 3'd0;
                lcd_clk_pulse <= 1'b1;
            end else begin
                lcd_div_cnt <= lcd_div_cnt + 1'b1;
                lcd_clk_pulse <= 1'b0;
            end
        end
    end

    // 7-seg scan clock: 5MHz / 5000 = 1 kHz -> produce 1-cycle pulse every 5000 clk_main cycles
    reg [15:0] scan_div_cnt;
    reg scan_clk_pulse;
    localparam SCAN_DIV = 16'd5000;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            scan_div_cnt <= 16'd0;
            scan_clk_pulse <= 1'b0;
        end else begin
            if (scan_div_cnt >= SCAN_DIV-1) begin
                scan_div_cnt <= 16'd0;
                scan_clk_pulse <= 1'b1;
            end else begin
                scan_div_cnt <= scan_div_cnt + 1'b1;
                scan_clk_pulse <= 1'b0;
            end
        end
    end


    localparam integer MOVE_HZ = 400; // change if you want faster/slower movement
    localparam integer MOVE_DIV = 5000000 / MOVE_HZ;
    localparam MOVE_DIV_W = $clog2(MOVE_DIV+1);
    reg [MOVE_DIV_W-1:0] move_div_cnt;
    reg move_tick; // single-cycle pulse on clk_main domain
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            move_div_cnt <= {MOVE_DIV_W{1'b0}};
            move_tick <= 1'b0;
        end else begin
            if (move_div_cnt >= MOVE_DIV-1) begin
                move_div_cnt <= {MOVE_DIV_W{1'b0}};
                move_tick <= 1'b1;
            end else begin
                move_div_cnt <= move_div_cnt + 1'b1;
                move_tick <= 1'b0;
            end
        end
    end


    // Buttons: debounce & request latch in clk_main domain

    reg btn_ff1, btn_ff2;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            btn_ff1 <= 1'b0;
            btn_ff2 <= 1'b0;
        end else begin
            // simple two-flop synchronizer (assumes btn_jump is already debounced or slow)
            btn_ff1 <= btn_jump;
            btn_ff2 <= btn_ff1;
        end
    end
    wire btn_stable = btn_ff2;

    // jump request: set on button rising
    reg jump_req;
    reg btn_prev_main;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            btn_prev_main <= 1'b0;
            jump_req <= 1'b0;
        end else begin
            btn_prev_main <= btn_stable;
            if (btn_stable && !btn_prev_main) // rising edge detected on clk_main domain
                jump_req <= 1'b1;
            else if (move_tick) // clear at next move tick to be consumed by dino FSM
                jump_req <= 1'b0;
        end
    end


    localparam S_HELLO = 3'd0, S_MODE = 3'd1, S_READY = 3'd2, S_PLAY = 3'd3, S_OVER = 3'd4;
    reg [2:0] state, next_state;
    reg [31:0] hello_cnt_main;
    localparam HELLO_CNT_MAX = 32'd250000;
    localparam HELLO_TICKS = 250_000;
    reg [7:0] life_count;

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            state <= S_HELLO;
            hello_cnt_main <= 32'd0;
        end else begin
            state <= next_state;
            if (state == S_HELLO) begin
                if (hello_cnt_main < HELLO_TICKS) hello_cnt_main <= hello_cnt_main + 1'b1;
            end else hello_cnt_main <= 32'd0;
        end
    end

// combinational next_state
    always @(*) begin
        next_state = state;
        case (state)
            S_HELLO: if (hello_cnt_main >= HELLO_TICKS) next_state = S_MODE;
            S_MODE:  if (sw1_easy || sw2_normal || sw3_hard) next_state = S_READY;
            S_READY: if (jump_req) next_state = S_PLAY; // jump_req은 clk_main에서 설정된 신호
            S_PLAY:  begin
                if (life_count == 0) next_state = S_OVER;
            end
            S_OVER:  if (jump_req) next_state = S_HELLO;
            default: next_state = S_HELLO;
        endcase
    end

    // ---------------------------
    // DINO controller: all logic driven by clk_main; updates on move_tick only
    // ---------------------------
    reg dino_row_r;
    reg dino_frame_r;
    reg [3:0] jump_state;
    reg [7:0] dino_anim_cnt;
    reg [7:0] air_cnt;
    localparam DJ_GROUND = 0, DJ_ASCEND = 1, DJ_AIR = 2, DJ_DESCEND = 3;
    wire dino_row = dino_row_r;
    wire dino_frame = dino_frame_r;

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            dino_row_r <= 1'b1;
            dino_frame_r <= 1'b0;
            dino_anim_cnt <= 8'd0;
            air_cnt <= 8'd0;
            jump_state <= DJ_GROUND;
        end else begin
            if (move_tick) begin
                // animation
                dino_anim_cnt <= dino_anim_cnt + 1'b1;
                if (dino_anim_cnt >= 8'd4) begin
                    dino_anim_cnt <= 8'd0;
                    dino_frame_r <= ~dino_frame_r;
                end

                // jump FSM
                case (jump_state)
                    DJ_GROUND: begin
                        dino_row_r <= 1'b1;
                        if (state == S_PLAY && jump_req) begin
                            jump_state <= DJ_ASCEND;
                            air_cnt <= 8'd0;
                        end
                    end
                    DJ_ASCEND: begin
                        dino_row_r <= 1'b0;
                        jump_state <= DJ_AIR;
                        air_cnt <= 8'd0;
                    end
                    DJ_AIR: begin
                        dino_row_r <= 1'b0;
                        air_cnt <= air_cnt + 1'b1;
                        if (air_cnt > 8'd1) jump_state <= DJ_DESCEND;
                    end
                    DJ_DESCEND: begin
                        dino_row_r <= 1'b1;
                        jump_state <= DJ_GROUND;
                    end
                endcase
            end
        end
    end

    // ---------------------------
    // RNG LFSR (clk_main domain)
    // ---------------------------
    wire [15:0] lfsr_q;
    lfsr16 u_lfsr (.clk(clk_main), .rst_n(rst_core_n), .q(lfsr_q));

    // ---------------------------
    // Generators (clocked by clk_main, they act on move_tick)
    // ---------------------------
    wire [7:0] obs_th, life_th, debuff_th;
    wire [2:0] obs_gap;
    wire [15:0] life_interval;
    difficulty_manage u_diff (
        .mode(sw1_easy ? 2'b00 : sw2_normal ? 2'b01 : 2'b10),
        .obs_th(obs_th),
        .obs_gap(obs_gap),
        .life_interval(life_interval),
        .life_th(life_th),
        .debuff_th(debuff_th)
    );
    wire [15:0] obs_top, obs_bot;
    wire spawn_obs;
    obstacle_generator u_obs (
        .clk(clk_main), .rst_n(rst_core_n), .tick(move_tick),
        .gap_min(obs_gap), .th(obs_th),
        .lfsr(lfsr_q), .obs_top(obs_top), .obs_bot(obs_bot),
        .spawn_obstacle(spawn_obs)
    );
    wire [31:0] score_bin;
    wire [31:0] score_bcd;
    wire [15:0] life_top, life_bot, debuff_top, debuff_bot;
    wire spawn_life_w, spawn_debuff_w;
    item_generator u_item (
        .clk(clk_main), .rst_n(rst_core_n), .tick(move_tick),
        .lfsr(lfsr_q), .obs_mask(obs_top|obs_bot), .score_in(score_bin),
        .life_interval(life_interval), .life_th(life_th), .debuff_th(debuff_th),
        .life_top(life_top), .life_bot(life_bot),
        .debuff_top(debuff_top), .debuff_bot(debuff_bot),
        .spawn_life(spawn_life_w), .spawn_debuff(spawn_debuff_w)
    );

    // ---------------------------
    // Collision & life (clk_main, check on move_tick)
    // ---------------------------
    wire hit_obstacle = (dino_row_r == 1 && obs_bot[15]) || (dino_row_r == 0 && obs_top[15]);
    wire hit_life  = (dino_row_r == 0 && life_top[15]) || (dino_row_r == 1 && life_bot[15]);
    wire hit_debuff = (dino_row_r == 0 && debuff_top[15]) || (dino_row_r == 1 && debuff_bot[15]);

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) life_count <= 8'd1;
        else begin
            if (state == S_READY) life_count <= 8'd1;
            if (move_tick && state == S_PLAY) begin
                if (hit_life && life_count < 8) life_count <= life_count + 1;
                if (hit_obstacle && life_count > 0) life_count <= life_count - 1;
                if (hit_debuff && life_count > 0) life_count <= life_count - 1;
            end
        end
    end

    wire [7:0] life_leds;
    life_manager u_life (.life(life_count), .leds_out(life_leds));
    assign LED_D1 = life_leds[0]; assign LED_D2 = life_leds[1];
    assign LED_D3 = life_leds[2]; assign LED_D4 = life_leds[3];
    assign LED_D5 = life_leds[4]; assign LED_D6 = life_leds[5];
    assign LED_D7 = life_leds[6]; assign LED_D8 = life_leds[7];

    // ---------------------------
    // Score counter (clocked by clk_main, enable on move_tick)
    // ---------------------------

    wire bcd_done;
    score_counter u_score (
        .clk_game(clk_main),
        .rst_n(rst_core_n),
        .enable(state == S_PLAY && move_tick),
        .hit_debuff(hit_debuff),
        .hit_bonus(hit_life),
        .score_out(score_bin)
    );

    // Binary -> BCD & 7-seg uses scan_clk_pulse (1kHz pulse)
    reg bcd_start;
    reg [15:0] bcd_timer;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            bcd_timer <= 16'd0; bcd_start <= 1'b0;
        end else begin
            if (scan_clk_pulse) begin
                if (bcd_timer >= 16'd2000) begin
                    bcd_start <= 1'b1;
                    bcd_timer <= 16'd0;
                end else begin
                    bcd_start <= 1'b0;
                    bcd_timer <= bcd_timer + 1'b1;
                end
            end else bcd_start <= 1'b0;
        end
    end

    binary_to_bcd_sequential u_bcd (
        .clk (scan_clk_pulse ? clk_main : clk_main), // still sync to clk_main; pulse used to start conversion
        .rst_n (rst_core_n),
        .start (bcd_start),
        .bin_in (score_bin),
        .done (bcd_done),
        .bcd_out (score_bcd)
    );

    seven_segment_driver u_seg (
        .clk_scan (scan_clk_pulse ? clk_main : clk_main),
        .rst_n (rst_core_n),
        .bcd_in (score_bcd),
        .seg (seg7),
        .an (an7)
    );

    wire [6:0] seg7; wire [7:0] an7;
    assign AR_SEG_A  = seg7[6]; assign AR_SEG_B  = seg7[5]; assign AR_SEG_C = seg7[4];
    assign AR_SEG_D  = seg7[3]; assign AR_SEG_E  = seg7[2]; assign AR_SEG_F = seg7[1];
    assign AR_SEG_G  = seg7[0]; assign AR_SEG_DP = 1'b1;
    assign AR_SEG_S0 = ~an7[0]; assign AR_SEG_S1 = ~an7[1]; assign AR_SEG_S2 = ~an7[2]; assign AR_SEG_S3 = ~an7[3];
    assign AR_SEG_S4 = ~an7[4]; assign AR_SEG_S5 = ~an7[5]; assign AR_SEG_S6 = ~an7[6]; assign AR_SEG_S7 = ~an7[7];

    // ---------------------------
    // LCD driver: feed lcd_clk_pulse (1MHz single-cycle pulses)
    // lcd_driver expects posedge clock events; a 1-cycle pulse is sufficient.
    // ---------------------------
    lcd_driver u_lcd (
        .clk (lcd_clk_pulse ? clk_main : clk_main), // posedge will happen once per pulse
        .rst_n (rst_core_n),
        .state (state),
        .dino_frame (dino_frame),
        .dino_row (dino_row),
        .obs_top (obs_top),
        .obs_bot (obs_bot),
        .life_top (life_top),
        .life_bot (life_bot),
        .debuff_top (debuff_top),
        .debuff_bot (debuff_bot),
        .lcd_rs (TLCD_RS),
        .lcd_rw (TLCD_RW),
        .lcd_en (TLCD_E),
        .lcd_data (TLCD_D)
    );

endmodule
