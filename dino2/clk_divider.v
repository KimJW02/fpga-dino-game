module clk_divider #(
    parameter integer DIV = 2
)(
    input  wire clk_in,
    input  wire rst_n,   // active low
    output reg  clk_out
);
    // width 계산: DIV 값에 맞춰 카운터 비트 크기 선택
    localparam integer W = (DIV <= 1) ? 1 : $clog2(DIV);
    reg [W-1:0] cnt;

    // handle trivial cases
    initial begin
        clk_out = 0;
        cnt = 0;
    end

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 0;
            clk_out <= 0;
        end else begin
            if (DIV <= 1) begin
                // DIV=1: clk_out == clk_in (pass-through) - but generally DIV>=2 권장
                clk_out <= ~clk_out;
            end else begin
                if (cnt == (DIV/2 - 1)) begin
                    cnt     <= 0;
                    clk_out <= ~clk_out;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        end
    end
endmodule
