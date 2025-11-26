module main_fsm #(
    parameter HZ = 50_000_000
)(
    input  wire clk,
    input  wire [2:0] main_state,
    output reg  [2:0] main_state_next
);

    localparam INIT       = 3'b000;
    localparam SELECT     = 3'b001;
    localparam BEGIN      = 3'b010;
    localparam GAME       = 3'b011;
    localparam OVER       = 3'b100;
    
    reg [27:0] cnt = 0;
    
    always @(posedge clk) begin
        case (main_state)
            INIT: begin
                if (cnt == HZ-1) begin
                    cnt <= 0;
                    main_state_next <= SELECT;
                end else cnt <= cnt + 1;
            end
            SELECT: begin
                
            end
        endcase
    end

endmodule