module PC_TB ();

    logic clk;
    logic rst;

    logic[31:0] PC_JVal;
    logic jump_en;
    logic branch_en;
    logic PC_Stall;

    logic [31:0] PC_Out;
    logic fetch_stall;
    logic active;
    logic [2:0] check;

    initial begin

        $dumpfile("PC_TB.vcd");
        $dumpvars(0, PC_TB);

        clk = 0;
        jump_en = 0;
        PC_Stall = 0;
        branch_en = 0;
        rst = 0;
        
        repeat(100) begin
            #50; clk = ~clk;
        end

        $fatal(1, "Timeout");

    end

    initial begin
        
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
        rst = 1;
        @ (posedge clk);
        @ (posedge clk);
        @ (posedge clk);
         rst = 0;
        @ (posedge clk);
        @ (posedge clk);
         @ (posedge clk);
        
        @ (posedge clk);
        PC_Stall = 1;
        @ (posedge clk);
        PC_Stall = 0;
        @ (posedge clk);
        
        

    end

    PC PC(.clk(clk), .rst(rst), .PC_JVal(PC_JVal), .jump_en(jump_en), .branch_en(branch_en), .PC_Stall(PC_Stall), .PC_Out(PC_Out), .fetch_stall(fetch_stall), .active(active), .check(check));

endmodule