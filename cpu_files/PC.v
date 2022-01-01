module PC (

    input logic clk,
    input logic rst,

    input logic[31:0] PC_JVal,
    input logic jump_en,
    input logic branch_en,
    input logic PC_Stall,

    output logic [31:0] PC_Out,
    output logic fetch_stall,

    output logic active

);

// Active is completely dependent on the value of the PC.

// JUMP_EN --> PC = JVAL
// BRANCH_EN --> PC = PC + JVAL
// PC_Stall --> PC = PC

logic [31:0] PC;
logic [31:0] branchSignExt;
logic start;

assign fetch_stall = PC_Stall;
assign active = (PC != 0) ? 1 : 0;
assign branchSignExt = (PC_JVal[15] == 1) ? {16'hFFFF, PC_JVal[15:0]} : {16'h0000, PC_JVal[15:0]};

assign PC_Out = (active == 0) ? 0 : ( (PC_Stall == 1) ? PC : ( (jump_en == 1) ? PC_JVal : ( (branch_en == 1) ? PC + branchSignExt : PC + 4 ) ) );

initial begin

    start = 0;
    PC = 0;

end

always @ (posedge clk) begin

    if (rst) begin
        start <= 1;
    end 
    else if (active) begin
        PC <= PC_Out;
    end

end

always @ (negedge rst) begin

   if (start) begin
       PC <= 32'hBFBFFFFC;
       start <= 0;
   end 
end

endmodule

