module mem_bgm #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output reg  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    
    initial begin
        rom[0]  = {16'd659, 16'd150};
        rom[1]  = {16'd659, 16'd150};
        rom[2]  = {16'd0,   16'd150};
        rom[3]  = {16'd659, 16'd150};
        rom[4]  = {16'd0,   16'd150};
        rom[5]  = {16'd523, 16'd150};
        rom[6]  = {16'd659, 16'd150};
        rom[7]  = {16'd0,   16'd150};
        rom[8]  = {16'd784, 16'd300};
        rom[9]  = {16'd0,   16'd300};
        rom[10] = {16'd392, 16'd300};
        rom[11] = {16'd0,   16'd300};
    
        rom[12] = {16'd523, 16'd150};
        rom[13] = {16'd0,   16'd75};
        rom[14] = {16'd392, 16'd150};
        rom[15] = {16'd0,   16'd75};
        rom[16] = {16'd330, 16'd150};
        rom[17] = {16'd0,   16'd150};
    
        rom[18] = {16'd440, 16'd150};
        rom[19] = {16'd494, 16'd150};
        rom[20] = {16'd466, 16'd150};
        rom[21] = {16'd440, 16'd150};
        rom[22] = {16'd392, 16'd150};
        rom[23] = {16'd659, 16'd150};
        rom[24] = {16'd784, 16'd150};
        rom[25] = {16'd880, 16'd300};
        rom[26] = {16'd0,   16'd150};
    
        rom[27] = {16'd784, 16'd150};
        rom[28] = {16'd659, 16'd150};
        rom[29] = {16'd698, 16'd150};
        rom[30] = {16'd740, 16'd300};
        rom[31] = {16'd659, 16'd300};
        rom[32] = {16'd523, 16'd300};
        rom[33] = {16'd587, 16'd300};
        rom[34] = {16'd494, 16'd300};
    
        rom[35] = {16'd523, 16'd150};
        rom[36] = {16'd0,   16'd75};
        rom[37] = {16'd392, 16'd150};
        rom[38] = {16'd0,   16'd75};
        rom[39] = {16'd330, 16'd150};
        rom[40] = {16'd0,   16'd150};
    
        rom[41] = {16'd440, 16'd150};
        rom[42] = {16'd494, 16'd150};
        rom[43] = {16'd466, 16'd150};
        rom[44] = {16'd440, 16'd150};
        rom[45] = {16'd392, 16'd150};
        rom[46] = {16'd659, 16'd150};
        rom[47] = {16'd784, 16'd150};
        rom[48] = {16'd880, 16'd300};
        rom[49] = {16'd0,   16'd150};
    
        rom[50] = {16'd784, 16'd150};
        rom[51] = {16'd659, 16'd150};
        rom[52] = {16'd698, 16'd150};
        rom[53] = {16'd740, 16'd300};
        rom[54] = {16'd659, 16'd300};
        rom[55] = {16'd523, 16'd300};
        rom[56] = {16'd587, 16'd300};
        rom[57] = {16'd494, 16'd300};
    
        rom[58] = {16'd784, 16'd300};
        rom[59] = {16'd740, 16'd150};
        rom[60] = {16'd698, 16'd150};
        rom[61] = {16'd659, 16'd150};
        rom[62] = {16'd0,   16'd150};
        rom[63] = {16'd698, 16'd150};
        rom[64] = {16'd740, 16'd150};
        rom[65] = {16'd784, 16'd300};
        rom[66] = {16'd587, 16'd150};
        rom[67] = {16'd659, 16'd150};
        rom[68] = {16'd698, 16'd300};
        rom[69] = {16'd659, 16'd150};
        rom[70] = {16'd587, 16'd150};
        rom[71] = {16'd523, 16'd150};
        rom[72] = {16'd0,   16'd150};
    
        rom[73] = {16'd330, 16'd300};
        rom[74] = {16'd392, 16'd300};
        rom[75] = {16'd440, 16'd300};
        rom[76] = {16'd0,   16'd150};
        rom[77] = {16'd392, 16'd150};
        rom[78] = {16'd330, 16'd150};
        rom[79] = {16'd294, 16'd150};
        rom[80] = {16'd0,   16'd150};
    
        rom[81] = {16'd330, 16'd300};
        rom[82] = {16'd392, 16'd300};
        rom[83] = {16'd440, 16'd300};
        rom[84] = {16'd0,   16'd150};
        rom[85] = {16'd392, 16'd150};
        rom[86] = {16'd330, 16'd150};
        rom[87] = {16'd294, 16'd150};
    
        // 반복 구간 자동 복사 (88~175)
        for (i = 88; i < 176; i = i + 1) begin
            rom[i] = rom[i - 76];
        end
    
        rom[176] = {16'd0, 16'd500};
        rom[177] = {16'd0, 16'd500};
        rom[178] = {16'd0, 16'd500};
        rom[179] = {16'd0, 16'd500};
    end
    
    reg [ADDR_WIDTH-1:0] addr_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr_reg <= 0;
            data_out <= 32'd0;
        end else begin
            addr_reg <= addr_in;        // capture address (like BRAM port)
            data_out <= rom[addr_reg];         // data_out available after 2 cycles
        end
    end

