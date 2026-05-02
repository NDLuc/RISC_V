module id_ex_reg (
    input wire clk, rst,
    input wire flush,
    input wire [31:0] pc_id, pc_plus_4_id, reg_a_id, reg_b_id, imm_id,
    input wire [4:0] rd_addr_id, rs1_addr_id, rs2_addr_id,
    input wire [2:0] funct3_id,
    input wire reg_wen_id, mem_wen_id, b_sel_id,
    input wire [1:0] a_sel_id, wb_sel_id,
    input wire [4:0] alu_sel_id,
    input wire br_un_id,
    input wire is_branch_id,
    input wire is_jump_id,
    input wire is_jalr_id,
    
    output reg [31:0] pc_ex, pc_plus_4_ex, reg_a_ex, reg_b_ex, imm_ex,
    output reg [4:0] rd_addr_ex, rs1_addr_ex, rs2_addr_ex,
    output reg [2:0] funct3_ex,
    output reg reg_wen_ex, mem_wen_ex, b_sel_ex,
    output reg [1:0] a_sel_ex, wb_sel_ex,
    output reg [4:0] alu_sel_ex

    output reg br_un_ex,
    output reg is_branch_ex,
    output reg is_jump_ex,
    output reg is_jalr_ex
);
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            // Insert NOP bubble
            pc_ex        <= 0; pc_plus_4_ex <= 0;
            reg_a_ex     <= 0; reg_b_ex     <= 0; imm_ex       <= 0;
            rd_addr_ex   <= 0; rs1_addr_ex  <= 0; rs2_addr_ex  <= 0;
            funct3_ex    <= 0;
            reg_wen_ex   <= 0; mem_wen_ex   <= 0; b_sel_ex     <= 0;
            a_sel_ex     <= 0; wb_sel_ex    <= 0; alu_sel_ex   <= 0;
            br_un_ex     <= 0; is_branch_ex <= 0;
            is_jump_ex   <= 0; is_jalr_ex   <= 0;
        end else begin
            pc_ex        <= pc_id;        pc_plus_4_ex <= pc_plus_4_id;
            reg_a_ex     <= reg_a_id;     reg_b_ex     <= reg_b_id;
            imm_ex       <= imm_id;
            rd_addr_ex   <= rd_addr_id;   rs1_addr_ex  <= rs1_addr_id;
            rs2_addr_ex  <= rs2_addr_id;  funct3_ex    <= funct3_id;
            reg_wen_ex   <= reg_wen_id;   mem_wen_ex   <= mem_wen_id;
            b_sel_ex     <= b_sel_id;     a_sel_ex     <= a_sel_id;
            wb_sel_ex    <= wb_sel_id;    alu_sel_ex   <= alu_sel_id;
            br_un_ex     <= br_un_id;
            is_branch_ex <= is_branch_id;
            is_jump_ex   <= is_jump_id;
            is_jalr_ex   <= is_jalr_id;
        end
    end
endmodule

