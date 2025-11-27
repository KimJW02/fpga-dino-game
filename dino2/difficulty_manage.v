// difficulty_manage 모듈 예시 (난이도별 파라미터 결정)
module difficulty_manage(
    input  wire [1:0] mode,          // 00: Easy, 01: Normal, 10: Hard
    output reg  [7:0] obs_th,        // 장애물 출현 임계값
    output reg  [2:0] obs_gap,       // 장애물 최소 간격
    output reg [15:0] life_interval, // 아이템 시도 간격
    output reg  [7:0] life_th,       // 라이프 아이템 임계값
    output reg  [7:0] debuff_th      // 디버프 아이템 임계값
);
always @(*) begin
    case (mode)
        2'b00: begin // Easy
            obs_th        = 8'd20;
            obs_gap       = 3'd6;
            life_interval = 16'd80;
            life_th       = 8'd20;
            debuff_th     = 8'd10;
        end
        2'b01: begin // Normal
            obs_th        = 8'd30;
            obs_gap       = 3'd5;
            life_interval = 16'd60;
            life_th       = 8'd15;
            debuff_th     = 8'd15;
        end
        default: begin // Hard
            obs_th        = 8'd45;
            obs_gap       = 3'd4;
            life_interval = 16'd40;
            life_th       = 8'd10;
            debuff_th     = 8'd20;
        end
    endcase
end
endmodule
