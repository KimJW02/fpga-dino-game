module dino_ctrl (
    input  wire clk_game,
    input  wire rst_n,
    input  wire play_enable,
    input  wire jump_pulse_game,
    output reg  dino_row,
    output reg  dino_frame,
    output reg  hit_frame_toggle
);
    reg [7:0] anim_cnt;
    reg [7:0] air_cnt;
    reg [1:0] js;
    localparam G=0,A1=1,A2=2,D=3;
    always @(posedge clk_game or negedge rst_n) begin
        if (!rst_n) begin
            dino_row <= 1;
            dino_frame <= 0;
            anim_cnt <= 0;
            air_cnt <= 0;
            js <= G;
        end else begin
            anim_cnt <= anim_cnt + 1;
            if (anim_cnt >= 8'd4) begin anim_cnt <= 0; dino_frame <= ~dino_frame; end

            case (js)
                G: begin dino_row <= 1; if (jump_pulse_game) js <= A1; end
                A1: begin dino_row <= 0; air_cnt <= 0; js <= A2; end
                A2: begin dino_row <= 0; air_cnt <= air_cnt + 1; if (air_cnt > 8'd1) js <= D; end
                D: begin dino_row <= 1; js <= G; end
            endcase
        end
    end
endmodule
