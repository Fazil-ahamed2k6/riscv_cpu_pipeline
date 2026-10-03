`timescale 1ns/1ps

module tb_riscv_pipeline;

    reg clk;
    reg rst;

    riscv_cpu DUT (
        .clk(clk),
        .rst(rst)
    );

    // ============================================================
    // CLOCK
    // ============================================================

    always #5 clk = ~clk;
// No cycle-by-cycle debug






    // ============================================================
    // TEST
    // ============================================================

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        // Reset
        #20;
        rst = 1'b0;

        // Run processor
        #500;


        // ========================================================
        // FINAL REGISTER RESULTS
        // ========================================================

        $display("====================================");
        $display("Pipeline Register Results");

        $display("x1  = %h", DUT.REG_FILE.registers[1]);
        $display("x2  = %h", DUT.REG_FILE.registers[2]);
        $display("x3  = %h", DUT.REG_FILE.registers[3]);
        $display("x4  = %h", DUT.REG_FILE.registers[4]);
        $display("x17 = %h", DUT.REG_FILE.registers[17]);
        $display("x18 = %h", DUT.REG_FILE.registers[18]);
        $display("x19 = %h", DUT.REG_FILE.registers[19]);
        $display("x22 = %h", DUT.REG_FILE.registers[22]);
        $display("x23 = %h", DUT.REG_FILE.registers[23]);
        $display("x24 = %h", DUT.REG_FILE.registers[24]);
        $display("x25 = %h", DUT.REG_FILE.registers[25]);
        $display("x26 = %h", DUT.REG_FILE.registers[26]);
        $display("x27 = %h", DUT.REG_FILE.registers[27]);

        $display("====================================");

        $finish;

    end

endmodule
