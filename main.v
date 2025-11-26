module main(
    input wire clk,
    input wire [11:0] btns,
    output wire out,
    output wire [3:0] outs
);

    // Main state
    // init, select, begin, game, over
    wire [2:0] main_state;
    wire [2:0] main_state_next;
    memory #(3) main_state_mem(.clk(clk), .d(main_state_next), .q(main_state));
    
    main_fsm mf(clk, main_state, main_state_next);
    
    // tone test
    //multi_tone mt(clk, btns, out);
/*    
    
    // Buttons
    wire [3:0] buttons;
    debounces dbn(clk, btns, buttons);
    //debounce #(1000, 1) db(clk, btns[0], out);
        
    // Game state
    wire [2:0] game_state;
    wire [2:0] game_state_next;
    memory #(3) game_state_mem(.clk(clk), .d(game_state_next), .q(game_state));
    
    // Life
    wire [2:0] life_state;
    wire [2:0] life_state_next;
    memory #(3) life_state_mem(.clk(clk), .d(life_state_next), .q(life_state));
      
    // Speed
    wire [1:0] speed;
    wire [1:0] speed_next;
    memory #(2) speed_mem(.clk(clk), .d(speed_next), .q(speed));

    // Score
    wire [15:0] score;
    score_counter sc(.clk(clk), .rst(1'b0), .period(24'd5_000_000), .score(score));
*/
endmodule