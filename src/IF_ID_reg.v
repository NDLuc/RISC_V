module if_id_reg (
    input wire clk, rst,
    input wire flush, 
    input wire [31:0] pc_if, pc_plus_4_if, instr_if,
    output reg [31:0] pc_id, pc_plus_4_id, instr_id
);
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin
            pc_id       <= 32'b0;
            pc_plus_4_id <= 32'b0;
            instr_id    <= 32'h0000_0013;   // NOP = addi x0,x0,0
        end else begin
            pc_id <= pc_if;
            pc_plus_4_id <= pc_plus_4_if;
            instr_id <= instr_if;
        end
    end
endmodule

