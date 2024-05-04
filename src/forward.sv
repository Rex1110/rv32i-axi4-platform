module forward(
    input           [ 4:0]  i_wb_rd_addr,
    input           [31:0]  i_wb_rd_data,
    input                   i_wb_rd_wr,

    input           [ 4:0]  i_mem_rd_addr,
    input           [31:0]  i_mem_rd_data,
    input                   i_mem_rd_wr,

    input           [ 4:0]  i_rs1_addr,
    input           [31:0]  i_rs1_data,
    input           [ 4:0]  i_rs2_addr,
    input           [31:0]  i_rs2_data,

    output  logic   [31:0]  o_rs1_data,
    output  logic   [31:0]  o_rs2_data
);

    always_comb begin
        if (i_mem_rd_wr && (i_mem_rd_addr == i_rs1_addr) && i_rs1_addr != 5'b0) begin
            o_rs1_data = i_mem_rd_data;
        end else if (i_wb_rd_wr && (i_wb_rd_addr == i_rs1_addr) && i_rs1_addr != 5'b0) begin
            o_rs1_data = i_wb_rd_data;
        end else begin
            o_rs1_data = i_rs1_data;
        end
    end

    always_comb begin
        if (i_mem_rd_wr && (i_mem_rd_addr == i_rs2_addr) && i_rs2_addr != 5'b0) begin
            o_rs2_data = i_mem_rd_data;
        end else if (i_wb_rd_wr && (i_wb_rd_addr == i_rs2_addr) && i_rs2_addr != 5'b0) begin
            o_rs2_data = i_wb_rd_data;
        end else begin
            o_rs2_data = i_rs2_data;
        end
    end
endmodule