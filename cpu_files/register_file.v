module register_file (

    input logic clk,

    input logic [4:0] address_read1,
    input logic [4:0] address_write,
    input logic [4:0] address_read2,

    input logic [31:0] write_data,
    input logic write_en,

    output logic [31:0] read_data1,
    output logic [31:0] read_data2

);

// Register File

logic [31:0] regfile [31:0];

assign read_data1 = regfile[address_read1];
assign read_data2 = regfile[address_read2];

always @ (posedge clk) begin
    if (write_en) begin
        regfile[address_write] <= write_data;
    end
end

endmodule