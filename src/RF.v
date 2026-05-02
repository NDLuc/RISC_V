module regfile (
    input wire clk,
    input wire rst,
    input wire [4:0] raddr_a,
    input wire [4:0] raddr_b,
    input wire [4:0] waddr,
    input wire [31:0] wdata,
    input wire wen,
    output reg [31:0] rdata_a,
    output reg [31:0] rdata_b,
    output wire [31:0] dbg_x1,
    output wire [31:0] dbg_x2,
    output wire [31:0] dbg_x3,
    output wire [31:0] dbg_x4,
    output wire [31:0] dbg_x5,
    output wire [31:0] dbg_x6,
    output wire [31:0] dbg_x7,
    output wire [31:0] dbg_x8,
    output wire [31:0] dbg_x9,
    output wire [31:0] dbg_x10
);
    reg [31:0] regs [0:31];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (wen && (waddr != 5'b0)) begin
            regs[waddr] <= wdata;
        end
    end

    always @(*) begin
        if (raddr_a == 5'd0)
            rdata_a = 32'b0;
        else
            rdata_a = regs[raddr_a];

        if (raddr_b == 5'd0)
            rdata_b = 32'b0;
        else
            rdata_b = regs[raddr_b];
    end

    assign dbg_x1 = regs[5'd1];
    assign dbg_x2 = regs[5'd2];
    assign dbg_x3 = regs[5'd3];
    assign dbg_x4 = regs[5'd4];
    assign dbg_x5 = regs[5'd5];
    assign dbg_x6 = regs[5'd6];
    assign dbg_x7 = regs[5'd7];
    assign dbg_x8 = regs[5'd8];
    assign dbg_x9 = regs[5'd9];
    assign dbg_x10 = regs[5'd10];
endmodule