endmodule

module mem_sfx_item #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output reg  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    
    initial begin
        rom[0] = {16'd988,  16'd60};
        rom[1] = {16'd1319, 16'd60};
        rom[2] = {16'd1760, 16'd60};
        rom[3] = {16'd0,    16'd30};
    end
    
    reg [ADDR_WIDTH-1:0] addr_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr_reg <= 0;
            data_out <= 32'd0;
        end else begin
            addr_reg <= addr_in;        // capture address (like BRAM port)
            data_out <= rom[addr_reg];         // data_out available after 2 cycles
        end
    end

endmodule

module mem_sfx_debuf #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output reg  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    initial begin
        rom[0] = {16'd1319, 16'd60};
        rom[1] = {16'd1567, 16'd60};
        rom[2] = {16'd1760, 16'd60};
        rom[3] = {16'd2637, 16'd60};
        rom[4] = {16'd3135, 16'd60};
        rom[5] = {16'd3520, 16'd60};
    end
    
    reg [ADDR_WIDTH-1:0] addr_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr_reg <= 0;
            data_out <= 32'd0;
        end else begin
            addr_reg <= addr_in;        // capture address (like BRAM port)
            data_out <= rom[addr_reg];         // data_out available after 2 cycles
        end
    end

endmodule

module mem_jump #(
    parameter ADDR_WIDTH = 8
) (
    input  wire clk,
    input  wire rstn,
    input  wire [ADDR_WIDTH-1:0] addr_in,
    output reg  [31:0] data_out
);

    integer i;
        
    localparam DEPTH = 180;
    reg [31:0] rom [0:DEPTH-1];
    
    initial begin
        rom[0] = {16'd330, 16'd50};
        rom[1] = {16'd370, 16'd50};
        rom[2] = {16'd415, 16'd50};
        rom[3] = {16'd466, 16'd50};
        rom[4] = {16'd523, 16'd50};
        rom[5] = {16'd587, 16'd50};
    end
    
    reg [ADDR_WIDTH-1:0] addr_reg;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            addr_reg <= 0;
            data_out <= 32'd0;
        end else begin
            addr_reg <= addr_in;        // capture address (like BRAM port)
            data_out <= rom[addr_reg];         // data_out available after 2 cycles
        end
    end

endmodule

