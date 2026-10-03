module register_file(
    input wire clk,
    input wire we,

    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,

    input wire [31:0] write_data,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);


reg [31:0] registers [0:31];

integer i;


initial begin

    for(i=0;i<32;i=i+1)
        registers[i]=32'b0;

end


always @(posedge clk) begin

    if(we && rd!=5'd0)
        registers[rd] <= write_data;

    registers[0] <= 32'b0;

end


assign read_data1 = registers[rs1];

assign read_data2 = registers[rs2];


endmodule
