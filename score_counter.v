module score_counter(
    input wire clk,
    input wire rst,
    input wire [31:0] period,
    output reg [31:0] score = 0
);
    wire pwm_out;
    pwm p1(clk, period, pwm_out);

    wire edge_out;
    pos_edge pe(clk, pwm_out, edge_out);

    always @(posedge clk) begin
        if (rst)
            score <= 0;
        else if (edge_out)
            score <= score + 1;
    end
endmodule
