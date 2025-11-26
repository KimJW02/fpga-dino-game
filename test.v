`timescale 10ns/100ps

module test();

    reg clk;
    reg [3:0] btns;
    wire out;
    wire [3:0] outs;
    
    main u1(clk, btns, out, outs);
    
    initial begin
        clk = 0;
        btns = 0;
        #20 btns = 4'b1001;
        #20 btns = 4'b1100;
        #20 btns = 4'b1111;
        #20 btns = 4'b1010;
    end
    
    always #1 clk = !clk;

endmodule 