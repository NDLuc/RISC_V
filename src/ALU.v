module alu (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [4:0] alu_sel,
    output reg [31:0] result
);
    localparam ALU_ADD = 5'b00000, ALU_SUB = 5'b00001, ALU_AND = 5'b00010,
               ALU_OR  = 5'b00011, ALU_XOR = 5'b00100, ALU_SLL = 5'b00101,
               ALU_SRL = 5'b00110, ALU_SRA = 5'b00111, ALU_SLT = 5'b01000,
               ALU_SLTU= 5'b01001, ALU_MUL = 5'b01010;

    wire [4:0] shamt = b[4:0];
    always @(*) begin
        case (alu_sel)
            ALU_ADD:  result = a + b;
            ALU_SUB:  result = a - b;
            ALU_AND:  result = a & b;
            ALU_OR:   result = a | b;
            ALU_XOR:  result = a ^ b;
            ALU_SLL:  result = a << shamt;
            ALU_SRL:  result = a >> shamt;
            ALU_SRA:  result = $signed(a) >>> shamt;
            ALU_SLT:  result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0;
            ALU_SLTU: result = (a < b) ? 32'b1 : 32'b0;
            ALU_MUL:  result = a * b;
            default:  result = 32'b0;
        endcase
    end
endmodule


