`timescale 1ns / 1ps
//TODO: 배경음악 연결, 이벤트 발생시 피에조 + full color led 변화
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
    // 사용자 요구 유지
    wire rst_core_n = ~rst_n;

    // =========================================================
    // 1) clk_main 생성
    // =========================================================
    reg clk_main;
    reg [8:0] div_main_cnt; 
    always @(posedge clk_50m or negedge rst_core_n) begin
        if (!rst_core_n) begin
            div_main_cnt <= 9'd0;
            clk_main     <= 1'b0;
        end else begin
            if (div_main_cnt == 9'd249) begin
                div_main_cnt <= 9'd0;
                clk_main <= ~clk_main;
            end else begin
                div_main_cnt <= div_main_cnt + 1'b1;
            end
        end
    end

    // =========================================================
    // 2) LCD/7seg용 펄스 & 스캔 클럭
    // =========================================================
    reg lcd_clk_pulse;
    reg [6:0] lcd_div_cnt;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            lcd_div_cnt   <= 7'd0;
            lcd_clk_pulse <= 1'b0;
        end else begin
            if (lcd_div_cnt == 7'd39) begin
                lcd_div_cnt   <= 7'd0;
                lcd_clk_pulse <= 1'b1;
            end else begin
                lcd_div_cnt   <= lcd_div_cnt + 1'b1;
                lcd_clk_pulse <= 1'b0;
            end
        end
    end

    reg [19:0] scan_div_cnt;
    reg scan_clk_pulse;
    localparam SCAN_DIV = 20'd50000;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            scan_div_cnt   <= 20'd0;
            scan_clk_pulse <= 1'b0;
        end else begin
            if (scan_div_cnt >= SCAN_DIV-1) begin
                scan_div_cnt   <= 20'd0;
                scan_clk_pulse <= 1'b1;
            end else begin
                scan_div_cnt   <= scan_div_cnt + 1'b1;
                scan_clk_pulse <= 1'b0;
            end
        end
    end

    localparam integer SCAN_DIV_HALF = 50; 
    reg [15:0] scan_div;
    reg scan_clk;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            scan_div <= 16'd0;
            scan_clk <= 1'b0;
        end else begin
            if (scan_div == SCAN_DIV_HALF-1) begin
                scan_div <= 16'd0;
                scan_clk <= ~scan_clk;
            end else begin
                scan_div <= scan_div + 1'b1;
            end
        end
    end
    // =========================================================
    // 3) 게임 tick 생성 (단순화 버전)
    //    - move_tick : "기본 게임 틱"
    //    - cell_tick : "실제 1칸 이동/판정/점프 단위"
    // =========================================================
    localparam integer CLK_MAIN_FREQ_HZ = 100_000;
    localparam integer MOVE_HZ  = 50;  // 기본 게임 틱(권장)
    localparam integer MOVE_DIV = (CLK_MAIN_FREQ_HZ / MOVE_HZ < 1) ? 1 : (CLK_MAIN_FREQ_HZ / MOVE_HZ);
    localparam integer MOVE_DIV_W = $clog2(MOVE_DIV + 1);
    
    reg [MOVE_DIV_W-1:0] move_div_cnt;
    reg move_tick;
    
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            move_div_cnt <= {MOVE_DIV_W{1'b0}};
            move_tick    <= 1'b0;
        end else begin
            if (move_div_cnt >= MOVE_DIV-1) begin
                move_div_cnt <= {MOVE_DIV_W{1'b0}};
                move_tick    <= 1'b1;
            end else begin
                move_div_cnt <= move_div_cnt + 1'b1;
                move_tick    <= 1'b0;
            end
        end
    end
    
    localparam integer SHIFT_DIV_GAME      = 5;
    localparam integer ITEM_SHIFT_DIV_GAME = 5;
    
    localparam integer LDW = (SHIFT_DIV_GAME <= 1) ? 1 : $clog2(SHIFT_DIV_GAME);
    reg [LDW-1:0] cell_div_cnt;
    
    wire cell_tick = move_tick && (SHIFT_DIV_GAME <= 1 || cell_div_cnt == SHIFT_DIV_GAME-1);

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            cell_div_cnt <= {LDW{1'b0}};
        end else if (move_tick) begin
            if (SHIFT_DIV_GAME <= 1) begin
                cell_div_cnt <= {LDW{1'b0}};
            end else if (cell_div_cnt == SHIFT_DIV_GAME-1) begin
                cell_div_cnt <= {LDW{1'b0}};
            end else begin
                cell_div_cnt <= cell_div_cnt + 1'b1;
            end
        end
    end
    wire logic_tick = cell_tick;
    // =========================================================
    // 4) 상태 머신
    // =========================================================
    localparam S_HELLO = 3'd0,
               S_MODE  = 3'd1,
               S_READY = 3'd2,
               S_PLAY  = 3'd3,
               S_OVER  = 3'd4;

    reg [2:0] state, next_state;
    reg [31:0] hello_cnt_main;
    localparam HELLO_TICKS = 125_000; // clk_main 기준

    reg [7:0] life_count;

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            state <= S_HELLO;
            hello_cnt_main <= 32'd0;
        end else begin
            state <= next_state;
            if (state == S_HELLO) begin
                if (hello_cnt_main < HELLO_TICKS)
                    hello_cnt_main <= hello_cnt_main + 1'b1;
            end else begin
                hello_cnt_main <= 32'd0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_HELLO: if (hello_cnt_main >= HELLO_TICKS) next_state = S_MODE;
            S_MODE:  if (sw1_easy || sw2_normal || sw3_hard) next_state = S_READY;
            S_READY: if (start_req) next_state = S_PLAY;
            S_PLAY:  if (life_count == 0) next_state = S_OVER;
            S_OVER:  if (start_req) next_state = S_HELLO;
            default: next_state = S_HELLO;
        endcase
    end

    // =========================================================
    // 5) 점프 FSM 선언 (버튼 consume 조건에서 사용)
    // =========================================================
    reg dino_row_r;
    reg dino_frame_r;
    reg [3:0] jump_state;
    reg [7:0] dino_anim_cnt;
    reg [7:0] air_cnt;

    localparam DJ_GROUND  = 0,
               DJ_ASCEND  = 1,
               DJ_AIR     = 2,
               DJ_DESCEND = 3;

    wire dino_row   = dino_row_r;
    wire dino_frame = dino_frame_r;

    // =========================================================
    // 6) 버튼 (active-low) + READY/OVER release gate
    // =========================================================
    wire btn_jump_act = ~btn_jump;

    reg btn_ff1, btn_ff2;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            btn_ff1 <= 1'b0;
            btn_ff2 <= 1'b0;
        end else begin
            btn_ff1 <= btn_jump_act;
            btn_ff2 <= btn_ff1;
        end
    end
    wire btn_stable = btn_ff2;

    reg btn_prev_main;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) btn_prev_main <= 1'b0;
        else            btn_prev_main <= btn_stable;
    end
    wire btn_rise = btn_stable && !btn_prev_main;

    reg ready_btn_released;
    reg over_btn_released;

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            ready_btn_released <= 1'b0;
            over_btn_released  <= 1'b0;
        end else begin
            if (state != S_READY) ready_btn_released <= 1'b0;
            else if (!btn_stable) ready_btn_released <= 1'b1;

            if (state != S_OVER) over_btn_released <= 1'b0;
            else if (!btn_stable) over_btn_released <= 1'b1;
        end
    end

    reg start_req;
    reg jump_req;

    wire jump_consume = cell_tick &&
                        (state == S_PLAY) &&
                        (jump_state == DJ_GROUND) &&
                        jump_req;

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            start_req <= 1'b0;
            jump_req  <= 1'b0;
        end else begin
            if (state != S_READY && state != S_OVER)
                start_req <= 1'b0;

            if (state != S_PLAY)
                jump_req <= 1'b0;

            if (btn_rise) begin
                if (state == S_READY && ready_btn_released)
                    start_req <= 1'b1;
                else if (state == S_PLAY)
                    jump_req <= 1'b1;
                else if (state == S_OVER && over_btn_released)
                    start_req <= 1'b1;
            end

            if (jump_consume)
                jump_req <= 1'b0;
        end
    end

    // =========================================================
    // 7) DINO FSM (logic_tick 기준으로 동기화)
    // =========================================================
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            dino_row_r     <= 1'b1;
            dino_frame_r   <= 1'b0;
            dino_anim_cnt  <= 8'd0;
            air_cnt        <= 8'd0;
            jump_state     <= DJ_GROUND;
        end else begin
            if (cell_tick) begin
                // animation (너무 빠르면 숫자만 조정)
                dino_anim_cnt <= dino_anim_cnt + 1'b1;
                if (dino_anim_cnt >= 8'd2) begin
                    dino_anim_cnt <= 8'd0;
                    dino_frame_r  <= ~dino_frame_r;
                end
    
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
                        // 공중 유지
                        if (air_cnt >= 8'd2)
                            jump_state <= DJ_DESCEND;
                    end
    
                    DJ_DESCEND: begin
                        dino_row_r <= 1'b1;
                        jump_state <= DJ_GROUND;
                    end
                endcase
            end
        end
    end


    // =========================================================
    // 8) RNG
    // =========================================================
    wire [15:0] lfsr_q;
    lfsr16 u_lfsr (
        .clk  (clk_main),
        .rst_n(rst_core_n),
        .q    (lfsr_q)
    );

    // =========================================================
    // 9) 난이도
    // =========================================================
    wire [7:0]  obs_th, life_th, debuff_th;
    wire [5:0]  obs_gap;
    wire [15:0] life_interval;

    difficulty_manage u_diff (
        .mode(sw1_easy ? 2'b00 : sw2_normal ? 2'b01 : 2'b10),
        .obs_th(obs_th),
        .obs_gap(obs_gap),
        .life_interval(life_interval),
        .life_th(life_th),
        .debuff_th(debuff_th)
    );

    // =========================================================
    // 10) Generator (move_tick 입력 유지)
    //     내부에서 SHIFT_DIV 기준 shift 수행
    // =========================================================
    wire [15:0] obs_top, obs_bot;
    wire spawn_obs;

    obstacle_generator #(
        .SHIFT_DIV(SHIFT_DIV_GAME)
    ) u_obs (
        .clk(clk_main), .rst_n(rst_core_n), .tick(move_tick),
        .gap_min(obs_gap), .th(obs_th),
        .lfsr(lfsr_q),
        .obs_top(obs_top), .obs_bot(obs_bot),
        .spawn_obstacle(spawn_obs)
    );

    wire [31:0] score_bin;
    wire [31:0] score_bcd;

    wire [15:0] life_top, life_bot, debuff_top, debuff_bot;
    wire spawn_life_w, spawn_debuff_w;

    item_generator #(
        .ITEM_SHIFT_DIV(ITEM_SHIFT_DIV_GAME)
    ) u_item (
        .clk(clk_main), .rst_n(rst_core_n), .tick(move_tick),
        .lfsr(lfsr_q),
        .obs_mask(obs_top | obs_bot),
        .score_in(score_bin),
        .life_interval(life_interval),
        .life_th(life_th),
        .debuff_th(debuff_th),
        .life_top(life_top), .life_bot(life_bot),
        .debuff_top(debuff_top), .debuff_bot(debuff_bot),
        .spawn_life(spawn_life_w),
        .spawn_debuff(spawn_debuff_w)
    );

    // =========================================================
    // 11) Spawn safety (logic_tick 기준)
    // =========================================================
    reg [4:0] spawn_safety_cnt;
    wire is_safe_spawn = (spawn_safety_cnt < 5'd16);

    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            spawn_safety_cnt <= 0;
        end else begin
            if (state != S_PLAY)
                spawn_safety_cnt <= 0;
            else if (logic_tick && spawn_safety_cnt < 5'd16)
                spawn_safety_cnt <= spawn_safety_cnt + 1;
        end
    end

    // =========================================================
    // 12) Collision (logic_tick 단위로 반영)
    // =========================================================
    wire hit_obstacle = 1'b0; //디버깅때문에 무시 , TODO: 주석제거
//        !is_safe_spawn &&
//        ((dino_row_r == 1'b1 && obs_bot[15]) ||
//         (dino_row_r == 1'b0 && obs_top[15]));

    wire hit_life_level =
        !is_safe_spawn &&
        ((dino_row_r == 1'b0 && life_top[15]) ||
         (dino_row_r == 1'b1 && life_bot[15]));

    wire hit_debuff_level =
        !is_safe_spawn &&
        ((dino_row_r == 1'b0 && debuff_top[15]) ||
         (dino_row_r == 1'b1 && debuff_bot[15]));

    // hit_life를 1회성 펄스로 변환 (연속 +1 방지)
    reg hit_life_d;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            hit_life_d <= 1'b0;
        end else if (logic_tick) begin
            hit_life_d <= hit_life_level;
        end
    end
    wire hit_life_pulse = logic_tick && hit_life_level && !hit_life_d;

    // debuff도 필요하면 같은 방식으로 펄스화 가능
    reg hit_debuff_d;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            hit_debuff_d <= 1'b0;
        end else if (logic_tick) begin
            hit_debuff_d <= hit_debuff_level;
        end
    end
    wire hit_debuff_pulse = logic_tick && hit_debuff_level && !hit_debuff_d;

    // =========================================================
    // 13) Life count (logic_tick 기준)
    // =========================================================
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) begin
            life_count <= 8'd1;
        end else begin
            if (state == S_READY)
                life_count <= 8'd1;
            else if (state == S_PLAY && logic_tick) begin
                if (hit_life_pulse && life_count < 8)
                    life_count <= life_count + 1;
                else if (hit_obstacle && life_count > 0)
                    life_count <= life_count - 1;
            end
        end
    end

    wire [7:0] life_leds;
    life_manager u_life (.life(life_count), .leds_out(life_leds));
    assign LED_D1 = life_leds[0]; assign LED_D2 = life_leds[1];
    assign LED_D3 = life_leds[2]; assign LED_D4 = life_leds[3];
    assign LED_D5 = life_leds[4]; assign LED_D6 = life_leds[5];
    assign LED_D7 = life_leds[6]; assign LED_D8 = life_leds[7];

    // =========================================================
    // 14) Score (logic_tick 기준으로 증가/감점)
    // =========================================================
    score_counter #(
        .BASE_INC(10),
        .DEBUF_SCORE(300),
        .MAX_SCORE(32'd99999999)
    ) u_score (
        .clk_game  (clk_main),
        .rst_n     (rst_core_n),
        .enable    (state == S_PLAY && logic_tick),
        .hit_debuff(hit_debuff_pulse),
        .score_out (score_bin)
    );

    // =========================================================
    // 15) BCD 변환 + 7-seg
    // =========================================================
    wire bcd_done;
    wire bcd_start_pulse = (state == S_PLAY) && logic_tick;

    reg [31:0] bcd_latched;
    always @(posedge clk_main or negedge rst_core_n) begin
        if (!rst_core_n) bcd_latched <= 32'd0;
        else if (state != S_PLAY) bcd_latched <= 32'd0;
        else if (bcd_done) bcd_latched <= score_bcd;
    end


    binary_to_bcd_sequential u_bcd (
        .clk    (clk_main),
        .rst_n  (rst_core_n),
        .start  (bcd_start_pulse),
        .bin_in (score_bin),
        .done   (bcd_done),
        .bcd_out(score_bcd)
    );

    wire [7:0] seg8;
    wire [7:0] an7;
    
    seven_segment_driver u_seg (
        .clk_scan (scan_clk),
        .rst_n    (rst_core_n),
        .bcd_in   (bcd_latched),
        .seg_data (seg8),
        .an       (an7)
    );
    
    assign AR_SEG_S0 = ~an7[7];
    assign AR_SEG_S1 = ~an7[6];
    assign AR_SEG_S2 = ~an7[5];
    assign AR_SEG_S3 = ~an7[4];
    assign AR_SEG_S4 = ~an7[3];
    assign AR_SEG_S5 = ~an7[2];
    assign AR_SEG_S6 = ~an7[1];
    assign AR_SEG_S7 = ~an7[0];
    
    // seg8 비트 순서 = {A,B,C,D,E,F,G,DP}
    assign {AR_SEG_A, AR_SEG_B, AR_SEG_C, AR_SEG_D,
            AR_SEG_E, AR_SEG_F, AR_SEG_G, AR_SEG_DP} = seg8;
    
 

    // =========================================================
    // 16) LCD Driver
    // =========================================================
    lcd_driver u_lcd (
        .clk        (clk_main),
        .rst_n      (rst_core_n),
        .state      (state),
        .dino_frame (dino_frame),
        .dino_row   (dino_row),
        .obs_top    (obs_top),
        .obs_bot    (obs_bot),
        .life_top   (life_top),
        .life_bot   (life_bot),
        .debuff_top (debuff_top),
        .debuff_bot (debuff_bot),
        .lcd_rs     (TLCD_RS),
        .lcd_rw     (TLCD_RW),
        .lcd_en     (TLCD_E),
        .lcd_data   (TLCD_D)
    );

endmodule
