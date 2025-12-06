module binary_to_bcd_sequential (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [31:0] bin_in,
    output reg         done,
    output reg [31:0]  bcd_out
);
    reg [63:0] work;
    reg [5:0]  bitcount;
    reg        busy;

    reg [31:0] bcd_tmp;
    reg [63:0] next_work;
    integer k;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            work     <= 64'd0;
            bitcount <= 6'd0;
            busy     <= 1'b0;
            done     <= 1'b0;
            bcd_out  <= 32'd0;
        end else begin
            done <= 1'b0;

            // ? start는 top에서 이미 1클럭 펄스라고 가정
            if (start && !busy) begin
                work     <= {32'h0, bin_in};
                bitcount <= 6'd32;
                busy     <= 1'b1;
            end else if (busy) begin
                bcd_tmp = work[63:32];

                for (k = 0; k < 8; k = k + 1) begin
                    if (bcd_tmp[31 - (k*4) -: 4] >= 4'd5)
                        bcd_tmp[31 - (k*4) -: 4] =
                            bcd_tmp[31 - (k*4) -: 4] + 4'd3;
                end

                next_work = ({bcd_tmp, work[31:0]}) << 1;
                work <= next_work;

                if (bitcount == 6'd1) begin
                    busy    <= 1'b0;
                    bcd_out <= next_work[63:32];
                    done    <= 1'b1;
                    bitcount<= 6'd0;
                end else begin
                    bitcount<= bitcount - 1'b1;
                end
            end
        end
    end
endmodule
