module ex_mem_reg (
    input wire clk,
    input wire rst,
    input wire [31:0] alu_result_ex,
    input wire [31:0] reg_b_ex,
    input wire [4:0] rd_addr_ex,
    input wire reg_wen_ex,
    input wire mem_wen_ex,
    input wire [1:0] wb_sel_ex,
    input wire [2:0] funct3_ex,
    input wire [31:0] pc_plus_4_ex,
    output reg [31:0] alu_result_mem,
    output reg [31:0] reg_b_mem,
    output reg [4:0] rd_addr_mem,
    output reg reg_wen_mem,
    output reg mem_wen_mem,
    output reg [1:0] wb_sel_mem,
    output reg [2:0] funct3_mem,
    output reg [31:0] pc_plus_4_mem
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_result_mem <= 32'b0; reg_b_mem <= 32'b0; rd_addr_mem <= 5'b0;
            reg_wen_mem <= 1'b0; mem_wen_mem <= 1'b0; wb_sel_mem <= 2'b0;
            funct3_mem <= 3'b0; pc_plus_4_mem <= 32'b0;
        end else begin
            alu_result_mem <= alu_result_ex; reg_b_mem <= reg_b_ex;
            rd_addr_mem <= rd_addr_ex; reg_wen_mem <= reg_wen_ex;
            mem_wen_mem <= mem_wen_ex; wb_sel_mem <= wb_sel_ex;
            funct3_mem <= funct3_ex; pc_plus_4_mem <= pc_plus_4_ex;
        end
    end
endmodule

