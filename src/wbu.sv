`include "./mem_wb.sv"
module wbu(
    input                   clk,
    input                   rst,

    input           [ 4:0]  i_rd_addr,
    input           [31:0]  i_ALUout,
    input                   i_rd_wr,
    input                   i_DM_OE,

    input           [31:0]  i_DM_data,

    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [31:0]  o_rd_data,
    output  logic           o_rd_wr,

    input                   stall
);
    logic [31:0] ALUout;
    logic [31:0] DM_data;
    logic DM_OE;
    mem_wb mem_wb0(
        .clk        (clk        ),
        .rst        (rst        ),
        
        .i_rd_addr  (i_rd_addr  ),
        .i_ALUout   (i_ALUout   ),
        .i_rd_wr    (i_rd_wr    ),
        .i_DM_data  (i_DM_data  ),
        .i_DM_OE    (i_DM_OE    ),

        .o_rd_addr  (o_rd_addr  ),
        .o_ALUout   (ALUout     ),
        .o_rd_wr    (o_rd_wr    ),
        .o_DM_data  (DM_data    ),
        .o_DM_OE    (DM_OE      ),
        .stall      (stall      )
    );
    assign o_rd_data = DM_OE ? DM_data : ALUout;


endmodule