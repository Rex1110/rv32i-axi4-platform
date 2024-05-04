`include "./ex_mem.sv"
`include "./store.sv"
`include "./load.sv"
module memu(
    input                   clk,
    input                   rst,

    
    input           [ 4:0]  i_rd_addr,
    input           [31:0]  i_ALUout,
    input                   i_rd_wr,
    input           [31:0]  i_rs2_data,

    input                   i_store,
    input           [ 2:0]  i_funct3,     
    input                   i_DM_OE,     

    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [31:0]  o_ALUout,
    output  logic           o_rd_wr,

    output  logic           o_DM_CS,
    output  logic   [ 3:0]  o_DM_WEB,
    output  logic   [31:0]  o_DM_addr,
    output  logic   [31:0]  o_DM_DI,

    input   logic   [31:0]  i_DM_DI,
    output  logic           o_DM_OE,

    input                   mem_stall,

    output  logic   [31:0]  o_DM_data
);
    logic [31:0] rs2_data;
    logic [31:0] ALUout;
    logic       store;
    logic [2:0] funct3;
    ex_mem ex_mem0(
        .clk        (clk        ),
        .rst        (rst        ),

        .i_rd_addr  (i_rd_addr  ),
        .i_ALUout   (i_ALUout   ),
        .i_rd_wr    (i_rd_wr    ),
        .i_rs2_data (i_rs2_data ),

        .i_store    (i_store    ),
        .i_funct3   (i_funct3   ),   
        .i_DM_OE    (i_DM_OE    ),

        .o_rd_addr  (o_rd_addr  ),
        .o_ALUout   (ALUout     ),
        .o_rd_wr    (o_rd_wr    ),
        .o_rs2_data (rs2_data   ),
        .o_DM_OE    (o_DM_OE    ),

        .o_store    (store      ),
        .o_funct3   (funct3     ),

        .mem_stall  (mem_stall  )
    );
    //store
    store store0(
        .i_store    (store      ),
        .i_funct3   (funct3     ),
        .i_ALUout   (ALUout     ),
        .i_rs2_data (rs2_data   ),

        .o_DM_CS    (o_DM_CS    ),
        .o_DM_WEB   (o_DM_WEB   ),
        .o_DM_addr  (o_DM_addr  ),
        .o_DM_DI    (o_DM_DI    )
    );


    load load0(
        .i_funct3   (funct3     ),
        .i_ALUout   (ALUout     ),
        .i_DM_DI    (i_DM_DI    ),

        .o_DM_data  (o_DM_data  )
    );
    assign o_ALUout = ALUout;
endmodule