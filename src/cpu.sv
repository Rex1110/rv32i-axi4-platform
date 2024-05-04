`include "./ifu.sv"
`include "./idu.sv"
`include "./exu.sv"
`include "./memu.sv"
`include "./wbu.sv"

module cpu(
    input                   clk,
    input                   rst,

    input           [31:0]  i_IM_inst,
    input           [31:0]  i_DM_DI,

    output logic    [31:0]  o_IM_addr,
    output logic            o_DM_CS,
    output logic    [ 3:0]  o_DM_WEB,
    output logic    [31:0]  o_DM_addr,
    output logic    [31:0]  o_DM_DI,
    output logic            o_DM_OE,

    input                   i_rvalid_rready,

    input                   mem_stall,
    output  logic           o_branch,
    output  logic           o_LS_stall
);


    logic        if_valid_inst;
    logic [31:0] if_inst;

    logic        id_rd_wr, id_ALUsrc1, id_ALUsrc2, id_DM_OE, id_store, id_b_inst, id_jal, id_jalr;
    logic [ 2:0] id_funct3;
    logic [ 4:0] id_rd_addr, id_rs1_addr, id_rs2_addr;
    logic [ 5:0] id_mnemonic;
    logic [31:0] id_pc, id_rs1_data, id_rs2_data, id_imm;



    logic        ex_rd_wr, ex_flush, ex_stall, ex_store, ex_DM_OE, ex_LS_stall;
    logic [ 2:0] ex_funct3;
    logic [ 4:0] ex_rd_addr;
    logic [ 5:0] ex_mnemonic;
    logic [31:0] ex_ALUout, ex_rs2_data, ex_branch_addr;


    logic        mem_rd_wr;
    logic [ 4:0] mem_rd_addr;
    logic [31:0] mem_ALUout;

    logic        wb_rd_wr;
    logic [ 4:0] wb_rd_addr;
    logic [31:0] wb_rd_data;


    logic [31:0] DM_data;

    ifu ifu0(
        .clk            (clk            ),
        .rst            (rst            ),
        
        .i_inst         (i_IM_inst      ),
        .i_flush        (ex_flush       ),
        .i_branch_addr  (ex_branch_addr ),
        .i_ex_stall     (ex_stall       ),

        .o_inst         (if_inst        ),
        .o_IM_addr      (o_IM_addr      ),
        .i_rvalid_rready(i_rvalid_rready),

        .o_valid_inst   (if_valid_inst  )
    );
    idu idu0(
        .clk            (clk            ),
        .rst            (rst            ),

        .i_pc           (o_IM_addr      ),
        .i_inst         (if_inst        ),
        .i_valid_inst   (if_valid_inst  ),
        .i_stall        (id_DM_OE       ),

        .i_rd_data      (wb_rd_data     ),
        .i_rd_addr      (wb_rd_addr     ),
        .i_rd_wr        (wb_rd_wr       ),

        .o_mnemonic     (id_mnemonic    ),
        .o_rs1_data     (id_rs1_data    ),
        .o_rs2_data     (id_rs2_data    ),
        .o_rd_addr      (id_rd_addr     ),
        .o_rd_wr        (id_rd_wr       ),
        .o_imm          (id_imm         ),
        .o_ALUsrc1      (id_ALUsrc1     ),
        .o_ALUsrc2      (id_ALUsrc2     ),
        .o_pc           (id_pc          ),
        .o_rs1_addr     (id_rs1_addr    ),
        .o_rs2_addr     (id_rs2_addr    ),
        .o_DM_OE        (id_DM_OE       ),
        .o_b_inst       (id_b_inst      ),
        .o_jal          (id_jal         ),
        .o_jalr         (id_jalr        ),

        .o_store        (id_store       ),
        .o_funct3       (id_funct3      )
    );


    exu exu0(
        .clk            (clk            ),
        .rst            (rst            ),

        .i_wb_rd_addr   (wb_rd_addr     ),
        .i_wb_rd_data   (wb_rd_data     ),
        .i_wb_rd_wr     (wb_rd_wr       ),
        
        .i_mem_rd_addr  (mem_rd_addr    ),
        .i_mem_rd_data  (mem_ALUout     ),
        .i_mem_rd_wr    (mem_rd_wr      ),

        .i_mnemonic     (id_mnemonic    ),
        .i_rs1_data     (id_rs1_data    ),
        .i_rs2_data     (id_rs2_data    ),
        .i_rd_addr      (id_rd_addr     ),
        .i_rd_wr        (id_rd_wr       ),
        .i_imm          (id_imm         ),
        .i_ALUsrc1      (id_ALUsrc1     ),
        .i_ALUsrc2      (id_ALUsrc2     ),
        .i_pc           (id_pc          ),
        .i_rs1_addr     (id_rs1_addr    ),
        .i_rs2_addr     (id_rs2_addr    ),
        .i_flush        (ex_flush       ),
        .i_DM_OE        (id_DM_OE       ),
        .i_store        (id_store       ),
        .i_funct3       (id_funct3      ),
        .i_b_inst       (id_b_inst      ),
        .i_jal          (id_jal         ),
        .i_jalr         (id_jalr        ),

        .o_mnemonic     (ex_mnemonic    ),
        .o_rd_addr      (ex_rd_addr     ),
        .o_ALUout       (ex_ALUout      ),
        .o_rd_wr        (ex_rd_wr       ),
        .o_rs2_data     (ex_rs2_data    ),
        .o_flush        (ex_flush       ),
        .o_branch_addr  (ex_branch_addr ),
        .o_ex_stall     (ex_stall       ),
        .o_DM_OE        (ex_DM_OE       ),
        
        .o_store        (ex_store       ),
        .o_funct3       (ex_funct3      ),
        

        .o_ex_LS_stall  (ex_LS_stall    )
    );
    assign o_branch = ex_flush;

    memu memu0(
        .clk            (clk            ),
        .rst            (rst            ),

        .i_rd_addr      (ex_rd_addr     ),
        .i_ALUout       (ex_ALUout      ),
        .i_rd_wr        (ex_rd_wr       ),
        .i_rs2_data     (ex_rs2_data    ),
        .i_DM_OE        (ex_DM_OE       ),

        .i_store        (ex_store       ),
        .i_funct3       (ex_funct3      ),

        .o_rd_addr      (mem_rd_addr    ),
        .o_ALUout       (mem_ALUout     ),
        .o_rd_wr        (mem_rd_wr      ),
        .o_DM_CS        (o_DM_CS        ),
        .o_DM_WEB       (o_DM_WEB       ),
        .o_DM_addr      (o_DM_addr      ),
        .o_DM_DI        (o_DM_DI        ),

        .mem_stall      (mem_stall      ),

        .i_DM_DI        (i_DM_DI        ),
        .o_DM_OE        (o_DM_OE        ),

        .o_DM_data      (DM_data        )
    );
    
    wbu wbu0(
        .clk            (clk            ),
        .rst            (rst            ),

        .stall          (mem_stall      ),

        .i_DM_data      (DM_data        ),

        .i_rd_addr      (mem_rd_addr    ),
        .i_ALUout       (mem_ALUout     ),
        .i_rd_wr        (mem_rd_wr      ),
        .i_DM_OE        (o_DM_OE        ),

        .o_rd_addr      (wb_rd_addr     ),
        .o_rd_data      (wb_rd_data     ),
        .o_rd_wr        (wb_rd_wr       )
    );

    assign o_LS_stall = id_store || id_DM_OE || ex_LS_stall || mem_stall;

endmodule