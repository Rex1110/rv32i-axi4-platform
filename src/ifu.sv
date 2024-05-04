module ifu(
    input                   clk,
    input                   rst,

    input           [31:0]  i_inst,
    input           [31:0]  i_branch_addr,

    input                   i_flush,
    input                   i_ex_stall,

    output  logic   [31:0]  o_IM_addr,
    output  logic   [31:0]  o_inst,

    input                   i_rvalid_rready,
    output  logic           o_valid_inst
);

    logic [31:0] pc;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            pc <= 'd0;
        end else begin
            if (i_flush) begin
                pc <= i_branch_addr;
            end else if (i_ex_stall) begin
                pc <= pc;
            end else begin
                if (i_rvalid_rready) begin
                    pc <= pc + 'd4;
                end else begin
                    pc <= pc;
                end
            end
        end
    end


    assign o_IM_addr    = pc;
    assign o_inst       = i_inst;
    assign o_valid_inst = i_rvalid_rready;

endmodule