module binary_to_bcd_sequential (
    input  wire        clk,       // conversion clock (can be slow like 1kHz)
    input  wire        rst_n,
    input  wire        start,     // start pulse (one clk)
    input  wire [31:0] bin_in,    // binary input
    output reg         done,      // goes high one clk when finished
    output reg [31:0]  bcd_out    // 8 digits ¡¿ 4 bits (MSD..LSD)
);
    // internal work register: [63:0] = {BCD(32 bits) , BIN(32 bits)}
    reg [63:0] work;
    reg [5:0]  bitcount; // 0..32
    reg        busy;

    integer k;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            work <= 64'd0;
            bitcount <= 6'd0;
            busy <= 1'b0;
            done <= 1'b0;
            bcd_out <= 32'd0;
        end else begin
            done <= 1'b0;
            if (start && !busy) begin
                // initialize: upper 32 bits zero (BCD), lower 32 bits = bin_in
                work <= {32'h0, bin_in};
                bitcount <= 6'd32;
                busy <= 1'b1;
            end else if (busy) begin
                // for each step: if any 4-bit BCD field >=5 add 3
                // BCD fields in work[63:32] (8 fields)
                for (k = 0; k < 8; k = k + 1) begin
                    if (work[63 - (k*4) -: 4] >= 4'd5) begin
                        work[63 - (k*4) -: 4] <= work[63 - (k*4) -: 4] + 4'd3;
                    end
                end
                // shift left by 1
                work <= work << 1;
                bitcount <= bitcount - 1'b1;
                if (bitcount == 1) begin
                    // finished after this shift
                    busy <= 1'b0;
                    bcd_out <= work[63:32]; // BCD digits
                    done <= 1'b1;
                end
            end
        end
    end
endmodule
