module debounce #(
    parameter CLK_FREQ = 50_000_000, // Hz
    parameter DEBOUNCE_MS = 10       // ms
)(
    input  wire clk,
    input  wire btn_in,
    output reg  btn_out = 0
);
    localparam integer STABLE_COUNT = (CLK_FREQ / 1000) * DEBOUNCE_MS;
    localparam integer CNT_BITS = $clog2(STABLE_COUNT);

    reg [CNT_BITS-1:0] counter = 0;
    reg btn_sync = 0;

    always @(posedge clk) begin
        btn_sync <= btn_in;
        if (btn_sync != btn_out) begin
            if (counter == STABLE_COUNT-1) begin
                btn_out <= btn_sync;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
        end
    end
endmodule

module debounces #(
    parameter CLK_FREQ = 50_000_000,
    parameter DEBOUNCE_MS = 10
)(
    input  wire clk,
    input  wire [3:0] btn_in,
    output wire [3:0] btn_out
);
    debounce #(.CLK_FREQ(CLK_FREQ), .DEBOUNCE_MS(DEBOUNCE_MS)) d0(.clk(clk), .btn_in(btn_in[0]), .btn_out(btn_out[0]));
    debounce #(.CLK_FREQ(CLK_FREQ), .DEBOUNCE_MS(DEBOUNCE_MS)) d1(.clk(clk), .btn_in(btn_in[1]), .btn_out(btn_out[1]));
    debounce #(.CLK_FREQ(CLK_FREQ), .DEBOUNCE_MS(DEBOUNCE_MS)) d2(.clk(clk), .btn_in(btn_in[2]), .btn_out(btn_out[2]));
    debounce #(.CLK_FREQ(CLK_FREQ), .DEBOUNCE_MS(DEBOUNCE_MS)) d3(.clk(clk), .btn_in(btn_in[3]), .btn_out(btn_out[3]));
endmodule