module seven_segment_driver (
    input  wire        clk_scan,
    input  wire        rst_n,
    input  wire [31:0] bcd_in,
    output reg  [7:0]  seg_data, // A,B,C,D,E,F,G,DP (active-low)
    output reg  [7:0]  an        // one-hot logical: 1=selected
);
    reg [2:0] idx;
    reg [3:0] digit;

    function automatic [7:0] seg_pat;
        input [3:0] d;
        begin
            case (d)
                4'd0: seg_pat = ~8'b00000011;
                4'd1: seg_pat = ~8'b10011111;
                4'd2: seg_pat = ~8'b00100101;
                4'd3: seg_pat = ~8'b00001101;
                4'd4: seg_pat = ~8'b10011001;
                4'd5: seg_pat = ~8'b01001001;
                4'd6: seg_pat = ~8'b01000001;
                4'd7: seg_pat = ~8'b00011011;
                4'd8: seg_pat = ~8'b00000001;
                4'd9: seg_pat = ~8'b00001001;
                default: seg_pat = 8'b11111100; // OFF
            endcase
        end
    endfunction

    always @(posedge clk_scan or negedge rst_n) begin
        if (!rst_n) begin
            idx      <= 3'd0;
            seg_data <= 8'hFF;  // ??: ???? OFF
            an       <= 8'h00;
        end else begin
            case (idx)
                3'd0: digit <= bcd_in[3:0];
                3'd1: digit <= bcd_in[7:4];
                3'd2: digit <= bcd_in[11:8];
                3'd3: digit <= bcd_in[15:12];
                3'd4: digit <= bcd_in[19:16];
                3'd5: digit <= bcd_in[23:20];
                3'd6: digit <= bcd_in[27:24];
                3'd7: digit <= bcd_in[31:28];
            endcase

            seg_data <= seg_pat(digit);
            an       <= (8'b00000001 << idx);

            idx      <= idx + 1'b1;
        end
    end
endmodule