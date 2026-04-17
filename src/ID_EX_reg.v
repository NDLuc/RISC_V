module id_ex_reg (
    input wire clk, rst,
    input wire [31:0] pc_id, pc_plus_4_id, reg_a_id, reg_b_id, imm_id,
    input wire [4:0] rd_addr_id, rs1_addr_id, rs2_addr_id,
    input wire [2:0] funct3_id,
    input wire reg_wen_id, mem_wen_id, b_sel_id, pc_sel_id,
    input wire jalr_id,
    input wire [1:0] a_sel_id, wb_sel_id,
    input wire [4:0] alu_sel_id,
    output reg [31:0] pc_ex, pc_plus_4_ex, reg_a_ex, reg_b_ex, imm_ex,
    output reg [4:0] rd_addr_ex, rs1_addr_ex, rs2_addr_ex,
    output reg [2:0] funct3_ex,
    output reg reg_wen_ex, mem_wen_ex, b_sel_ex, pc_sel_ex,
    output reg jalr_ex,
    output reg [1:0] a_sel_ex, wb_sel_ex,
    output reg [4:0] alu_sel_ex
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_ex <= 0; pc_plus_4_ex <= 0; reg_a_ex <= 0; reg_b_ex <= 0; imm_ex <= 0;
            rd_addr_ex <= 0; rs1_addr_ex <= 0; rs2_addr_ex <= 0; funct3_ex <= 0;
            reg_wen_ex <= 0; mem_wen_ex <= 0; b_sel_ex <= 0; pc_sel_ex <= 0; jalr_ex <= 0;
            a_sel_ex <= 0; wb_sel_ex <= 0; alu_sel_ex <= 0;
        end else begin
            pc_ex <= pc_id; pc_plus_4_ex <= pc_plus_4_id;
            reg_a_ex <= reg_a_id; reg_b_ex <= reg_b_id; imm_ex <= imm_id;
            rd_addr_ex <= rd_addr_id; rs1_addr_ex <= rs1_addr_id; rs2_addr_ex <= rs2_addr_id;
            funct3_ex <= funct3_id;
            reg_wen_ex <= reg_wen_id; mem_wen_ex <= mem_wen_id;
            b_sel_ex <= b_sel_id; pc_sel_ex <= pc_sel_id; jalr_ex <= jalr_id;
            a_sel_ex <= a_sel_id; wb_sel_ex <= wb_sel_id; alu_sel_ex <= alu_sel_id;
        end
    end
endmodule

