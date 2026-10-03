module hazard_unit(
    input wire [4:0] id_rs1,
    input wire [4:0] id_rs2,

    input wire       use_rs1,
    input wire       use_rs2,

    input wire [4:0] id_ex_rd,
    input wire       id_ex_mem_read,

    output reg       stall
);

always @(*) begin
    stall = 1'b0;

    if (id_ex_mem_read &&
        (id_ex_rd != 5'b0) &&
        ((use_rs1 && (id_ex_rd == id_rs1)) ||
         (use_rs2 && (id_ex_rd == id_rs2))))
        stall = 1'b1;
end

endmodule
