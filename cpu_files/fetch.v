module fetch (

    input logic active,
    input logic clk,

    input logic[31:0] PC_Val,
    input logic stall,

    // Avalon Bus

    output logic read,
    output logic byte_en,
    output logic[31:0] address

);

always_ff @ (posedge clk) begin
    
    if (stall | ~active) begin
        read <= 0;
        address <= 32'hxxxxxxxx;
    end
    else begin
        read <= 1;
        address <= PC_Val;
    end

end

endmodule