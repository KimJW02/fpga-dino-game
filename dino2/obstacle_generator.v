module obstacle_generator #(
    parameter integer SHIFT_DIV =5
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tick,
    input  wire [5:0]  gap_min,
    input  wire [7:0]  th,
    input  wire [15:0] lfsr,
    output reg  [15:0] obs_top,
    output reg  [15:0] obs_bot,
    output reg          spawn_obstacle
);
    reg [5:0] gap_cnt;

    localparam integer SDW = (SHIFT_DIV <= 1) ? 1 : $clog2(SHIFT_DIV);
    reg [SDW-1:0] shift_div_cnt;

    wire shift_pulse = tick && (SHIFT_DIV <= 1 || shift_div_cnt == SHIFT_DIV-1);

    reg [15:0] next_top, next_bot;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            obs_top        <= 16'd0;
            obs_bot        <= 16'd0;
            spawn_obstacle <= 1'b0;
            gap_cnt        <= 6'd0;
            shift_div_cnt  <= {SDW{1'b0}};
        end else begin
            spawn_obstacle <= 1'b0;

            if (tick) begin
                // divider
                if (SHIFT_DIV <= 1) begin
                    shift_div_cnt <= {SDW{1'b0}};
                end else if (shift_div_cnt == SHIFT_DIV-1) begin
                    shift_div_cnt <= {SDW{1'b0}};
                end else begin
                    shift_div_cnt <= shift_div_cnt + 1'b1;
                end

                if (shift_pulse) begin
                    // 기본 1칸 쉬프트 결과를 임시로 만들고
                    next_top = {obs_top[14:0], 1'b0};
                    next_bot = {obs_bot[14:0], 1'b0};

                    // gap 감소 (단위 = "칸 이동 횟수")
                    if (gap_cnt != 0)
                        gap_cnt <= gap_cnt - 1'b1;

                    // spawn 조건
                    if (gap_cnt == 0 && lfsr[15:8] < th) begin
                        if (lfsr[0]) next_top[0] = 1'b1;
                        else         next_bot[0] = 1'b1;

                        spawn_obstacle <= 1'b1;
                        gap_cnt <= gap_min;
                    end

                    // 최종 반영
                    obs_top <= next_top;
                    obs_bot <= next_bot;
                end
            end
        end
    end
endmodule
