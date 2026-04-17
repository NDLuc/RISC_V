module imem (
    input wire [31:0] addr,
    output reg [31:0] data
);
    reg [31:0] mem [0:1023]; 
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            mem[i] = 32'b0;
        // $readmemh("C:/Users/PC/Downloads/KTMT/RISCV/program.hex", mem);
        $readmemh("program.hex", mem);
    end
    always @(*) begin
        data = mem[addr[31:2]];
    end
endmodule

