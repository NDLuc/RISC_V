module mem_wb_reg (
    input wire clk,
    input wire rst,
    input wire [31:0] alu_result_mem,
    input wire [31:0] load_data_mem,
    input wire [4:0] rd_addr_mem,
    input wire reg_wen_mem,
    input wire [1:0] wb_sel_mem,
    input wire [31:0] pc_plus_4_mem,
    output reg [31:0] alu_result_wb,
    output reg [31:0] load_data_wb,
    output reg [4:0] rd_addr_wb,
    output reg reg_wen_wb,
    output reg [1:0] wb_sel_wb,
    output reg [31:0] pc_plus_4_wb
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alu_result_wb <= 32'b0; load_data_wb <= 32'b0; rd_addr_wb <= 5'b0;
            reg_wen_wb <= 1'b0; wb_sel_wb <= 2'b0; pc_plus_4_wb <= 32'b0;
        end else begin
            alu_result_wb <= alu_result_mem; load_data_wb <= load_data_mem;
            rd_addr_wb <= rd_addr_mem; reg_wen_wb <= reg_wen_mem;
            wb_sel_wb <= wb_sel_mem; pc_plus_4_wb <= pc_plus_4_mem;
        end
    end
endmodule

