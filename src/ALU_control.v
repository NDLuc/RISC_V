module alu_control (
    input wire [1:0] alu_op,
    input wire is_rtype,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [4:0] alu_sel
);
    localparam ALU_ADD = 5'b00000, ALU_SUB = 5'b00001, ALU_AND = 5'b00010,
               ALU_OR  = 5'b00011, ALU_XOR = 5'b00100, ALU_SLL = 5'b00101,
               ALU_SRL = 5'b00110, ALU_SRA = 5'b00111, ALU_SLT = 5'b01000,
               ALU_SLTU= 5'b01001, ALU_MUL = 5'b01010;

    always @(*) begin
        case (alu_op)
            2'b00: alu_sel = ALU_ADD;
            2'b01: alu_sel = ALU_SUB;
            2'b10: begin
                case (funct3)
                    // R-type: funct7 distinguishes add/sub and enables mul (M-ext)
                    // I-type: funct7 is part of the immediate, so do NOT treat it as sub.
                    3'b000: begin
                        if (is_rtype && (funct7 == 7'b0000001)) alu_sel = ALU_MUL;      // mul
                        else if (is_rtype && (funct7 == 7'b0100000)) alu_sel = ALU_SUB; // sub
                        else alu_sel = ALU_ADD;                                         // add/addi
                    end
                    3'b001: alu_sel = ALU_SLL;
                    3'b010: alu_sel = ALU_SLT;
                    3'b011: alu_sel = ALU_SLTU;
                    3'b100: alu_sel = ALU_XOR;
                    3'b101: alu_sel = (funct7 == 7'b0000000) ? ALU_SRL : ALU_SRA;
                    3'b110: alu_sel = ALU_OR;
                    3'b111: alu_sel = ALU_AND;
                    default: alu_sel = ALU_ADD;
                endcase
            end
            default: alu_sel = ALU_ADD;
        endcase
    end
endmodule

