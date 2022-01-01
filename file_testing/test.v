module test (

    input logic clk,
    input logic stall

);

reg [31:0] counter;

initial begin
    counter = 0;
end

always @ (posedge clk) begin
    
    if (stall) begin
        counter <= counter;
    end
    else begin
        counter <= counter + 1;
    end

end

endmodule