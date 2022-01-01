module register_tb();

    logic clk;
    logic [4:0] address_read1;
    logic [4:0] address_read2;
    logic [4:0] address_write;

    logic [31:0] write_data;
    logic [31:0] read_data1;
    logic [31:0] read_data2;

    logic write_en;

    initial begin

        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);
        
        clk = 0;

        repeat(100) begin
            #10; clk = ~clk;
        end 

    end

    initial begin

        write_en = 0;
        address_read2 = 1;
        address_read1 = 0;
        
        @ (posedge clk);

        write_en = 1;
        address_write = 0;
        write_data = 32'hFFAAFFAA;

        @ (posedge clk);

        address_write = 1;
        write_data = 32'h12345678;
        
        @ (posedge clk);
        @ (posedge clk);

    end

    register_file register_file (.clk(clk), 
                                .address_read1(address_read1), 
                                .address_read2(address_read2), 
                                .address_write(address_write), 
                                .write_data(write_data), 
                                .read_data1(read_data1),
                                .read_data2(read_data2),
                                .write_en(write_en));

endmodule