module pipelined_cpu (

    // Base control signals

    input logic clk,
    input logic rst,
    output logic active,

    // For Testbench checking

    output logic[31:0] v0,

    // Avalon Bus

    output logic[31:0] write_data,
    output logic write,
    output logic read,
    output logic byte_en,
    output logic[31:0] address,

    input logic[31:0] read_data,
    input logic waitrequest

);



endmodule