module mem_wb(
    input                   clk,
    input                   rst,

    input           [ 4:0]  i_rd_addr,
    input           [31:0]  i_ALUout,
    input                   i_rd_wr,
    input           [31:0]  i_DM_data,
    input                   i_DM_OE,

    output  logic   [ 4:0]  o_rd_addr,
    output  logic   [31:0]  o_ALUout,
    output  logic           o_rd_wr,
    output  logic           o_DM_OE,

    input                   stall,
    output  logic   [31:0]  o_DM_data
);
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            o_rd_addr   <= 'd0;
            o_ALUout    <= 'd0;
            o_rd_wr     <= 'd0;
            o_DM_data   <= 'd0;
            o_DM_OE     <= 'd0;
        end else if (stall) begin
            o_rd_addr   <= 'd0;
            o_ALUout    <= 'd0;
            o_rd_wr     <= 'd0;
            o_DM_data   <= 'd0;
            o_DM_OE     <= 'd0;
        end else begin
            o_rd_addr   <= i_rd_addr;
            o_ALUout    <= i_ALUout;
            o_rd_wr     <= i_rd_wr;
            o_DM_data   <= i_DM_data;
            o_DM_OE     <= i_DM_OE;
        end
    end

endmodule