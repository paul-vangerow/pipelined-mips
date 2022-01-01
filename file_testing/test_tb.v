module test_tb();

    logic stall;
    logic clk;

    initial begin

        $dumpfile("test.vcd");
        $dumpvars(0, test);

        clk = 0;
        stall = 0;

        repeat(100) begin
            
            #10; clk = ~clk;

        end
    end

    initial begin
        
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
        stall = 1;
        @ (posedge clk);
        stall = 0;

    end

    test test(clk, stall);

endmodule