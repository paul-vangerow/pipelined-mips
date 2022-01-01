module fetch (

    input logic active,
    input logic clk,

    input logic[31:0] PC_Val,
    input logic stall,

    // Avalon Bus

    output logic read,
    output logic [3:0] byte_en,
    output logic[31:0] address

);

assign address = (stall == 1 | PC_Val == 0) ? 32'hxxxxxxxx : PC_Val;
assign read = ~(stall == 1 | PC_Val == 0);
assign byte_en = (stall == 1 | PC_Val == 0) ? 4'b0000 : 4'b1111;

endmodule