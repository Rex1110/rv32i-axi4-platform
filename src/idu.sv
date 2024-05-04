`include "../include/define.svh"
`include "./if_id.sv"
`include "./regs.sv"
`include "./control.sv"

module idu(
    input                   clk,
    input                   rst,

    input           [31:0]  i_pc,
    input           [31:0]  i_inst,
    input                   i_valid_inst,
    input                   i_stall,

    input           [31:0]  i_rd_data,
    input           [ 4:0]  i_rd_addr,
    input                   i_rd_wr,

    output  logic   [ 5:0]  o_mnemonic,
    output  logic   [31:0]  o_rs1_data,
    output  logic   [31:0]  o_rs2_data,
    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [ 4:0]  o_rs1_addr,
    output  logic   [ 4:0]  o_rs2_addr,
    output  logic           o_b_inst,
    output  logic           o_jal,
    output  logic           o_jalr,

    output  logic           o_rd_wr,
    output  logic   [31:0]  o_imm,
    output  logic           o_ALUsrc1,
    output  logic           o_ALUsrc2,
    output  logic           o_DM_OE,
    output  logic           o_store,
    output  logic   [ 2:0]  o_funct3,
    output  logic   [31:0]  o_pc
);

    logic [31:0] inst;

    if_id if_id0(
        .clk            (clk         ),
        .rst            (rst         ),

        .i_pc           (i_pc        ),
        .i_inst         (i_inst      ),
        .i_valid_inst   (i_valid_inst),
        .i_stall        (i_stall     ),
        .o_pc           (o_pc        ),
        .o_inst         (inst        )
    );

    control control0(
        .i_inst         (inst       ),

        .o_rd_wr        (o_rd_wr    ),
        .o_imm          (o_imm      ),
        .o_ALUsrc1      (o_ALUsrc1  ),
        .o_ALUsrc2      (o_ALUsrc2  ),
        .o_store        (o_store    ),
        .o_funct3       (o_funct3   ),
        .o_mnemonic     (o_mnemonic ),
        .o_DM_OE        (o_DM_OE    ),
        .o_b_inst       (o_b_inst   ),
        .o_jal          (o_jal      ),
        .o_jalr         (o_jalr     ),

        .o_rd_addr      (o_rd_addr  ),
        .o_rs1_addr     (o_rs1_addr ),
        .o_rs2_addr     (o_rs2_addr )
    );

    regs regs0(
        .clk            (clk        ),
        .rst            (rst        ),

        .i_rd_wr        (i_rd_wr    ),
        .i_rd_addr      (i_rd_addr  ),
        .i_rd_data      (i_rd_data  ),

        .i_rs1_addr     (o_rs1_addr ),
        .i_rs2_addr     (o_rs2_addr ),

        .o_rs1_data     (o_rs1_data ),
        .o_rs2_data     (o_rs2_data )
    );

endmodule