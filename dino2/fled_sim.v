module top_with_simhits #(
    parameter SIM = 1     // SIM=1 → 내부 hit 생성, 0 → 외부 입력 사용
)(
    input  wire clk,
    input  wire rst_n,
    input  wire hit_obst_ext,
    input  wire hit_bonus_ext,
    output wire [11:0] fled
);
    // ======================================
    // SIMULATION HIT GENERATOR
    // ======================================
    reg hit_obst_sim  = 0;
    reg hit_bonus_sim = 0;

    generate
        if (SIM) begin : SIM_BLOCK
            reg [31:0] sim_cnt = 0;

            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    sim_cnt <= 0;
                    hit_obst_sim  <= 0;
                    hit_bonus_sim <= 0;
                end else begin
                    sim_cnt <= sim_cnt + 1;

                    // 예시: 특정 시점에 자동으로 입력 발생
                    hit_obst_sim  <= (sim_cnt == 100);
                    hit_bonus_sim <= (sim_cnt == 500);

                    // pulse형 입력 유지 시간 1 clk
                end
            end
        end else begin : NO_SIM_BLOCK
            always @(*) begin
                hit_obst_sim  = 0;
                hit_bonus_sim = 0;
            end
        end
    endgenerate

    // ======================================
    // HIT SELECTOR (SIM or EXTERNAL)
    // ======================================
    wire hit_obst  = SIM ? hit_obst_sim  : hit_obst_ext;
    wire hit_bonus = SIM ? hit_bonus_sim : hit_bonus_ext;

    // ======================================
    // LED MODULE
    // ======================================
    full_color_led led_inst(
        .clk(clk),
        .rst_n(rst_n),
        .hit_obst(hit_obst),
        .hit_bonus(hit_bonus),
        .fled(fled)
    );

endmodule
