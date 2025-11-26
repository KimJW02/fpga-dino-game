module tone #(
    parameter CLK_FREQ = 50_000_000  //
)(
    input  wire clk,
    input  wire enable,               // play or not
    input wire [15:0] freq,
    output wire piezo_out
);
    // 50% duty PWM -> half-period
    wire pwm_out;
    pwm tone_pwm (.clk(clk), .period((CLK_FREQ / freq) / 2), .out(pwm_out));

    assign piezo_out = enable ? pwm_out : 1'b0;
endmodule

module multi_tone #(
    parameter CLK_FREQ = 50_000_000,
    parameter ARP_MS   = 5               // 5ms마다 다음 음으로
)(
    input  wire clk,
    input  wire [23:0] key,              // 24-bit hot encoding
    output wire piezo_out
);
    // hot encoding
    reg [4:0] pressed[0:23];
    integer press_count;

    integer i;
    always @(*) begin
        press_count = 0;
        for (i = 0; i < 24; i = i + 1) begin
            if (key[i]) begin
                pressed[press_count] = i;
                press_count = press_count + 1;
            end
        end
    end

    // Arpeggio round-robin index
    reg [4:0] current = 0;
    
    // Switch interval 5ms timer
    localparam integer TICK = (CLK_FREQ / 1000) * ARP_MS;
    reg [31:0] cnt = 0;

    always @(posedge clk) begin
        if (press_count == 0) begin
            cnt <= 0;
            current <= 0;
        end 
        else begin
            if (cnt >= TICK) begin
                cnt <= 0;
                // next tone
                if (current + 1 < press_count)
                    current <= current + 1;
                else
                    current <= 0;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
    
    wire [15:0] freq;
    note_lut lut(.index( pressed[current] ), .freq(freq));

    tone #(.CLK_FREQ(CLK_FREQ)) t1 (.clk(clk), .enable(press_count != 0), .freq(freq), .piezo_out(piezo_out));
endmodule

module note_lut(
    input  wire [4:0] index,      // 0~23
    output reg  [15:0] freq
);

    always @(*) begin
        case (index)
            5'd0:  freq = 16'd261;   // C4
            5'd1:  freq = 16'd277;
            5'd2:  freq = 16'd293;
            5'd3:  freq = 16'd311;
            5'd4:  freq = 16'd329;
            5'd5:  freq = 16'd349;
            5'd6:  freq = 16'd369;
            5'd7:  freq = 16'd392;
            5'd8:  freq = 16'd415;
            5'd9:  freq = 16'd440;
            5'd10: freq = 16'd466;
            5'd11: freq = 16'd493;
            5'd12: freq = 16'd523;   // C5
            5'd13: freq = 16'd554;
            5'd14: freq = 16'd587;
            5'd15: freq = 16'd622;
            5'd16: freq = 16'd659;
            5'd17: freq = 16'd698;
            5'd18: freq = 16'd739;
            5'd19: freq = 16'd783;
            5'd20: freq = 16'd830;
            5'd21: freq = 16'd880;
            5'd22: freq = 16'd932;
            5'd23: freq = 16'd987;
            default: freq = 16'd0;
        endcase
    end

endmodule
