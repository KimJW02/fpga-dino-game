`timescale 1ns / 1ps
module life_manager (
    input  wire [7:0] life,    // 0..8 expected
    output reg  [7:0] leds_out // active-high
);
    integer i;
    reg [3:0] lv;
    always @* begin
        if (life > 8) lv = 4'd8;
        else lv = life[3:0];
        for (i = 0; i < 8; i = i + 1) begin
            if (i < lv) leds_out[i] = 1'b1;
            else leds_out[i] = 1'b0;
        end
    end
endmodule
