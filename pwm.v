module pwm #(
    parameter WIDTH = 24
)(
    input  wire                clk,
    input  wire [WIDTH-1:0]    period, // PWM cycle
    output reg                 out = 0
);

    reg [WIDTH-1:0] cnt = 0;

    always @(posedge clk) begin
        if (cnt >= period - 1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    // PWM
    always @(posedge clk) begin
        if (cnt < (period >> 1))
            out <= 1'b1;
        else
            out <= 1'b0;
    end

endmodule
