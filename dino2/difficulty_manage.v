module difficulty_manage(
    input  wire [1:0] mode,
    output reg  [7:0] obs_th,
    output reg  [5:0] obs_gap,
    output reg [15:0] life_interval,
    output reg  [7:0] life_th,
    output reg  [7:0] debuff_th
);

//TODO : SHIFT_DIV를 각 모드(sw1_easy, sw2_normal, sw3_hard)에 따라 자동 조절
always @(*) begin
    case (mode)
        2'b00: begin // Easy
            obs_th        = 8'd60;
            obs_gap       = 6'd10;
            life_interval = 16'd120;
            life_th       = 8'd120;
            debuff_th     = 8'd80;
        end
        2'b01: begin // Normal
            obs_th        = 8'd90;
            obs_gap       = 6'd8;
            life_interval = 16'd90;
            life_th       = 8'd100;
            debuff_th     = 8'd100;
        end
        default: begin // Hard
            obs_th        = 8'd120;
            obs_gap       = 6'd6;
            life_interval = 16'd60;
            life_th       = 8'd80;
            debuff_th     = 8'd130;
        end
    endcase
end
endmodule
