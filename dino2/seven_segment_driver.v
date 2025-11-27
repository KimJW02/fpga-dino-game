module seven_segment_driver (
    input  wire        clk_scan,   // e.g., 1kHz or faster for multiplexing
    input  wire        rst_n,
    input  wire [31:0] bcd_in,
    output reg  [6:0]  seg,
    output reg  [7:0]  an
);
    reg [2:0] idx;
    reg [3:0] digit;
    always @(posedge clk_scan or negedge rst_n) begin
        if (!rst_n) begin
            idx <= 3'd0;
            an <= 8'hFF;
            seg <= 7'b111_1111;
        end else begin
            idx <= idx + 1'b1;
            case (idx)
                3'd0: digit <= bcd_in[3:0];
                3'd1: digit <= bcd_in[7:4];
                3'd2: digit <= bcd_in[11:8];
                3'd3: digit <= bcd_in[15:12];
                3'd4: digit <= bcd_in[19:16];
                3'd5: digit <= bcd_in[23:20];
                3'd6: digit <= bcd_in[27:24];
                3'd7: digit <= bcd_in[31:28];
                default: digit <= 4'd0;
            endcase
            // active-low anodes: enable current digit
            an <= 8'hFF;
            an[idx] <= 1'b0;

            // segment mapping (common cathode assumed; invert if your hardware uses common anode)
            case (digit)
                4'd0: seg <= 7'b1000000;
                4'd1: seg <= 7'b1111001;
                4'd2: seg <= 7'b0100100;
                4'd3: seg <= 7'b0110000;
                4'd4: seg <= 7'b0011001;
                4'd5: seg <= 7'b0010010;
                4'd6: seg <= 7'b0000010;
                4'd7: seg <= 7'b1111000;
                4'd8: seg <= 7'b0000000;
                4'd9: seg <= 7'b0010000;
                default: seg <= 7'b1111111; // blank
            endcase
        end
    end
endmodule