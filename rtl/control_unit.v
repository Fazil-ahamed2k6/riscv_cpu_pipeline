module control_unit(

    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,

    output reg reg_write,
    output reg alu_src,
    output reg mem_read,
    output reg mem_write,

    output reg branch,
    output reg branch_ne,

    output reg [3:0] alu_control,
    output reg [2:0] wb_sel,
    output reg [1:0] pc_sel,

    output reg use_rs1,
    output reg use_rs2

, output wire branch_taken_ctrl);



wire branch_dec;
wire branch_ne_dec;

assign branch_dec =
    (opcode == 7'b1100011) &&
    (funct3 == 3'b000);

assign branch_ne_dec =
    (opcode == 7'b1100011) &&
    (funct3 == 3'b001);

always @(*) begin

    //--------------------------------------------------
    // Default values
    //--------------------------------------------------

    reg_write   = 1'b0;
    alu_src     = 1'b0;
    mem_read    = 1'b0;
    mem_write   = 1'b0;

    branch      = branch_dec;
    branch_ne   = branch_ne_dec;

    alu_control = 4'b0000;

    // Write-back selection
    // 000 = ALU result
    // 001 = Memory data
    // 010 = PC + 4
    // 011 = Immediate
    // 100 = PC + Immediate

    wb_sel = 3'b000;

    // PC selection
    // 00 = PC + 4
    // 01 = PC + Immediate
    // 10 = JALR target

    pc_sel = 2'b00;

    use_rs1 = 1'b0;
    use_rs2 = 1'b0;


    //--------------------------------------------------
    // Opcode Decode
    //--------------------------------------------------

    case (opcode)

        //--------------------------------------------------
        // R-Type
        //--------------------------------------------------
        7'b0110011: begin

            reg_write = 1'b1;
            use_rs1   = 1'b1;
            use_rs2   = 1'b1;

            case (funct3)

                3'b000:
                    alu_control = funct7[5] ? 4'b0001 : 4'b0000;
                    // SUB : ADD

                3'b111:
                    alu_control = 4'b0010;
                    // AND

                3'b110:
                    alu_control = 4'b0011;
                    // OR

                3'b100:
                    alu_control = 4'b0100;
                    // XOR

                3'b001:
                    alu_control = 4'b0101;
                    // SLL

                3'b101:
                    alu_control = funct7[5] ? 4'b1000 : 4'b0110;
                    // SRA : SRL

                3'b010:
                    alu_control = 4'b0111;
                    // SLT

                default:
                    alu_control = 4'b0000;

            endcase

        end


        //--------------------------------------------------
        // I-Type ALU
        //--------------------------------------------------
        7'b0010011: begin

            reg_write = 1'b1;
            use_rs1   = 1'b1;
            alu_src   = 1'b1;

            case (funct3)

                3'b000:
                    alu_control = 4'b0000;
                    // ADDI

                3'b100:
                    alu_control = 4'b0100;
                    // XORI

                3'b010:
                    alu_control = 4'b0111;
                    // SLTI

                3'b001:
                    alu_control = 4'b0101;
                    // SLLI

                3'b101:
                    alu_control = funct7[5] ? 4'b1000 : 4'b0110;
                    // SRAI : SRLI

                default:
                    alu_control = 4'b0000;

            endcase

        end


        //--------------------------------------------------
        // LOAD WORD
        //--------------------------------------------------
        7'b0000011: begin

            reg_write = 1'b1;
            use_rs1   = 1'b1;
            alu_src   = 1'b1;
            mem_read  = 1'b1;

            wb_sel = 3'b001;

            alu_control = 4'b0000;

        end


        //--------------------------------------------------
        // STORE WORD
        //--------------------------------------------------
        7'b0100011: begin

            use_rs1   = 1'b1;
            use_rs2   = 1'b1;

            alu_src   = 1'b1;
            mem_write = 1'b1;

            alu_control = 4'b0000;

        end


        //--------------------------------------------------
        // BRANCH
        //--------------------------------------------------
        7'b1100011: begin

            use_rs1 = 1'b1;
            use_rs2 = 1'b1;

            alu_control = 4'b0001;
            // SUB

            case (funct3)

                3'b000: begin
                    pc_sel = 2'b01;
                end

                3'b001: begin
                    pc_sel = 2'b01;
                end

                default: begin
                    pc_sel = 2'b00;
                end

            endcase

        end


        //--------------------------------------------------
        // JAL
        //--------------------------------------------------
        7'b1101111: begin

            reg_write = 1'b1;

            wb_sel = 3'b010;
            pc_sel = 2'b01;

        end


        //--------------------------------------------------
        // JALR
        //--------------------------------------------------
        7'b1100111: begin

            reg_write = 1'b1;
            use_rs1   = 1'b1;
            alu_src   = 1'b1;

            wb_sel = 3'b010;
            pc_sel = 2'b10;

            alu_control = 4'b0000;

        end


        //--------------------------------------------------
        // LUI
        //--------------------------------------------------
        7'b0110111: begin

            reg_write = 1'b1;

            wb_sel = 3'b011;

        end


        //--------------------------------------------------
        // AUIPC
        //--------------------------------------------------
        7'b0010111: begin

            reg_write = 1'b1;

            wb_sel = 3'b100;

        end


        //--------------------------------------------------
        // Unsupported instruction
        //--------------------------------------------------
        default: begin

            // Keep default values

        end

    endcase

end

assign branch_taken_ctrl = branch | branch_ne;
endmodule
