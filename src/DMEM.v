module dmem (
    input wire clk,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    input wire wen,
    input wire [2:0] funct3,
    output reg [31:0] rdata
);
    reg [7:0] mem [0:4095];
    integer i;
    initial begin
        for (i = 0; i < 4096; i = i + 1)
            mem[i] = 8'b0;
    end
    always @(*) begin
        rdata = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
    end
    always @(posedge clk) begin
        if (wen) begin
            case (funct3)
                3'b000: mem[addr] <= wdata[7:0];          // sb
                3'b001: begin                             // sh
                    mem[addr]   <= wdata[7:0];
                    mem[addr+1] <= wdata[15:8];
                end
                3'b010: begin                             // sw
                    mem[addr]   <= wdata[7:0];
                    mem[addr+1] <= wdata[15:8];
                    mem[addr+2] <= wdata[23:16];
                    mem[addr+3] <= wdata[31:24];
                end
                default: ;
            endcase
        end
    end
endmodule

