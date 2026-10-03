module if_id_reg(
    input wire clk,
    input wire rst,
    input wire flush,
    input wire enable,
    input wire [31:0] pc_in,
    input wire [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);

always @(posedge clk) begin
    if (rst || flush) begin
        pc_out          <= 32'b0;
        instruction_out <= 32'b0;
    end
    else if (enable) begin
        pc_out          <= pc_in;
        instruction_out <= instruction_in;
    end
end

endmodule


module id_ex_reg(
    input wire clk,
    input wire rst,
    input wire flush,

    input wire [31:0] pc_in,
    input wire [31:0] read_data1_in,
    input wire [31:0] read_data2_in,
    input wire [31:0] immediate_in,

    input wire [4:0] rs1_in,
    input wire [4:0] rs2_in,
    input wire [4:0] rd_in,

    input wire reg_write_in,
    input wire alu_src_in,
    input wire mem_read_in,
    input wire mem_write_in,
    input wire branch_in,
    input wire branch_ne_in,
    input wire branch_taken_ctrl_in,

    input wire [1:0] pc_sel_in,

    input wire [3:0] alu_control_in,
    input wire [2:0] wb_sel_in,

    output reg [31:0] pc_out,
    output reg [31:0] read_data1_out,
    output reg [31:0] read_data2_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg alu_src_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg branch_out,
    output reg branch_ne_out,
    output reg branch_taken_ctrl_out,

    output reg [1:0] pc_sel_out,

    output reg [3:0] alu_control_out,
    output reg [2:0] wb_sel_out
);

always @(posedge clk) begin
    if (rst || flush) begin
        pc_out          <= 32'b0;
        read_data1_out  <= 32'b0;
        read_data2_out  <= 32'b0;
        immediate_out   <= 32'b0;

        rs1_out         <= 5'b0;
        rs2_out         <= 5'b0;
        rd_out          <= 5'b0;

        reg_write_out   <= 1'b0;
        alu_src_out     <= 1'b0;
        mem_read_out    <= 1'b0;
        mem_write_out   <= 1'b0;
        branch_out      <= 1'b0;
        branch_ne_out   <= 1'b0;
        branch_taken_ctrl_out <= 1'b0;

        pc_sel_out      <= 2'b00;

        alu_control_out <= 4'b0;
        wb_sel_out      <= 3'b0;
    end
    else begin
        pc_out          <= pc_in;
        read_data1_out  <= read_data1_in;
        read_data2_out  <= read_data2_in;
        immediate_out   <= immediate_in;

        rs1_out         <= rs1_in;
        rs2_out         <= rs2_in;
        rd_out          <= rd_in;

        reg_write_out   <= reg_write_in;
        alu_src_out     <= alu_src_in;
        mem_read_out    <= mem_read_in;
        mem_write_out   <= mem_write_in;
        branch_out      <= branch_in;
        branch_ne_out   <= branch_ne_in;
        branch_taken_ctrl_out <= branch_taken_ctrl_in;

        pc_sel_out      <= pc_sel_in;

        alu_control_out <= alu_control_in;
        wb_sel_out      <= wb_sel_in;
    end
end

endmodule


module ex_mem_reg(
    input wire clk,
    input wire rst,

    input wire [31:0] alu_result_in,
    input wire [31:0] pc_plus4_in,
    input wire [31:0] immediate_in,
    input wire [31:0] write_data_in,

    input wire [4:0] rd_in,

    input wire reg_write_in,
    input wire mem_read_in,
    input wire mem_write_in,

    input wire [2:0] wb_sel_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] immediate_out,
    output reg [31:0] write_data_out,

    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,

    output reg [2:0] wb_sel_out
);

always @(posedge clk) begin
    if (rst) begin
        alu_result_out <= 32'b0;
        pc_plus4_out <= 32'b0;
        immediate_out <= 32'b0;
        write_data_out <= 32'b0;
        rd_out         <= 5'b0;

        reg_write_out  <= 1'b0;
        mem_read_out   <= 1'b0;
        mem_write_out  <= 1'b0;

        wb_sel_out     <= 3'b0;
    end
    else begin
        alu_result_out <= alu_result_in;
        pc_plus4_out <= pc_plus4_in;
        immediate_out <= immediate_in;
        write_data_out <= write_data_in;
        rd_out         <= rd_in;

        reg_write_out  <= reg_write_in;
        mem_read_out   <= mem_read_in;
        mem_write_out  <= mem_write_in;

        wb_sel_out     <= wb_sel_in;
    end
end

endmodule


module mem_wb_reg(
    input wire clk,
    input wire rst,

    input wire [31:0] memory_data_in,
    input wire [31:0] alu_result_in,

    input wire [4:0] rd_in,

    input wire reg_write_in,

    input wire [2:0] wb_sel_in,

    output reg [31:0] memory_data_out,
    output reg [31:0] alu_result_out,

    output reg [4:0] rd_out,

    output reg reg_write_out,

    output reg [2:0] wb_sel_out
);

always @(posedge clk) begin
    if (rst) begin
        memory_data_out <= 32'b0;
        alu_result_out  <= 32'b0;
        rd_out          <= 5'b0;

        reg_write_out   <= 1'b0;

        wb_sel_out      <= 3'b0;
    end
    else begin
        memory_data_out <= memory_data_in;
        alu_result_out  <= alu_result_in;
        rd_out          <= rd_in;

        reg_write_out   <= reg_write_in;

        wb_sel_out      <= wb_sel_in;
    end
end

endmodule
