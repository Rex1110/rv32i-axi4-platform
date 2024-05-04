module if_id(
    input                   clk,
    input                   rst,
    input           [31:0]  i_pc,
    input           [31:0]  i_inst,
    input                   i_valid_inst,
    input                   i_stall,

    output  logic   [31:0]  o_pc,
    output  logic   [31:0]  o_inst
);

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            o_pc   <= 'd0;
            o_inst <= 'd0;
        end else begin
            if (i_valid_inst && ~i_stall) begin
                o_pc   <= i_pc;
                o_inst <= i_inst;
            end else begin
                o_pc   <= 'd0;
                o_inst <= 'd0;
            end
        end
    end


endmodule