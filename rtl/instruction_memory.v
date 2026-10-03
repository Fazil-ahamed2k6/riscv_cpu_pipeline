module instruction_memory(
    input  wire [31:0] addr,
    output wire [31:0] instruction
);

reg [31:0] memory [0:255];

initial begin
    $readmemh("rtl/program.mem", memory);
end

assign instruction = memory[addr[9:2]];

endmodule
