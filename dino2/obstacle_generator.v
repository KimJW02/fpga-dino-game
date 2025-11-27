module obstacle_generator(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick,
    input  wire [2:0] gap_min,
    input  wire [7:0] th,
    input  wire [15:0] lfsr,
    output reg  [15:0] obs_top,
    output reg  [15:0] obs_bot,
    output reg         spawn_obstacle
);
    reg [2:0] gap_cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            obs_top <= 0; obs_bot <= 0; spawn_obstacle <= 0;
            gap_cnt <= 0;
        end else begin
            spawn_obstacle <= 1'b0;
            if (tick) begin
                // 이동 시 비트 이동
                obs_top <= {obs_top[14:0], 1'b0};
                obs_bot <= {obs_bot[14:0], 1'b0};
                if (gap_cnt != 0) gap_cnt <= gap_cnt - 1;
                if (gap_cnt == 0 && lfsr[15:8] < th) begin
                    if (lfsr[0]) obs_top[0] <= 1'b1;
                    else           obs_bot[0] <= 1'b1;
                    spawn_obstacle <= 1'b1;
                    gap_cnt <= gap_min;  // 난이도 모듈에서 받은 최소 간격 사용
                end
            end
        end
    end
endmodule
