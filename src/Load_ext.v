module load_ext (
    input wire [31:0] mem_data,
    input wire [1:0] addr,
    input wire [2:0] funct3,
    output reg [31:0] result
);
    wire [7:0] byte0 = mem_data[7:0];
    wire [7:0] byte1 = mem_data[15:8];
    wire [7:0] byte2 = mem_data[23:16];
    wire [7:0] byte3 = mem_data[31:24];
    wire [15:0] half0 = mem_data[15:0];
    wire [15:0] half1 = mem_data[31:16];

    always @(*) begin
        case (funct3)
            3'b000: // lb
                case (addr)
                    2'b00: result = {{24{byte0[7]}}, byte0};
                    2'b01: result = {{24{byte1[7]}}, byte1};
                    2'b10: result = {{24{byte2[7]}}, byte2};
                    2'b11: result = {{24{byte3[7]}}, byte3};
                endcase
            3'b001: // lh
                case (addr[1])
                    1'b0: result = {{16{half0[15]}}, half0};
                    1'b1: result = {{16{half1[15]}}, half1};
                endcase
            3'b010: // lw
                result = mem_data;
            3'b100: // lbu
                case (addr)
                    2'b00: result = {24'b0, byte0};
                    2'b01: result = {24'b0, byte1};
                    2'b10: result = {24'b0, byte2};
                    2'b11: result = {24'b0, byte3};
                endcase
            3'b101: // lhu
                case (addr[1])
                    1'b0: result = {16'b0, half0};
                    1'b1: result = {16'b0, half1};
                endcase
            default: result = mem_data;
        endcase
    end
endmodule

