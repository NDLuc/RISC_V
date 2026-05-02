module control (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [11:0] imm12,
    output reg reg_wen,
    output reg mem_wen,
    output reg [1:0] a_sel,
    output reg b_sel,
    output reg [1:0] wb_sel,
    output reg [2:0] imm_sel,
    output reg br_un,              
    output reg is_branch,         
    output reg is_jump,             
    output reg is_jalr,            
    output reg halt
);
    always @(*) begin
        // Default values
        reg_wen = 1'b0; mem_wen = 1'b0; a_sel = 2'b00; b_sel = 1'b0;
        wb_sel = 2'b00; imm_sel = 3'b000; br_un = 1'b0; halt = 1'b0;
        is_branch = 0; is_jump = 0; is_jalr = 0;

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
            7'b1100011: begin // Branch BEQ/BNE/BLT/BGE/BLTU/BGEU)
                is_branch = 1;
                a_sel = 2'b00; b_sel = 0; imm_sel = 3'b010;
                case (funct3)
                    3'b110, 3'b111: br_un = 1;   // bltu, bgeu
                    default:        br_un = 0;
                endcase
            end
            7'b1101111: begin // jal
                reg_wen = 1'b1; a_sel = 2'b01; b_sel = 1'b1; wb_sel = 2'b10; imm_sel = 3'b100; is_jump = 1;
            end
            7'b1100111: begin // jalr
                reg_wen = 1'b1; a_sel = 2'b00; b_sel = 1'b1; wb_sel = 2'b10; imm_sel = 3'b000; is_jump = 1; is_jalr = 1;
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
            default: begin
                reg_wen = 0; mem_wen = 0;
            end
        endcase
    end
endmodule

