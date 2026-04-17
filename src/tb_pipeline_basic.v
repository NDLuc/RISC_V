module tb_pipeline_basic;
    reg clk, rst;

    pipeline_basic_top uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #15 rst = 0;
        #1000;

        $display("\n=== FINAL (dbg regs) ===");
        $display("x1  = %0d (0x%h)", uut.regfile_inst.dbg_x1,  uut.regfile_inst.dbg_x1);
        $display("x2  = %0d (0x%h)", uut.regfile_inst.dbg_x2,  uut.regfile_inst.dbg_x2);
        $display("x3  = %0d (0x%h)", uut.regfile_inst.dbg_x3,  uut.regfile_inst.dbg_x3);
        $display("x4  = %0d (0x%h)", uut.regfile_inst.dbg_x4,  uut.regfile_inst.dbg_x4);
        $display("x5  = %0d (0x%h)", uut.regfile_inst.dbg_x5,  uut.regfile_inst.dbg_x5);
        $display("x6  = %0d (0x%h)", uut.regfile_inst.dbg_x6,  uut.regfile_inst.dbg_x6);
        $display("x7  = %0d (0x%h)", uut.regfile_inst.dbg_x7,  uut.regfile_inst.dbg_x7);
        $display("x8  = %0d (0x%h)", uut.regfile_inst.dbg_x8,  uut.regfile_inst.dbg_x8);
        $display("x9  = %0d (0x%h)", uut.regfile_inst.dbg_x9,  uut.regfile_inst.dbg_x9);
        $display("x10 = %0d (0x%h)", uut.regfile_inst.dbg_x10, uut.regfile_inst.dbg_x10);

        $finish;
    end

    // Monitor PC and instruction fetch
    initial begin
        $monitor("t=%0t PC=0x%h instr_if=0x%h", $time, uut.PC, uut.inst_if);
    end

    // Trace WB writes (commit log)
    always @(posedge clk) begin
        if (!rst && uut.RegWEn) begin
            $display("WB: x%0d <= 0x%h (%0d)", uut.rd_wb, uut.wdata, uut.wdata);
        end
    end
endmodule

