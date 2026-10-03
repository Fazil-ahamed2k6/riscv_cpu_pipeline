module data_memory(

    input wire clk,

    input wire mem_read,
    input wire mem_write,

    input wire [31:0] address,
    input wire [31:0] write_data,

    output wire [31:0] read_data

);

reg [31:0] memory [0:15];

wire [3:0] word_addr;

integer i;


//==================================================
// Word Address
//==================================================

assign word_addr = address[5:2];


//==================================================
// Memory Initialization
//==================================================

initial begin

    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'd0;

    memory[0] = 32'd100;
    memory[1] = 32'd200;

end


//==================================================
// Asynchronous Read
//==================================================

assign read_data =
        mem_read ? memory[word_addr] : 32'b0;


//==================================================
// Synchronous Write
//==================================================

always @(posedge clk) begin

    if (mem_write)
        memory[word_addr] <= write_data;

end

endmodule
