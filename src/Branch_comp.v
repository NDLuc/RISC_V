module branch_comp (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire unsign,
    output reg eq,
    output reg lt
);
    always @(*) begin
        eq = (a == b);
        if (unsign)
            lt = (a < b);
        else
            lt = ($signed(a) < $signed(b));
    end
endmodule

