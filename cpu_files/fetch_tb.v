module fetch_tb();

    logic active;
    logic clk;
    logic stall;

    logic [31:0] PC_Val;

    // Avalon

    logic read;
    logic [3:0] byteenable;
    logic [31:0] address;

    initial begin

        $dumpfile("fetch_tb.vcd");
        $dumpvars(0, fetch_tb);
        
        clk = 0;
        PC_Val = 10;
        stall = 0;
        active = 1;

        repeat(100) begin
            #10; clk = ~clk;
        end

        $fatal(1, "Timeout");

    end

    initial begin
        
        @ (posedge clk);
        PC_Val = PC_Val + 4;
        @ (posedge clk);
        PC_Val = PC_Val + 4;
        @ (posedge clk);
        PC_Val = PC_Val + 4;
        @ (posedge clk);
        PC_Val = PC_Val + 4;
        @ (posedge clk);
        stall = 1;
        @ (posedge clk);
        stall = 0;
        PC_Val = PC_Val + 4;
        @ (posedge clk);

    end

    fetch fetch(.active(active), .clk(clk), .stall(stall), .PC_Val(PC_Val), .read(read), .byte_en(byteenable), .address(address));

endmodule