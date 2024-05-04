module regs(
    input                   clk,
    input                   rst,

    input                   i_rd_wr,

    input           [ 4:0]  i_rd_addr,
    input           [ 4:0]  i_rs1_addr,
    input           [ 4:0]  i_rs2_addr,

    input           [31:0]  i_rd_data,


    output  logic   [31:0]  o_rs1_data,
    output  logic   [31:0]  o_rs2_data
);

    logic [31:0] regs [0:31];
    
    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 32; i++) begin
                regs[i] <= 'd0;
            end
        end else if (i_rd_wr) begin
            regs[i_rd_addr] <= i_rd_data;
        end else begin
            regs[i_rd_addr] <= regs[i_rd_addr];
        end
    end

    always_comb begin
        if (i_rs1_addr == 5'b0) begin
            o_rs1_data = 'd0;
        end else if (i_rd_wr && i_rd_addr == i_rs1_addr) begin
            o_rs1_data = i_rd_data;
        end else begin
            o_rs1_data = regs[i_rs1_addr];
        end
    end

    always_comb begin
        if (i_rs2_addr == 5'b0) begin
            o_rs2_data = 32'b0;
        end else if (i_rd_wr && i_rd_addr == i_rs2_addr) begin
            o_rs2_data = i_rd_data;
        end else begin
            o_rs2_data = regs[i_rs2_addr];
        end
    end

    logic [31:0] ra;
    logic [31:0] sp;
    logic [31:0] gp;
    logic [31:0] tp;
    logic [31:0] t0;
    logic [31:0] t1;
    logic [31:0] t2;
    logic [31:0] s0;
    logic [31:0] s1;
    logic [31:0] a0;
    logic [31:0] a1;
    logic [31:0] a2;
    logic [31:0] a3;
    logic [31:0] a4;
    logic [31:0] a5;
    logic [31:0] a6;
    logic [31:0] a7;
    logic [31:0] s2;
    logic [31:0] s3;
    logic [31:0] s4;
    logic [31:0] s5;
    logic [31:0] s6;
    logic [31:0] s7;
    logic [31:0] s8;
    logic [31:0] s9;
    logic [31:0] s10;
    logic [31:0] s11;
    logic [31:0] t3;
    logic [31:0] t4;
    logic [31:0] t5;
    logic [31:0] t6;

    assign ra   =   regs[1];
    assign sp   =   regs[2];
    assign gp   =   regs[3];
    assign tp   =   regs[4];
    assign t0   =   regs[5];
    assign t1   =   regs[6];
    assign t2   =   regs[7];
    assign s0   =   regs[8];
    assign s1   =   regs[9];
    assign a0   =   regs[10];
    assign a1   =   regs[11];
    assign a2   =   regs[12];
    assign a3   =   regs[13];
    assign a4   =   regs[14];
    assign a5   =   regs[15];
    assign a6   =   regs[16];
    assign a7   =   regs[17];
    assign s2   =   regs[18];
    assign s3   =   regs[19];
    assign s4   =   regs[20];
    assign s5   =   regs[21];
    assign s6   =   regs[22];
    assign s7   =   regs[23];
    assign s8   =   regs[24];
    assign s9   =   regs[25];
    assign s10  =   regs[26];
    assign s11  =   regs[27];
    assign t3   =   regs[28];
    assign t4   =   regs[29];
    assign t5   =   regs[30];
    assign t6   =   regs[31];
    
endmodule