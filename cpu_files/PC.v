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

reg [31:0] PC;
logic [31:0] branchSignExt = (PC_JVal[15] == 1) ? {16'hFFFF, PC_JVal[15:0]} : {16'h0000, PC_JVal[15:0]};

assign fetch_stall = PC_Stall;
assign active = (PC != 0) ? 1 : 0;

assign PC_Out = (active == 0 || rst == 1) ? 0 : ( (PC_Stall == 1) ? PC + 4 : ( (jump_en == 1) ? PC_JVal : ( (branch_en == 1) ? PC + branchSignExt : PC + 4 ) ) );

initial begin

    PC = 0;

end

always_ff @ (posedge clk) begin

    if (rst) begin
        PC <= 32'hBFBFFFFC;
    end 
    else if (active) begin
        
        if (PC_Stall) begin
            PC <= PC;
        end
        else if (jump_en) begin
            PC <= PC_JVal;
        end
        else if (branch_en) begin
            PC <= PC + branchSignExt;
        end
        else begin
            PC <= PC + 4;
        end

    end

end

endmodule