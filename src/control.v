module control (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [11:0] imm12,
    input wire br_eq,
    input wire br_lt,
    output reg reg_wen,
    output reg mem_wen,
    output reg [1:0] a_sel,
    output reg b_sel,
    output reg [1:0] wb_sel,
    output reg pc_sel,
    output reg [2:0] imm_sel,
    output reg br_un,
    output reg halt
);
    always @(*) begin
        // Default values
        reg_wen = 1'b0; mem_wen = 1'b0; a_sel = 2'b00; b_sel = 1'b0;
        wb_sel = 2'b00; pc_sel = 1'b0; imm_sel = 3'b000; br_un = 1'b0; halt = 1'b0;

        case (opcode)
            7'b0110011: begin // R-type
                reg_wen = 1'b1; a_sel = 2'b00; b_sel = 1'b0; wb_sel = 2'b00;
            end
            7'b0010011: begin // I-type (immediate)
                reg_wen = 1'b1; a_sel = 2'b00; b_sel = 1'b1; wb_sel = 2'b00; imm_sel = 3'b000;
            end
            7'b0000011: begin // Load
                reg_wen = 1'b1; a_sel = 2'b00; b_sel = 1'b1; wb_sel = 2'b01; imm_sel = 3'b000;
            end
            7'b0100011: begin // Store
                mem_wen = 1'b1; a_sel = 2'b00; b_sel = 1'b1; imm_sel = 3'b001;
            end
            7'b1100011: begin // Branch
                a_sel = 2'b00; b_sel = 1'b0; imm_sel = 3'b010;
                case (funct3)
                    3'b000: pc_sel = br_eq;           // beq
                    3'b001: pc_sel = ~br_eq;          // bne
                    3'b100: pc_sel = br_lt;           // blt
                    3'b101: pc_sel = ~br_lt;          // bge
                    3'b110: begin br_un = 1'b1; pc_sel = br_lt; end // bltu
                    3'b111: begin br_un = 1'b1; pc_sel = ~br_lt; end // bgeu
                endcase
            end
            7'b1101111: begin // jal
                reg_wen = 1'b1; a_sel = 2'b01; b_sel = 1'b1; wb_sel = 2'b10; pc_sel = 1'b1; imm_sel = 3'b100;
            end
            7'b1100111: begin // jalr
                reg_wen = 1'b1; a_sel = 2'b00; b_sel = 1'b1; wb_sel = 2'b10; pc_sel = 1'b1; imm_sel = 3'b000;
            end
            7'b0010111: begin // auipc
                reg_wen = 1'b1; a_sel = 2'b01; b_sel = 1'b1; wb_sel = 2'b00; imm_sel = 3'b011;
            end
            7'b0110111: begin // lui
                reg_wen = 1'b1; a_sel = 2'b10; b_sel = 1'b1; wb_sel = 2'b00; imm_sel = 3'b011;
            end
            7'b1110011: begin // SYSTEM (ecall/ebreak)
                // ebreak: imm12=0, ecall: imm12=1 (per spec)
                if ((imm12 == 12'h000) || (imm12 == 12'h001))
                    halt = 1'b1;
            end
        endcase
    end
endmodule

