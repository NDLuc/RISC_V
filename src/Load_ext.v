module load_ext (
    input wire [31:0] mem_data,
    input wire [1:0] addr,
    input wire [2:0] funct3,
    output reg [31:0] result
);

    always @(*) begin
        case (funct3)
            3'b000: result = {{24{mem_data[7]}},  mem_data[7:0]};   // lb
            3'b001: result = {{16{mem_data[15]}}, mem_data[15:0]};  // lh
            3'b010: result = mem_data;                               // lw
            3'b100: result = {24'b0, mem_data[7:0]};                // lbu
            3'b101: result = {16'b0, mem_data[15:0]};               // lhu
            default: result = mem_data;
        endcase
    end
endmodule

