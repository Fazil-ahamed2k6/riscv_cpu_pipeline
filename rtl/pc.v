module pc (
    input wire        clk,
    input wire        rst,
    input wire        enable,
    input wire [31:0] pc_next,
    output reg [31:0] pc
);

always @(posedge clk) begin
    if (rst)
        pc <= 32'h00000000;
    else if (enable)
        pc <= pc_next;
end

endmodule

