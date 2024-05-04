module ex_mem(

    input                   clk,
    input                   rst,

    input                   i_rd_wr,
    input           [ 4:0]  i_rd_addr,
    input           [31:0]  i_ALUout,
    input           [31:0]  i_rs2_data,

    input                   i_store,
    input           [ 2:0]  i_funct3,
    input                   i_DM_OE,

    output  logic           o_rd_wr,
    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [31:0]  o_ALUout,
    output  logic   [31:0]  o_rs2_data,
    output  logic           o_DM_OE,
    input                   mem_stall,

    output  logic           o_store,
    output  logic   [ 2:0]  o_funct3
);

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            o_rd_wr     <= 'd0;
            o_rd_addr   <= 'd0;
            o_ALUout    <= 'd0;
            o_rs2_data  <= 'd0;
            o_store     <= 'd0;
            o_funct3    <= 'd0;
            o_DM_OE     <= 'd0;
        end else if (mem_stall) begin
            o_rd_wr     <= o_rd_wr   ;
            o_rd_addr   <= o_rd_addr ;
            o_ALUout    <= o_ALUout  ;
            o_rs2_data  <= o_rs2_data;
            o_store     <= o_store ;
            o_funct3    <= o_funct3;
            o_DM_OE     <= o_DM_OE;
        end else begin
            o_rd_wr     <= i_rd_wr;
            o_rd_addr   <= i_rd_addr;
            o_ALUout    <= i_ALUout;
            o_rs2_data  <= i_rs2_data;
            o_store     <= i_store ;
            o_funct3    <= i_funct3;
            o_DM_OE     <= i_DM_OE;
        end
    end

endmodule