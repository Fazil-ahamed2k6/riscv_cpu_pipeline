module riscv_cpu(
    input wire clk,
    input wire rst,


    output wire [31:0] write_back_out
);

    // ============================================================
    // IF STAGE
    // ============================================================

    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] instruction;

    assign pc_next =
        ex_control_taken ? control_target :
                           pc + 32'd4;

    pc PC_UNIT (
        .clk(clk),
        .rst(rst),
        .enable(!stall || ex_control_taken),
        .pc_next(pc_next),
        .pc(pc)
    );

    instruction_memory IMEM (
        .addr(pc),
        .instruction(instruction)
    );


    // ============================================================
    // IF/ID PIPELINE REGISTER
    // ============================================================

    wire [31:0] id_pc;
    wire [31:0] id_instruction;

    if_id_reg IF_ID (
        .clk(clk),
        .rst(rst),
        .flush(ex_control_taken),
        .enable(!stall),

        .pc_in(pc),
        .instruction_in(instruction),

        .pc_out(id_pc),
        .instruction_out(id_instruction)
    );


    // ============================================================
    // ID STAGE
    // ============================================================

    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    assign rs1 = id_instruction[19:15];
    assign rs2 = id_instruction[24:20];
    assign rd  = id_instruction[11:7];


    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file REG_FILE (
        .clk(clk),
        .we(wb_reg_write),

        .rs1(rs1),
        .rs2(rs2),
        .rd(wb_rd),

        .write_data(write_back_data),

        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire branch_ne;
    wire branch_taken_ctrl;

    wire [3:0] alu_control;
    wire [2:0] wb_sel;
    wire [1:0] pc_sel;
    wire use_rs1;
    wire use_rs2;

    control_unit CONTROL (
        .opcode(id_instruction[6:0]),
        .funct3(id_instruction[14:12]),
        .funct7(id_instruction[31:25]),

        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .branch_ne(branch_ne),
        .branch_taken_ctrl(branch_taken_ctrl),

        .alu_control(alu_control),
        .wb_sel(wb_sel),
        .pc_sel(pc_sel),
        .use_rs1(use_rs1),
        .use_rs2(use_rs2)
    );


    wire [31:0] immediate;

    immediate_generator IMM_GEN (
        .instruction(id_instruction),
        .immediate(immediate)
    );


    // ============================================================
    // HAZARD DETECTION
    // ============================================================

    wire stall;

    hazard_unit HAZARD_UNIT (
        .id_rs1(rs1),
        .id_rs2(rs2),

        .use_rs1(use_rs1),
        .use_rs2(use_rs2),

        .id_ex_rd(ex_rd),
        .id_ex_mem_read(ex_mem_read),

        .stall(stall)
    );


    // ============================================================
    // ID/EX PIPELINE REGISTER
    // ============================================================

    wire [31:0] ex_pc;
    wire [31:0] ex_read_data1;
    wire [31:0] ex_read_data2;
    wire [31:0] ex_immediate;

    wire [4:0] ex_rs1;
    wire [4:0] ex_rs2;
    wire [4:0] ex_rd;

    wire ex_reg_write;
    wire ex_alu_src;
    wire ex_mem_read;
    wire ex_mem_write;
    wire ex_branch;
    wire ex_branch_ne;
    wire ex_branch_taken_ctrl;
    wire [1:0] ex_pc_sel;

    wire [3:0] ex_alu_control;
    wire [2:0] ex_wb_sel;

    id_ex_reg ID_EX (
        .clk(clk),
        .rst(rst),
        .flush(stall || ex_control_taken),

        .pc_in(id_pc),
        .read_data1_in(read_data1),
        .read_data2_in(read_data2),
        .immediate_in(immediate),

        .rs1_in(rs1),
        .rs2_in(rs2),
        .rd_in(rd),

        .reg_write_in(reg_write),
        .alu_src_in(alu_src),
        .mem_read_in(mem_read),
        .mem_write_in(mem_write),
        .branch_in(branch),
        .branch_ne_in(branch_ne),
        .branch_taken_ctrl_in(branch_taken_ctrl),

        .pc_sel_in(pc_sel),

        .alu_control_in(alu_control),
        .wb_sel_in(wb_sel),

        .pc_out(ex_pc),
        .read_data1_out(ex_read_data1),
        .read_data2_out(ex_read_data2),
        .immediate_out(ex_immediate),

        .rs1_out(ex_rs1),
        .rs2_out(ex_rs2),
        .rd_out(ex_rd),

        .reg_write_out(ex_reg_write),
        .alu_src_out(ex_alu_src),
        .mem_read_out(ex_mem_read),
        .mem_write_out(ex_mem_write),
        .branch_out(ex_branch),
        .branch_ne_out(ex_branch_ne),
        .branch_taken_ctrl_out(ex_branch_taken_ctrl),

        .pc_sel_out(ex_pc_sel),

        .alu_control_out(ex_alu_control),
        .wb_sel_out(ex_wb_sel)
    );


    // ============================================================
    // FORWARDING UNIT
    // ============================================================

    wire [1:0] forward_a;
    wire [1:0] forward_b;

    forwarding_unit FORWARD_UNIT (
        .id_ex_rs1(ex_rs1),
        .id_ex_rs2(ex_rs2),

        .ex_mem_rd(mem_rd),
        .ex_mem_reg_write(mem_reg_write),
        .mem_wb_rd(wb_rd),
        .mem_wb_reg_write(wb_reg_write),


        .forward_a(forward_a),
        .forward_b(forward_b)
    );


    // ============================================================
    // EX STAGE
    // ============================================================

    reg [31:0] forwarded_operand_a;
    reg [31:0] forwarded_operand_b;

    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire ex_zero;

assign forwarded_operand_a =
    (forward_a == 2'b01) ? mem_alu_result :
    (forward_a == 2'b10) ? write_back_data :
                           ex_read_data1;

assign forwarded_operand_b =
    (forward_b == 2'b01) ? mem_alu_result :
    (forward_b == 2'b10) ? write_back_data :
                           ex_read_data2;


    assign alu_operand_b =
        ex_alu_src ? ex_immediate : forwarded_operand_b;


    alu ALU_UNIT (
        .operand_a(forwarded_operand_a),
        .operand_b(alu_operand_b),
        .alu_control(ex_alu_control),
        .result(alu_result),
        .zero(ex_zero)
    );


    // ============================================================
    // EX CONTROL FLOW
    // ============================================================

    wire [31:0] ex_branch_target;
    wire [31:0] ex_jalr_target;

    wire ex_branch_taken;
    wire ex_control_taken;

    wire [31:0] control_target;

    assign control_target =
        (ex_pc_sel == 2'b10) ? ex_jalr_target :
                               ex_branch_target;

    assign ex_branch_target =
        ex_pc + ex_immediate;

    assign ex_jalr_target =
        (forwarded_operand_a + ex_immediate) & 32'hFFFFFFFE;

    wire ex_operands_equal;
    assign ex_operands_equal =
        (forwarded_operand_a == forwarded_operand_b);

    assign ex_branch_taken =
        (ex_branch && ex_operands_equal) ||
        (ex_branch_ne && !ex_operands_equal);

wire ex_is_jump;
wire ex_is_branch;

assign ex_is_jump =
    (ex_pc_sel == 2'b10) ||
    ((ex_pc_sel == 2'b01) &&
     (!ex_branch && !ex_branch_ne));

assign ex_is_branch =
    ((ex_branch || ex_branch_ne) &&
     ex_branch_taken);

assign ex_control_taken =
    ex_is_jump || ex_is_branch;


    // ============================================================
    // EX WRITEBACK RESULT
    // ============================================================



    // ============================================================
    // EX/MEM PIPELINE REGISTER
    // ============================================================

    wire [31:0] mem_alu_result;
    wire [31:0] mem_pc_plus4;
    wire [31:0] mem_immediate;
    wire [31:0] mem_write_data;

    wire [4:0] mem_rd;

    wire mem_reg_write;
    wire mem_mem_read;
    wire mem_mem_write;

    wire [2:0] mem_wb_sel;

    ex_mem_reg EX_MEM (
        .clk(clk),
        .rst(rst),

        .alu_result_in(alu_result),

        .pc_plus4_in(ex_pc + 32'd4),
        .immediate_in(ex_immediate),

        // Store data uses forwarded value
        .write_data_in(forwarded_operand_b),

        .rd_in(ex_rd),

        .reg_write_in(ex_reg_write),
        .mem_read_in(ex_mem_read),
        .mem_write_in(ex_mem_write),

        .wb_sel_in(ex_wb_sel),

        .alu_result_out(mem_alu_result),
        .pc_plus4_out(mem_pc_plus4),
        .immediate_out(mem_immediate),
        .write_data_out(mem_write_data),

        .rd_out(mem_rd),

        .reg_write_out(mem_reg_write),
        .mem_read_out(mem_mem_read),
        .mem_write_out(mem_mem_write),

        .wb_sel_out(mem_wb_sel)
    );


    // ============================================================
    // MEM STAGE
    // ============================================================

    wire [31:0] memory_data;

    data_memory DMEM (
        .clk(clk),
        .mem_read(mem_mem_read),
        .mem_write(mem_mem_write),
        .address(mem_alu_result),
        .write_data(mem_write_data),
        .read_data(memory_data)
    );


    // ============================================================
    // MEM/WB PIPELINE REGISTER
    // ============================================================

    wire [31:0] wb_memory_data;
    wire [31:0] wb_alu_result;

    wire [4:0] wb_rd;
    wire wb_reg_write;
    wire [2:0] wb_wb_sel;

    mem_wb_reg MEM_WB (
        .clk(clk),
        .rst(rst),

        .memory_data_in(memory_data),
        .alu_result_in(mem_alu_result),

        .rd_in(mem_rd),

        .reg_write_in(mem_reg_write),

        .wb_sel_in(mem_wb_sel),

        .memory_data_out(wb_memory_data),
        .alu_result_out(wb_alu_result),

        .rd_out(wb_rd),

        .reg_write_out(wb_reg_write),

        .wb_sel_out(wb_wb_sel)
    );


    // ============================================================
    // WB STAGE
    // ============================================================

    wire [31:0] write_back_data;

    assign write_back_data =
        (wb_wb_sel == 3'b001) ? wb_memory_data :
                                wb_alu_result;


    // ============================================================
    // TOP-LEVEL OBSERVABLE OUTPUTS
    // ============================================================

    assign write_back_out  = write_back_data;

endmodule
