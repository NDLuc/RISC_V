module pipeline_basic_top (
    input wire clk,
    input wire rst
);

    // IF stage

    wire [31:0] PC, PC4_if, NextPC;
    wire [31:0] inst_if;

    pc_reg pc_inst (
        .clk(clk),
        .rst(rst),
        .next_pc(NextPC),
        .pc(PC)
    );

    imem imem_inst (
        .addr(PC),
        .data(inst_if)
    );

    assign PC4_if = PC + 32'd4;


    // IF/ID register

    wire [31:0] PC_id, PC4_id, inst_id;

    if_id_reg if_id_inst (
        .clk(clk),
        .rst(rst),
        .pc_if(PC),
        .pc_plus_4_if(PC4_if),
        .instr_if(inst_if),
        .pc_id(PC_id),
        .pc_plus_4_id(PC4_id),
        .instr_id(inst_id)
    );


    // ID stage

    wire [6:0] opcode = inst_id[6:0];
    wire [2:0] funct3 = inst_id[14:12];
    wire [6:0] funct7 = inst_id[31:25];
    wire [4:0] rs1 = inst_id[19:15];
    wire [4:0] rs2 = inst_id[24:20];
    wire [4:0] rd  = inst_id[11:7];

    // Register file (diagram names)
    wire [31:0] rdata1, rdata2;
    wire [31:0] wdata;
    wire RegWEn;
    wire [4:0] rd_wb;

    regfile regfile_inst (
        .clk(clk),
        .rst(rst),
        .raddr_a(rs1),
        .raddr_b(rs2),
        .waddr(rd_wb),
        .wdata(wdata),
        .wen(RegWEn),
        .rdata_a(rdata1),
        .rdata_b(rdata2)
    );

    // Immediate generator
    wire [31:0] imm;
    wire [2:0] ImmSel;
    immgen immgen_inst (
        .instr(inst_id),
        .imm_sel(ImmSel),
        .imm(imm)
    );

    // Branch comparator
    wire BrEq, BrLT, BrUn;
    branch_comp branch_comp_inst (
        .a(rdata1),
        .b(rdata2),
        .unsign(BrUn),
        .eq(BrEq),
        .lt(BrLT)
    );

    // Main control
    wire RegWEn_id, MemRW_id;
    wire [1:0] ASel_id, WBSel_id;
    wire BSel_id, PCSel_id;
    wire [1:0] alu_op;
    wire halt;
    control control_inst (
        .opcode(opcode),
        .funct3(funct3),
        .imm12(inst_id[31:20]),
        .br_eq(BrEq),
        .br_lt(BrLT),
        .reg_wen(RegWEn_id),
        .mem_wen(MemRW_id),
        .a_sel(ASel_id),
        .b_sel(BSel_id),
        .wb_sel(WBSel_id),
        .pc_sel(PCSel_id),
        .imm_sel(ImmSel),
        .br_un(BrUn),
        .halt(halt)
    );

    // ALUOp (basic mapping)
    // 00: add (load/store/jal/jalr/auipc/lui)
    // 01: sub (branch)
    // 10: use funct3/funct7 (R/I ALU ops)
    assign alu_op = (opcode == 7'b1100011) ? 2'b01 :
                    ((opcode == 7'b0110011) || (opcode == 7'b0010011)) ? 2'b10 :
                    2'b00;

    // ALU control
    wire [4:0] ALUSel_id;
    alu_control alu_control_inst (
        .alu_op(alu_op),
        .is_rtype(opcode == 7'b0110011),
        .funct3(funct3),
        .funct7(funct7),
        .alu_sel(ALUSel_id)
    );


    // ID/EX register

    wire [31:0] PC_ex, PC4_ex, rdata1_ex, rdata2_ex, imm_ex;
    wire [4:0] rd_ex, rs1_ex, rs2_ex;
    wire [2:0] funct3_ex;
    wire RegWEn_ex, MemRW_ex, BSel_ex, PCSel_ex;
    wire jalr_ex;
    wire [1:0] ASel_ex, WBSel_ex;
    wire [4:0] ALUSel_ex;
    wire jalr_id = (opcode == 7'b1100111);

    id_ex_reg id_ex_inst (
        .clk(clk),
        .rst(rst),
        .pc_id(PC_id),
        .pc_plus_4_id(PC4_id),
        .reg_a_id(rdata1),
        .reg_b_id(rdata2),
        .imm_id(imm),
        .rd_addr_id(rd),
        .rs1_addr_id(rs1),
        .rs2_addr_id(rs2),
        .funct3_id(funct3),
        .reg_wen_id(RegWEn_id),
        .mem_wen_id(MemRW_id),
        .b_sel_id(BSel_id),
        .pc_sel_id(PCSel_id),
        .jalr_id(jalr_id),
        .a_sel_id(ASel_id),
        .wb_sel_id(WBSel_id),
        .alu_sel_id(ALUSel_id),
        .pc_ex(PC_ex),
        .pc_plus_4_ex(PC4_ex),
        .reg_a_ex(rdata1_ex),
        .reg_b_ex(rdata2_ex),
        .imm_ex(imm_ex),
        .rd_addr_ex(rd_ex),
        .rs1_addr_ex(rs1_ex),
        .rs2_addr_ex(rs2_ex),
        .funct3_ex(funct3_ex),
        .reg_wen_ex(RegWEn_ex),
        .mem_wen_ex(MemRW_ex),
        .b_sel_ex(BSel_ex),
        .pc_sel_ex(PCSel_ex),
        .jalr_ex(jalr_ex),
        .a_sel_ex(ASel_ex),
        .wb_sel_ex(WBSel_ex),
        .alu_sel_ex(ALUSel_ex)
    );


    // EX stage

    wire [31:0] alu_a = (ASel_ex == 2'b00) ? rdata1_ex :
                        (ASel_ex == 2'b01) ? PC_ex : 32'b0;
    wire [31:0] alu_b = BSel_ex ? imm_ex : rdata2_ex;

    wire [31:0] ALUOut_ex;
    alu alu_inst (
        .a(alu_a),
        .b(alu_b),
        .alu_sel(ALUSel_ex),
        .result(ALUOut_ex)
    );

    wire [31:0] branch_target = PC_ex + imm_ex;
    wire [31:0] jalr_target = (rdata1_ex + imm_ex) & 32'hffff_fffe;
    wire [31:0] pc_target = jalr_ex ? jalr_target : branch_target;
    assign NextPC = halt ? PC : (PCSel_ex ? pc_target : PC4_if);


    // EX/MEM register

    wire [31:0] ALUOut_mem, rdata2_mem, PC4_mem;
    wire [4:0] rd_mem;
    wire RegWEn_mem, MemRW_mem;
    wire [1:0] WBSel_mem;
    wire [2:0] funct3_mem;

    ex_mem_reg ex_mem_inst (
        .clk(clk),
        .rst(rst),
        .alu_result_ex(ALUOut_ex),
        .reg_b_ex(rdata2_ex),
        .rd_addr_ex(rd_ex),
        .reg_wen_ex(RegWEn_ex),
        .mem_wen_ex(MemRW_ex),
        .wb_sel_ex(WBSel_ex),
        .funct3_ex(funct3_ex),
        .pc_plus_4_ex(PC4_ex),
        .alu_result_mem(ALUOut_mem),
        .reg_b_mem(rdata2_mem),
        .rd_addr_mem(rd_mem),
        .reg_wen_mem(RegWEn_mem),
        .mem_wen_mem(MemRW_mem),
        .wb_sel_mem(WBSel_mem),
        .funct3_mem(funct3_mem),
        .pc_plus_4_mem(PC4_mem)
    );


    // MEM stage

    wire [31:0] MemReadData;
    dmem dmem_inst (
        .clk(clk),
        .addr(ALUOut_mem),
        .wdata(rdata2_mem),
        .wen(MemRW_mem),
        .funct3(funct3_mem),
        .rdata(MemReadData)
    );

    wire [31:0] LoadData;
    load_ext load_ext_inst (
        .mem_data(MemReadData),
        .addr(ALUOut_mem[1:0]),
        .funct3(funct3_mem),
        .result(LoadData)
    );


    // MEM/WB register

    wire [31:0] ALUOut_wb, LoadData_wb, PC4_wb;
    wire RegWEn_wb;
    wire [1:0] WBSel_wb;

    mem_wb_reg mem_wb_inst (
        .clk(clk),
        .rst(rst),
        .alu_result_mem(ALUOut_mem),
        .load_data_mem(LoadData),
        .rd_addr_mem(rd_mem),
        .reg_wen_mem(RegWEn_mem),
        .wb_sel_mem(WBSel_mem),
        .pc_plus_4_mem(PC4_mem),
        .alu_result_wb(ALUOut_wb),
        .load_data_wb(LoadData_wb),
        .rd_addr_wb(rd_wb),
        .reg_wen_wb(RegWEn_wb),
        .wb_sel_wb(WBSel_wb),
        .pc_plus_4_wb(PC4_wb)
    );


    // WB stage

    assign wdata = (WBSel_wb == 2'b00) ? ALUOut_wb :
                   (WBSel_wb == 2'b01) ? LoadData_wb : PC4_wb;
    assign RegWEn = RegWEn_wb;
    // rd_wb already drives regfile write address

endmodule

