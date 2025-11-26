module pos_edge (
    input  wire clk,
    input  wire inp,        // raw signal
    output wire out        // posedge
);
    reg prev = 0;

    always @(posedge clk) begin
        prev <= inp;
    end

    assign out = (~prev) & inp;   // 0->1
endmodule
