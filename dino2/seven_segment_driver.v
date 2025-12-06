`timescale 1ns / 1ps
module seven_segment_driver (
    input  wire        clk_scan,
    input  wire        rst_n,
    input  wire [31:0] bcd_in,
    output reg  [6:0]  seg,   // [0]=A [1]=B [2]=C [3]=D [4]=E [5]=F [6]=G
    output reg  [7:0]  an     // one-hot, 1=selected
);
    reg [2:0] idx;
    reg [3:0] digit;

    function automatic [6:0] seg_logical;
        input [3:0] d;
        begin
            case (d)
                4'd0: seg_logical = 7'b0111111; // A B C D E F on
                4'd1: seg_logical = 7'b0000110; // B C
                4'd2: seg_logical = 7'b1011011; // A B D E G
                4'd3: seg_logical = 7'b1001111; // A B C D G
                4'd4: seg_logical = 7'b1100110; // B C F G
                4'd5: seg_logical = 7'b1101101; // A C D F G
                4'd6: seg_logical = 7'b1111101; // A C D E F G
                4'd7: seg_logical = 7'b0000111; // A B C
                4'd8: seg_logical = 7'b1111111; // all
                4'd9: seg_logical = 7'b1101111; // A B C D F G
                default: seg_logical = 7'b0000000; // blank
            endcase
        end
    endfunction

    always @(posedge clk_scan or negedge rst_n) begin
        if (!rst_n) begin
            idx <= 3'd0;
            seg <= 7'b0000000; // blank logical
            an  <= 8'b00000000; // none selected logical
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
                default: digit <= 4'd0;
            endcase

            seg <= seg_logical(digit);
            an  <= (8'b00000001 << idx); // one-hot logical

            idx <= idx + 1'b1;
        end
    end
endmodule
