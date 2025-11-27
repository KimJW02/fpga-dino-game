module lcd_driver (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [2:0] state,
    input  wire       dino_frame,
    input  wire       dino_row,

    input  wire [15:0] obs_top,
    input  wire [15:0] obs_bot,

    input  wire [15:0] life_top,
    input  wire [15:0] life_bot,
    input  wire [15:0] debuff_top,
    input  wire [15:0] debuff_bot,

    output reg  lcd_rs,
    output reg  lcd_rw,
    output reg  lcd_en,
    output reg [7:0] lcd_data
);

    localparam L_PWR_WAIT   = 4'd0,
               L_FUNCSET    = 4'd1,
               L_DISPON     = 4'd2,
               L_CLEAR      = 4'd3,
               L_ENTRY      = 4'd4,
               L_CGRAM_ADDR = 4'd5,
               L_CGRAM_DATA = 4'd6,
               L_IDLE       = 4'd7,
               L_SET_DDR0   = 4'd8,
               L_WRITE0     = 4'd9,
               L_SET_DDR1   = 4'd10,
               L_WRITE1     = 4'd11,
               L_SEND       = 4'd12;

    localparam CMD_FUNCSET = 8'h38;
    localparam CMD_DISPON  = 8'h0C;
    localparam CMD_CLEAR   = 8'h01;
    localparam CMD_ENTRY   = 8'h06;

    localparam PWR_WAIT_CNT   = 16'd50000;
    localparam PULSE_WIDTH    = 16'd2;
    localparam EXEC_WAIT      = 16'd80;
    localparam CLEAR_WAIT     = 16'd2000;

    reg [7:0] cgram_init [0:63];
    integer i;

    initial begin
        cgram_init[0]  = 8'b00111;
        cgram_init[1]  = 8'b00111;
        cgram_init[2]  = 8'b00111;
        cgram_init[3]  = 8'b10110;
        cgram_init[4]  = 8'b11111;
        cgram_init[5]  = 8'b11110;
        cgram_init[6]  = 8'b01110;
        cgram_init[7]  = 8'b00100;

        cgram_init[8]  = 8'b00111;
        cgram_init[9]  = 8'b00111;
        cgram_init[10] = 8'b00111;
        cgram_init[11] = 8'b10110;
        cgram_init[12] = 8'b11111;
        cgram_init[13] = 8'b11110;
        cgram_init[14] = 8'b01110;
        cgram_init[15] = 8'b00010;

        cgram_init[16] = 8'b00000;
        cgram_init[17] = 8'b00100;
        cgram_init[18] = 8'b00101;
        cgram_init[19] = 8'b10101;
        cgram_init[20] = 8'b10110;
        cgram_init[21] = 8'b01100;
        cgram_init[22] = 8'b00100;
        cgram_init[23] = 8'b00100;

        cgram_init[24] = 8'b00000;
        cgram_init[25] = 8'b01010;
        cgram_init[26] = 8'b11111;
        cgram_init[27] = 8'b11111;
        cgram_init[28] = 8'b01110;
        cgram_init[29] = 8'b00100;
        cgram_init[30] = 8'b00000;
        cgram_init[31] = 8'b00000;

        cgram_init[32] = 8'b00000;
        cgram_init[33] = 8'b10001;
        cgram_init[34] = 8'b01010;
        cgram_init[35] = 8'b00100;
        cgram_init[36] = 8'b01010;
        cgram_init[37] = 8'b10001;
        cgram_init[38] = 8'b00000;
        cgram_init[39] = 8'b00000;
        
        cgram_init[40] = 8'b00000;
        cgram_init[41] = 8'b01000;
        cgram_init[42] = 8'b01100;
        cgram_init[43] = 8'b01100;
        cgram_init[44] = 8'b11111;
        cgram_init[45] = 8'b01100;
        cgram_init[46] = 8'b01000;
        cgram_init[47] = 8'b00000;
        
        for (i = 48; i < 64; i = i+1)
            cgram_init[i] = 8'b00000;
    end

    reg [7:0] row0 [0:15];
    reg [7:0] row1 [0:15];
    integer col;
    integer idx;

    always @(*) begin
        for (col = 0; col < 16; col = col+1) begin
            row0[col] = 8'h20;
            row1[col] = 8'h20;
        end

        case (state)
            3'd0: begin
                row0[0]  = "H"; row0[1] = "e"; row0[2] = "l"; row0[3] = "l"; row0[4] = "o";
                row0[5]  = ","; row0[7] = "D"; row0[8] = "i"; row0[9] = "n"; row0[10] = "o";
            end
            3'd1: begin
                row0[0]="P"; row0[1]="r"; row0[2]="e"; row0[3]="s"; row0[4]="s";
                row0[6]="1"; row0[7]=","; row0[8]="2"; row0[9]=","; row0[10]="3";
                row1[1]="t"; row1[2]="o"; row1[4]="s"; row1[5]="e"; row1[6]="l"; row1[7]="e"; row1[8]="c"; row1[9]="t";
                row1[11]="m"; row1[12]="o"; row1[13]="d"; row1[14]="e";
            end
            3'd2: begin
                row0[0]="P"; row0[1]="r"; row0[2]="e"; row0[3]="s"; row0[4]="s";
                row0[6]="0"; row0[8]="t"; row0[9]="o"; row0[11]="J"; row0[12]="u"; row0[13]="m"; row0[14]="p";
                row1[0] = dino_frame ? 8'h01 : 8'h00;
            end
            3'd3: begin
                for (col = 0; col < 16; col = col+1) begin
                    row0[col] = 8'h20;
                    row1[col] = 8'h20;
                end

                for (col = 0; col < 16; col = col+1) begin
                    idx = 15 - col;

                    // 1) Dino
                    if (col == 0) begin
                        if (dino_row == 1'b0) begin
                            // Dino is on top row
                            row0[col] = dino_frame ? 8'h01 : 8'h00;
                        end else begin
                            // Dino is on bottom row
                            row1[col] = dino_frame ? 8'h01 : 8'h00;
                        end
                    end

                    // 2) Row0 : 우선순위 obstacle > life > debuff > space
                    //  dino_row==0이면 dino가 시각적으로 우선
                    if (!(col == 0 && dino_row == 1'b0)) begin
                        if (obs_top[idx]) begin
                            row0[col] = 8'h05; // bird custom
                        end else if (life_top[idx]) begin
                            row0[col] = 8'h03; // life item
                        end else if (debuff_top[idx]) begin
                            row0[col] = 8'h04; // debuff
                        end else begin
                            row0[col] = row0[col];
                        end
                    end

                    // 3) Row1 : 우선순위 obstacle > life > debuff > space
                    if (!(col == 0 && dino_row == 1'b1)) begin
                        if (obs_bot[idx]) begin
                            row1[col] = 8'h02; // ground obstacle
                        end else if (life_bot[idx]) begin
                            row1[col] = 8'h03; // life item
                        end else if (debuff_bot[idx]) begin
                            row1[col] = 8'h04; // debuff
                        end else begin
                            row1[col] = row1[col];
                        end
                    end
                end
            end
            3'd4: begin
                row0[0]="G"; row0[1]="A"; row0[2]="M"; row0[3]="E"; row0[5]="O"; row0[6]="V"; row0[7]="E"; row0[8]="R"; row0[9]="!";
            end
            default: ;
        endcase
    end

    reg [3:0]  lstate, lstate_next;
    reg [15:0] wait_cnt;
    reg [5:0]  cgram_idx;
    reg [4:0]  ddram_idx;
    reg [7:0]  send_byte;
    reg        send_rs;
    reg [1:0]  send_phase;
    reg [3:0]  return_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) lcd_rw <= 1'b0;
        else        lcd_rw <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lstate      <= L_PWR_WAIT;
            wait_cnt    <= 16'd0;
            cgram_idx   <= 6'd0;
            ddram_idx   <= 5'd0;
            lcd_en      <= 1'b0;
            lcd_rs      <= 1'b0;
            lcd_data    <= 8'h00;
            send_phase  <= 2'd0;
            return_state<= L_IDLE;
        end else begin
            lstate <= lstate_next;

            case (lstate)
                L_PWR_WAIT: begin
                    lcd_en <= 1'b0;
                    if (wait_cnt < PWR_WAIT_CNT)
                        wait_cnt <= wait_cnt + 1'b1;
                    else
                        wait_cnt <= 16'd0;
                end

                L_FUNCSET: begin
                    send_byte    <= CMD_FUNCSET;
                    send_rs      <= 1'b0;
                    return_state <= L_DISPON;
                    send_phase   <= 2'd0;
                end

                L_DISPON: begin
                    send_byte    <= CMD_DISPON;
                    send_rs      <= 1'b0;
                    return_state <= L_CLEAR;
                    send_phase   <= 2'd0;
                end

                L_CLEAR: begin
                    send_byte    <= CMD_CLEAR;
                    send_rs      <= 1'b0;
                    return_state <= L_ENTRY;
                    send_phase   <= 2'd0;
                end

                L_ENTRY: begin
                    send_byte    <= CMD_ENTRY;
                    send_rs      <= 1'b0;
                    return_state <= L_CGRAM_ADDR;
                    send_phase   <= 2'd0;
                end

                L_CGRAM_ADDR: begin
                    if (cgram_idx < 6'd48) begin
                        send_byte    <= 8'h40 + cgram_idx;
                        send_rs      <= 1'b0;
                        return_state <= L_CGRAM_DATA;
                    end else begin
                        // finished CGRAM load
                        return_state <= L_IDLE;
                    end
                end

                L_CGRAM_DATA: begin
                    if (cgram_idx < 6'd48) begin
                        send_byte <= cgram_init[cgram_idx];
                        send_rs   <= 1'b1;
                        cgram_idx <= cgram_idx + 1'b1;
                        // next return -> addr (to set next CGRAM address) unless finished
                        return_state <= (cgram_idx + 1 < 6'd48) ? L_CGRAM_ADDR : L_IDLE;
                        end else begin
                            return_state <= L_IDLE;
                        end
                end

                L_IDLE: begin
                    ddram_idx <= 5'd0;
                end

                L_SET_DDR0: begin
                    send_byte    <= 8'h80;
                    send_rs      <= 1'b0;
                    return_state <= L_WRITE0;
                    send_phase   <= 2'd0;
                end

                L_WRITE0: begin
                    if (ddram_idx < 5'd16) begin
                        send_byte    <= row0[ddram_idx];
                        send_rs      <= 1'b1;
                        return_state <= L_WRITE0;
                        ddram_idx    <= ddram_idx + 1'b1;
                        send_phase   <= 2'd0;
                    end else begin
                        ddram_idx    <= 5'd0;
                        return_state <= L_SET_DDR1;
                        send_phase   <= 2'd0;
                    end
                end

                L_SET_DDR1: begin
                    send_byte    <= 8'hC0;
                    send_rs      <= 1'b0;
                    return_state <= L_WRITE1;
                    send_phase   <= 2'd0;
                end

                L_WRITE1: begin
                    if (ddram_idx < 5'd16) begin
                        send_byte    <= row1[ddram_idx];
                        send_rs      <= 1'b1;
                        return_state <= L_WRITE1;
                        ddram_idx    <= ddram_idx + 1'b1;
                        send_phase   <= 2'd0;
                    end else begin
                        ddram_idx    <= 5'd0;
                        return_state <= L_SET_DDR0;
                        send_phase   <= 2'd0;
                    end
                end

                L_SEND: begin
                    case (send_phase)
                        2'd0: begin
                            lcd_rs   <= send_rs;
                            lcd_data <= send_byte;
                            lcd_en   <= 1'b1;
                            wait_cnt <= 16'd0;
                            send_phase <= 2'd1;
                        end
                        2'd1: begin
                            if (wait_cnt < PULSE_WIDTH-1)
                                wait_cnt <= wait_cnt + 1'b1;
                            else begin
                                lcd_en    <= 1'b0;
                                wait_cnt  <= 16'd0;
                                send_phase<= 2'd2;
                            end
                        end
                        2'd2: begin
                            if (send_byte == CMD_CLEAR) begin
                                if (wait_cnt < CLEAR_WAIT-1)
                                    wait_cnt <= wait_cnt + 1'b1;
                                else begin
                                    wait_cnt   <= 16'd0;
                                    send_phase <= 2'd0;
                                end
                            end else begin
                                if (wait_cnt < EXEC_WAIT-1)
                                    wait_cnt <= wait_cnt + 1'b1;
                                else begin
                                    wait_cnt   <= 16'd0;
                                    send_phase <= 2'd0;
                                end
                            end
                        end
                    endcase
                end

                default: ;
            endcase
        end
    end

    always @(*) begin
        lstate_next = lstate;

        case (lstate)
            L_PWR_WAIT:   lstate_next = (wait_cnt >= PWR_WAIT_CNT) ? L_FUNCSET : L_PWR_WAIT;
            L_FUNCSET,
            L_DISPON,
            L_CLEAR,
            L_ENTRY,
            L_CGRAM_ADDR,
            L_CGRAM_DATA,
            L_SET_DDR0,
            L_WRITE0,
            L_SET_DDR1,
            L_WRITE1:     lstate_next = L_SEND;

            L_IDLE:       lstate_next = L_SET_DDR0;

            L_SEND: begin
                if (send_phase == 2'd2 &&
                    ((send_byte == CMD_CLEAR  && wait_cnt == CLEAR_WAIT-1) ||
                     (send_byte != CMD_CLEAR  && wait_cnt == EXEC_WAIT-1)))
                    lstate_next = return_state;
                else
                    lstate_next = L_SEND;
            end

            default:      lstate_next = L_PWR_WAIT;
        endcase
    end

endmodule
