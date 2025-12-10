`timescale 1ns/1ps

module tb_full_color_led;

    reg clk;
    reg rst_n;
    reg hit_obst;
    reg hit_bonus;
    wire [11:0] fled;

    // DUT instantiation
    // clk_divider #(25000000) → 테스트에서는 5로 오버라이드
    full_color_led #(.P(3)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .hit_obst(hit_obst),
        .hit_bonus(hit_bonus),
        .fled(fled)
    );

    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // 초기 상태
        rst_n     = 0;
        hit_obst  = 0;
        hit_bonus = 0;

        // reset 유지
        #50;
        rst_n = 1;  // 정상 동작 시작

        // 1) 장애물 이벤트 발생(red blink)
        #40;
        hit_obst = 1;
        #10;
        hit_obst = 0;

        // 깜빡임이 끝날 때까지 기다림
        #300;

        // 2) 보너스 이벤트 발생(green blink)
        hit_bonus = 1;
        #10;
        hit_bonus = 0;

        #300;

        // 3) 두 이벤트 연속 입력 테스트
        hit_obst = 1;  #10; hit_obst = 0;
        #60;
        hit_bonus = 1; #10; hit_bonus = 0;

        #300;

        $finish;
    end

endmodule
