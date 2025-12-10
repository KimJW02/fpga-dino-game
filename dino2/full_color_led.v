// full_color_led.v
module full_color_led #(
    parameter integer P = 1   // ±ôºýÀÓ È½¼ö (ON/OFF ÇÕÃÄ¼­ 2*P Åä±Û)
)(
    input  wire clk,
    input  wire rst_n,
    input  wire hit_obst,
    input  wire hit_bonus,
    input  wire hit_debuff,
    output reg  [11:0] fled
);
    localparam integer C = 2 * P;
    localparam NONE = 2'd0, RED = 2'd1, GREEN = 2'd2, BLUE = 2'd3;

    // state regs
    reg [1:0] color;
    reg [$clog2(C+1)-1:0] cnt;
    reg is_on;

    // edge detect regs
    wire pulse;
    reg  pulse_d;
    reg  hit_obst_d, hit_bonus_d, hit_debuff_d;

    wire pulse_rise      = pulse & ~pulse_d;
    wire hit_obst_rise   = hit_obst & ~hit_obst_d;
    wire hit_bonus_rise  = hit_bonus & ~hit_bonus_d;
    wire hit_debuff_rise  = hit_debuff & ~hit_debuff_d;

    clk_divider #(.DIV(25000000)) cd (
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(pulse)
    );

    // -------------------------------------------------------
    // Status update: compute next-state (to avoid NB ordering issues)
    // -------------------------------------------------------
    // We'll compute next_* using combinational logic and update at posedge clk
    reg [1:0] next_color;
    reg [$clog2(C+1)-1:0] next_cnt;
    reg next_is_on;
    reg [11:0] next_fled;

    always @(*) begin
        // default next = current (hold)
        next_color = color;
        next_cnt   = cnt;
        next_is_on = is_on;
        next_fled  = fled;

        // event triggers only on rising edge of hit signals (we use derived signals)
        if (hit_obst_rise) begin
            next_color = RED;
            next_cnt   = 0;
            next_is_on = 0;
            next_fled  = 12'd0;
        end else if (hit_bonus_rise) begin
            next_color = GREEN;
            next_cnt   = 0;
            next_is_on = 0;
            next_fled  = 12'd0;
        end else if (hit_debuff_rise) begin
            next_color = BLUE;
            next_cnt   = 0;
            next_is_on = 0;
            next_fled  = 12'd0;
        end
        // blink progression: evaluate pulse rising edge
        else if (color != NONE && pulse_rise) begin
            // compute toggled is_on and cnt increment
            next_cnt   = cnt + 1;
            next_is_on = ~is_on; // proposed new value

            // Use next_is_on to decide LED output (so no off-by-one)
            if (next_is_on) begin
                case (color)
                    RED:   next_fled = 12'b0000_0000_1111;
                    GREEN: next_fled = 12'b0000_1111_0000;
                    BLUE:  next_fled = 12'b1111_0000_0000;
                    default: next_fled = 12'd0;
                endcase
            end else begin
                next_fled = 12'd0;
            end
        end

        // check terminal condition using the computed next_cnt:
        if (next_cnt >= C) begin
            // end blinking -> reset to idle
            next_color = NONE;
            next_cnt   = 0;
            next_is_on = 0;
            next_fled  = 12'd0;
        end
    end

    // -------------------------------------------------------
    // Sequential update (single clock edge)
    // -------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            color      <= NONE;
            cnt        <= 0;
            is_on      <= 0;
            fled       <= 12'd0;
            pulse_d    <= 0;
            hit_obst_d <= 0;
            hit_bonus_d<= 0;
            hit_debuff_d<= 0;
        end else begin
            // update edge detectors first
            pulse_d    <= pulse;
            hit_obst_d <= hit_obst;
            hit_bonus_d<= hit_bonus;
            hit_debuff_d<= hit_debuff;

            // update state from next_*
            color <= next_color;
            cnt   <= next_cnt;
            is_on <= next_is_on;
            fled  <= next_fled;
        end
    end

endmodule