module piezo_player #(
    parameter integer CLK_FREQ   = 50000000,
    parameter integer ADDR_WIDTH = 8,
    parameter integer READ_LATENCY = 2
)(
    input  wire clk,
    input  wire rstn,

    output reg  [ADDR_WIDTH-1:0] mem_addr,
    input  wire [31:0] mem_data_in,

    output reg piezo_out
);

    localparam IDLE     = 2'd0;
    localparam WAIT_MEM = 2'd1;
    localparam PLAY     = 2'd2;

    reg [1:0] state;
    reg [1:0] next_state;

    reg [ADDR_WIDTH-1:0] note_idx;

    reg [3:0] wait_cnt;
    reg [31:0] note_word;

    wire [15:0] freq_hz    = note_word[31:16];
    wire [15:0] duration_ms= note_word[15:0];

    // ----------------- ms tick generator ----------------
    localparam integer CLK_PER_MS = CLK_FREQ / 1000;
    reg [31:0] ms_div;
    reg ms_tick;

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            ms_div <= 0;
            ms_tick <= 0;
        end else begin
            if (ms_div >= CLK_PER_MS-1) begin
                ms_div <= 0;
                ms_tick <= 1;
            end else begin
                ms_div <= ms_div + 1;
                ms_tick <= 0;
            end
        end
    end

    // duration counter
    reg [31:0] dur_cnt;

    // ---------------- tone generator ---------------------
    reg [31:0] half_period;
    reg [31:0] tone_cnt;
    reg tone_sq;

    always @(*) begin
        if (freq_hz == 0)
            half_period = 32'd0;
        else
            half_period = CLK_FREQ / (freq_hz * 2);
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            tone_cnt <= 0;
            tone_sq <= 0;
        end else begin
            if (half_period == 0) begin
                tone_cnt <= 0;
                tone_sq <= 0;
            end else begin
                if (tone_cnt >= half_period - 1) begin
                    tone_cnt <= 0;
                    tone_sq <= ~tone_sq;
                end else begin
                    tone_cnt <= tone_cnt + 1;
                end
            end
        end
    end

    // ---------------- FSM -------------------------------
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= IDLE;
            mem_addr <= 0;
            note_idx <= 0;
            wait_cnt <= 0;
            note_word <= 0;
            dur_cnt <= 0;
            piezo_out <= 0;
        end else begin
            case(state)

            IDLE: begin
                mem_addr <= note_idx;
                wait_cnt <= 0;
                state <= WAIT_MEM;
            end

            WAIT_MEM: begin
                if (wait_cnt < READ_LATENCY) begin
                    wait_cnt <= wait_cnt + 1;
                end else begin
                    note_word <= mem_data_in;
                    dur_cnt <= duration_ms;
                    state <= PLAY;
                end
            end

            PLAY: begin
                piezo_out <= tone_sq;

                if (ms_tick) begin
                    if (dur_cnt == 0) begin
                        note_idx <= note_idx + 1;
                        mem_addr <= note_idx + 1;
                        wait_cnt <= 0;
                        state <= WAIT_MEM;
                    end else begin
                        dur_cnt <= dur_cnt - 1;
                    end
                end
            end

            endcase
        end
    end

endmodule

module bgm #(
    parameter integer CLK_FREQ   = 5000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_bgm #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH),
        .READ_LATENCY(2)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module sfx_item #(
    parameter integer CLK_FREQ   = 5000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_sfx_item #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH),
        .READ_LATENCY(2)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module sfx_debuf #(
    parameter integer CLK_FREQ   = 5000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_sfx_debuf #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH),
        .READ_LATENCY(2)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module sfx_jump #(
    parameter integer CLK_FREQ   = 5000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire play,
    output wire piezo
);

    wire [ADDR_WIDTH-1:0] bram_addr;
    wire [31:0] bram_data;
    reg rstn = 0;

    mem_jump #(.ADDR_WIDTH(ADDR_WIDTH)) mem_if (
        .clk(clk),
        .rstn(rstn),
        .addr_in(bram_addr),
        .data_out(bram_data)
    );

    piezo_player #(
        .CLK_FREQ(CLK_FREQ),
        .ADDR_WIDTH(ADDR_WIDTH),
        .READ_LATENCY(2)
    ) player (
        .clk(clk),
        .rstn(rstn),
        .mem_addr(bram_addr),
        .mem_data_in(bram_data),
        .piezo_out(piezo)
    );

    always @(*) begin
        rstn <= play;
    end

endmodule

module audio #(
    parameter integer CLK_FREQ   = 5000000,
    parameter integer ADDR_WIDTH = 8
)(
    input wire clk,
    input wire [3:0] state, // 0: idle, 1: bgm, 2: item, 3: debuf, 4: jump
    output wire piezo
);

    wire music;
    bgm b1(.clk(clk), .play(state[0]), .piezo(music));
    
    wire out1;
    sfx_item b2(.clk(clk), .play(state[1]), .piezo(out1));
    
    wire out2;
    sfx_debuf b3(.clk(clk), .play(state[2]), .piezo(out2));
    
    wire out3;
    sfx_jump b4(.clk(clk), .play(state[3]), .piezo(out3));
    
    wire sfx;
    assign sfx = out1 | out2 | out3;
    assign piezo = sfx ? sfx : music;
endmodule
