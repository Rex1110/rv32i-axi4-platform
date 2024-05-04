`include "../include/define.svh"
`include "./id_ex.sv"
`include "./forward.sv"
`include "./alu.sv"
`include "./bju.sv"
module exu(
    input                   clk,
    input                   rst,
    
    // forward
    input           [ 4:0]  i_wb_rd_addr,
    input           [31:0]  i_wb_rd_data,
    input                   i_wb_rd_wr,
    input           [ 4:0]  i_mem_rd_addr,
    input           [31:0]  i_mem_rd_data,
    input                   i_mem_rd_wr,


    input           [ 5:0]  i_mnemonic,
    input           [31:0]  i_rs1_data,
    input           [31:0]  i_rs2_data,
    input           [ 4:0]  i_rd_addr,
    input                   i_rd_wr,
    input           [31:0]  i_imm,
    input                   i_ALUsrc1,
    input                   i_ALUsrc2,
    input           [31:0]  i_pc,
    input           [ 4:0]  i_rs1_addr,
    input           [ 4:0]  i_rs2_addr,
    input                   i_flush,
    input                   i_DM_OE,

    input                   i_store,
    input           [ 2:0]  i_funct3,
    input                   i_b_inst,
    input                   i_jal,
    input                   i_jalr,


    output  logic   [ 5:0]  o_mnemonic,
    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [31:0]  o_ALUout,
    output  logic           o_rd_wr,
    output  logic   [31:0]  o_rs2_data,
    output  logic           o_flush,
    output  logic   [31:0]  o_branch_addr,
    output  logic           o_ex_stall,
    output  logic           o_DM_OE,

    output  logic           o_store,
    output  logic   [ 2:0]  o_funct3,

    output  logic           o_ex_LS_stall
);
    logic [5:0] mnemonic;
    logic [31:0] rs1_data, rs2_data;
    logic [4:0] rd_addr, rs1_addr, rs2_addr;
    logic rd_wr, ALUsrc1, ALUsrc2;
    logic [31:0] imm;
    logic [31:0] ALUout;
    logic [31:0] src1, src2;
    logic [31:0] pc;
    logic branch, DM_OE;
    logic [31:0] fw_rs1_data, fw_rs2_data;
    logic b_inst, jalr_inst, jal_inst;
    
    id_ex id_ex0(
        .clk            (clk            ),
        .rst            (rst            ),

        .i_mnemonic     (i_mnemonic     ),
        .i_rs1_data     (i_rs1_data     ),
        .i_rs2_data     (i_rs2_data     ),
        .i_rd_addr      (i_rd_addr      ),
        .i_rd_wr        (i_rd_wr        ),
        .i_imm          (i_imm          ),
        .i_ALUsrc1      (i_ALUsrc1      ),
        .i_ALUsrc2      (i_ALUsrc2      ),
        .i_pc           (i_pc           ),
        .i_rs1_addr     (i_rs1_addr     ),
        .i_rs2_addr     (i_rs2_addr     ),
        .i_flush        (i_flush        ),
        .i_DM_OE        (i_DM_OE        ),
        .i_ex_stall     (o_ex_stall     ),

        .i_store        (i_store        ),
        .i_funct3       (i_funct3       ),
        .i_b_inst       (i_b_inst       ),
        .i_jal          (i_jal          ),
        .i_jalr         (i_jalr         ),

        .o_mnemonic     (mnemonic       ),
        .o_rs1_data     (rs1_data       ),
        .o_rs2_data     (rs2_data       ),
        .o_rd_addr      (rd_addr        ),
        .o_rd_wr        (rd_wr          ),
        .o_imm          (imm            ),
        .o_ALUsrc1      (ALUsrc1        ),
        .o_ALUsrc2      (ALUsrc2        ),
        .o_pc           (pc             ),
        .o_rs1_addr     (rs1_addr       ),
        .o_rs2_addr     (rs2_addr       ),
        .o_DM_OE        (o_DM_OE        ),
        .o_b_inst       (b_inst         ),
        .o_jal          (jal_inst       ),
        .o_jalr         (jalr_inst      ),

        .o_store        (o_store        ),
        .o_funct3       (o_funct3       )
    );
    forward forward0(   
        .i_wb_rd_addr   (i_wb_rd_addr   ),
        .i_wb_rd_data   (i_wb_rd_data   ),
        .i_wb_rd_wr     (i_wb_rd_wr     ),

        .i_mem_rd_addr  (i_mem_rd_addr  ),
        .i_mem_rd_data  (i_mem_rd_data  ),
        .i_mem_rd_wr    (i_mem_rd_wr    ),

        .i_rs1_addr     (rs1_addr       ),
        .i_rs1_data     (rs1_data       ),
        .i_rs2_addr     (rs2_addr       ),
        .i_rs2_data     (rs2_data       ),

        .o_rs1_data     (fw_rs1_data    ),
        .o_rs2_data     (fw_rs2_data    )
    );

    assign src1 = ALUsrc1 ? fw_rs1_data : pc;
    assign src2 = ALUsrc2 ? fw_rs2_data : imm;

    alu alu0(
        .i_mnemonic     (mnemonic       ),
        .i_src1         (src1           ),
        .i_src2         (src2           ),

        .o_ALUout       (ALUout         )
    );


   
    bju bju0(
        .i_b_inst       (b_inst         ),
        .i_funct3       (o_funct3       ),
        .i_jal          (jal_inst       ),
        .i_jalr         (jalr_inst      ),
        .i_src1         (src1           ),
        .i_src2         (src2           ),
        .i_fw_rs1_data  (fw_rs1_data    ),
        .i_imm          (imm            ),
        .i_pc           (pc             ),

        .o_branch       (branch         ),
        .o_branch_addr  (o_branch_addr  )
    );

    assign o_mnemonic   = mnemonic;
    assign o_rd_addr    = rd_addr;
    assign o_rd_wr      = rd_wr;
    assign o_rs2_data   = fw_rs2_data;
    assign o_ALUout     = ALUout;
    assign o_flush      = branch;


    // data hazard
    always_comb begin
        if (o_DM_OE) begin
            o_ex_stall = (i_rs1_addr == rd_addr) || (i_rs2_addr == rd_addr);
        end else begin
            o_ex_stall = 1'b0;
        end
    end

    assign o_ex_LS_stall = o_DM_OE || o_store;

endmodule